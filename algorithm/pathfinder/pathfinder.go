package pathfinder

import (
	"math"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

const deltaDistanceForEvaluation = 1e-4

type TrajectoryPoint struct {
	Time         float64
	S            float64
	Distance     float64
	Position     vector.Vector
	Velocity     float64
	Acceleration float64
	Heading      float64
	Omega        float64
	Action       string
}

type RobotParameters struct {
	Radius               float64
	MaxVelocity          float64
	MaxAcceleration      float64
	SkidAcceleration     float64
	MaxJerk              float64
	CycleTime            float64
	AngularAccPercentage float64
}

type indexedHeadingPoint struct {
	index   int
	heading float64
}

func CreateTrajectoryPointArray(path *spline.Path, robot *RobotParameters, segments []*rpc.Segment) ([]*TrajectoryPoint, error) {
	firstPoint := TrajectoryPoint{Distance: 0, S: 0, Position: path.Evaluate(0), Velocity: 0, Acceleration: 0, Time: 0}

	trajectory := []*TrajectoryPoint{&firstPoint}

	segmentClassifier := NewSegmentClassifier(segments)

	pathDerivative := path.Derivative()
	ds := deltaDistanceForEvaluation / (pathDerivative.Evaluate(0).Norm() * float64(path.NumberOfSplines))

	for s := ds; s <= 1; s += ds {
		ds = deltaDistanceForEvaluation / (pathDerivative.Evaluate(s).Norm() * float64(path.NumberOfSplines))

		point := TrajectoryPoint{S: s, Position: path.Evaluate(s)}

		prevPointToCurrent := point.Position.Sub(trajectory[len(trajectory)-1].Position)
		distanceToPrevPoint := prevPointToCurrent.Norm()
		point.Distance = trajectory[len(trajectory)-1].Distance + distanceToPrevPoint

		segmentClassifier.Update(&point.Position, len(trajectory))

		point.Velocity = segmentClassifier.GetMaxVel()

		trajectory = append(trajectory, &point)
	}

	segmentClassifier.AddLastHeading(len(trajectory))
	segmentClassifier.AddLastAction(len(trajectory))

	trajectory = DoKinematics(trajectory, robot)

	headingPoints := segmentClassifier.GetHeadingPoints()
	LimitVelocityWithCentrifugalForce(trajectory, robot, headingPoints)

	trajectory = DoKinematics(trajectory, robot)

	CalculateHeadingTrapezoid(trajectory, headingPoints, robot)

	quantizedTrajectory := QuantizeTrajectory(trajectory, robot.CycleTime)

	actionPoints := segmentClassifier.GetActionPoints()

	for _, indexedActionPoint := range actionPoints {
		indexedActionPoint.absoluteTime = float32(trajectory[indexedActionPoint.index].Time) + indexedActionPoint.action.Time
	}

	if len(actionPoints) > 0 {
		// * Limiting time of last action to the time of the quantized profile
		lastActionTime := actionPoints[len(actionPoints)-1].absoluteTime

		// * Subtract Cycletime/2 because floating point inaccurasies cause the last cycle to be ignored
		lastRowTime := float64(len(quantizedTrajectory)-1)*robot.CycleTime - robot.CycleTime*0.5
		actionPoints[len(actionPoints)-1].absoluteTime =
			float32(math.Min(float64(lastActionTime), lastRowTime))

		// * Placing the actions in the trajectory
		addActions(quantizedTrajectory, actionPoints, segmentClassifier)
	}

	ReverseTime(quantizedTrajectory) // * In the output file, the time goes backwards

	return quantizedTrajectory, nil
}

func addActions(trajectory []*TrajectoryPoint, actions []*indexedActionPoint, s *SegmentClassifier) {
	prevTimeSearchIndex := 0
	for _, action := range actions {
		timeSearchIndex := SearchForTime(trajectory, float64(action.absoluteTime), prevTimeSearchIndex)
		if timeSearchIndex == -1 {
			continue // * Ignoring actions out of the profile
		}

		isNotEdgePoint := (action.wayPointIndex > 0 && action.wayPointIndex < len(s.wayPoints)-1)

		isFirstAndAfterPoint := (action.wayPointIndex == 0 && action.action.Time > 0)

		isLastAndBeforeOrAtPoint := action.wayPointIndex == len(s.wayPoints)-1 && action.action.Time <= 0

		// * Place action on the correct section when they are on an edge stop
		if isNotEdgePoint || isFirstAndAfterPoint || isLastAndBeforeOrAtPoint {
			trajectory[timeSearchIndex].Action = action.action.ActionType
		}

		prevTimeSearchIndex = timeSearchIndex
	}
}

func calculatePointHeading(trajectory []*TrajectoryPoint, pointIndex int) {
	// * Taking the average omega between current and previous point
	averageOmega := (trajectory[pointIndex].Omega + trajectory[pointIndex-1].Omega) / 2
	dt := trajectory[pointIndex].Time - trajectory[pointIndex-1].Time
	// * x(t) = x0 + vt
	trajectory[pointIndex].Heading = trajectory[pointIndex-1].Heading + averageOmega*dt
}

func LimitVelocityWithCentrifugalForce(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters, headingPoints []*indexedHeadingPoint) {
	trajectoryPointsCount := len(trajectoryPoints)

	currentHeadingPointIndex := 0

	// * Setting heading of first points
	trajectoryPoints[0].Heading = headingPoints[0].heading
	trajectoryPoints[1].Heading = headingPoints[0].heading

	// * Setting heading of last point
	trajectoryPoints[trajectoryPointsCount-1].Heading = headingPoints[len(headingPoints)-1].heading

	for i := 1; i < trajectoryPointsCount-1; i++ {
		prevTrajectoryPoint := trajectoryPoints[i-1]
		currentTrajectoryPoint := trajectoryPoints[i]
		nextTrajectoryPoint := trajectoryPoints[i+1]

		prevPointToCurrent := currentTrajectoryPoint.Position.Sub(prevTrajectoryPoint.Position)

		distanceToPrevPoint := currentTrajectoryPoint.Distance - prevTrajectoryPoint.Distance

		currentPointToNextPoint := nextTrajectoryPoint.Position.Sub(currentTrajectoryPoint.Position)
		dAngle := math.Abs(utils.WrapAngle(currentPointToNextPoint.Angle() - prevPointToCurrent.Angle()))

		driveRadius := 0.0

		if dAngle == 0 {
			driveRadius = math.Inf(1)
		} else {
			driveRadius = distanceToPrevPoint / dAngle
		}

		maxVelAccordingToCentrifugalForce := math.Sqrt(driveRadius * robot.SkidAcceleration)
		if maxVelAccordingToCentrifugalForce < trajectoryPoints[i].Velocity {
			wantedDHeading := headingPoints[currentHeadingPointIndex+1].heading - headingPoints[currentHeadingPointIndex].heading
			// * Transferring what's left of the velocity to omega
			trajectoryPoints[i].Omega = float64(utils.Signum(wantedDHeading)) * (trajectoryPoints[i].Velocity - maxVelAccordingToCentrifugalForce) / robot.Radius

			// * Setting the max velocity at this point
			trajectoryPoints[i].Velocity = maxVelAccordingToCentrifugalForce
		}

		if i >= headingPoints[currentHeadingPointIndex+1].index {
			currentHeadingPointIndex++
			trajectoryPoints[i].Heading = headingPoints[currentHeadingPointIndex].heading
		}
	}

	// * After new velocity
	CalculateDt(trajectoryPoints)

	for i := 1; i < len(trajectoryPoints); i++ {
		// * Calculating heading via integration of omega
		calculatePointHeading(trajectoryPoints, i)
	}

	for headingPointIndex := 0; headingPointIndex < len(headingPoints)-1; headingPointIndex++ {
		currentHeadingPoint := headingPoints[headingPointIndex]
		nextHeadingPoint := headingPoints[headingPointIndex+1]

		headingEnd := trajectoryPoints[nextHeadingPoint.index].Heading
		wantedDeltaHeading := nextHeadingPoint.heading - currentHeadingPoint.heading
		currentDeltaHeading := headingEnd - trajectoryPoints[currentHeadingPoint.index+1].Heading

		if math.Abs(currentDeltaHeading) > math.Abs(wantedDeltaHeading) {
			// * scale omega
			omegaScaleFactor := math.Abs(wantedDeltaHeading / currentDeltaHeading)

			if wantedDeltaHeading == 0 {
				omegaScaleFactor = 0
			}

			for trajectoryPointIndex := currentHeadingPoint.index + 1; trajectoryPointIndex < nextHeadingPoint.index; trajectoryPointIndex++ {
				trajectoryPoints[trajectoryPointIndex].Omega *= omegaScaleFactor

			}

			for trajectoryPointIndex := currentHeadingPoint.index + 1; trajectoryPointIndex < len(trajectoryPoints); trajectoryPointIndex++ {
				// * Update heading again according to new omega
				calculatePointHeading(trajectoryPoints, trajectoryPointIndex)
			}

		} else {
			// * spread left heading on top of current heading
			dHeadingLeft := utils.WrapAngle(wantedDeltaHeading - currentDeltaHeading)
			SetHeading(
				trajectoryPoints,
				dHeadingLeft,
				currentHeadingPoint.index,
				nextHeadingPoint.index,
				robot,
			)

			if headingPointIndex <= len(headingPoints)-2 {
				for trajectoryPointIndex := nextHeadingPoint.index + 1; trajectoryPointIndex < len(trajectoryPoints); trajectoryPointIndex++ {
					trajectoryPoints[trajectoryPointIndex].Heading += dHeadingLeft
				}
			}
		}
	}
}

func SetHeading(trajectoryPoints []*TrajectoryPoint, dHeading float64, headingStartIndex int, headingEndIndex int, robot *RobotParameters) {
	oneMinusDistancePercentageForAcceleration := 1 - robot.AngularAccPercentage
	twiceAccelerationPercentageTimesOneMinus := 2 * robot.AngularAccPercentage * oneMinusDistancePercentageForAcceleration

	travelDistance := trajectoryPoints[headingEndIndex].Distance - trajectoryPoints[headingStartIndex].Distance

	distanceToAccelerate := robot.AngularAccPercentage * travelDistance

	travelDistanceSquared := math.Pow(travelDistance, 2)

	angularAcceleration := dHeading / (twiceAccelerationPercentageTimesOneMinus * travelDistanceSquared)
	constantOmega := dHeading / (oneMinusDistancePercentageForAcceleration * travelDistance)

	headingAtEndOfAcceleration := angularAcceleration * math.Pow(distanceToAccelerate, 2)

	for i := headingStartIndex; i <= headingEndIndex; i++ {
		distanceFromStartOfRotation := trajectoryPoints[i].Distance - trajectoryPoints[headingStartIndex].Distance

		if distanceFromStartOfRotation < distanceToAccelerate {
			// * Acceleration parabola
			trajectoryPoints[i].Heading += angularAcceleration * math.Pow(distanceFromStartOfRotation, 2)

		} else if distanceFromStartOfRotation < travelDistance-distanceToAccelerate {
			// * Constant omega linear interpolation
			trajectoryPoints[i].Heading += headingAtEndOfAcceleration + constantOmega*(distanceFromStartOfRotation-distanceToAccelerate)

		} else {
			// * Deceleration parabola
			trajectoryPoints[i].Heading += dHeading - angularAcceleration*math.Pow(travelDistance-distanceFromStartOfRotation, 2)
		}
	}
}

func SearchForTime(trajectoryPoints []*TrajectoryPoint, time float64, lastSearchIndex int) int {
	for index, point := range trajectoryPoints[lastSearchIndex:] {
		if point.Time > time {
			return index + lastSearchIndex
		}
	}
	return -1
}

func QuantizeTrajectory(trajectoryPoints []*TrajectoryPoint, cycleTime float64) []*TrajectoryPoint {
	quantizedTrajectory := []*TrajectoryPoint{trajectoryPoints[0]}

	lastPointTime := trajectoryPoints[len(trajectoryPoints)-1].Time

	searchIndex := 0

	for t := cycleTime; t <= lastPointTime; t += cycleTime {
		searchIndex = SearchForTime(trajectoryPoints, t, searchIndex)
		nextPoint := trajectoryPoints[searchIndex]
		prevPoint := trajectoryPoints[searchIndex-1]
		nextToPreviousPointRatio := utils.ReverseLerp(prevPoint.Time, nextPoint.Time, t)

		// TODO remove Distance and Acceleration calculation (not used)
		quantizedPoint := TrajectoryPoint{
			Time:         t,
			S:            utils.Lerp(prevPoint.S, nextPoint.S, nextToPreviousPointRatio),
			Distance:     utils.Lerp(prevPoint.Distance, nextPoint.Distance, nextToPreviousPointRatio),
			Position:     vector.Lerp(prevPoint.Position, nextPoint.Position, nextToPreviousPointRatio),
			Velocity:     utils.Lerp(prevPoint.Velocity, nextPoint.Velocity, nextToPreviousPointRatio),
			Acceleration: utils.Lerp(prevPoint.Acceleration, nextPoint.Acceleration, nextToPreviousPointRatio),
			Heading:      utils.Lerp(prevPoint.Heading, nextPoint.Heading, nextToPreviousPointRatio),
			Omega:        utils.Lerp(prevPoint.Omega, nextPoint.Omega, nextToPreviousPointRatio),
		}
		quantizedTrajectory = append(quantizedTrajectory, &quantizedPoint)
	}

	return quantizedTrajectory
}

func CalculateHeadingTrapezoid(trajectoryPoints []*TrajectoryPoint, headingPoints []*indexedHeadingPoint, robot *RobotParameters) {
	for headingPointIndex := 0; headingPointIndex < len(headingPoints)-1; headingPointIndex++ {
		headingPoint := headingPoints[headingPointIndex]
		nextHeadingPoint := headingPoints[headingPointIndex+1]

		headingTrajectoryPoint := trajectoryPoints[headingPoint.index]
		nextHeadingTrajectoryPoint := trajectoryPoints[nextHeadingPoint.index]

		deltaHeading := utils.WrapAngle(nextHeadingTrajectoryPoint.Heading - headingTrajectoryPoint.Heading)

		deltaTime := nextHeadingTrajectoryPoint.Time - headingTrajectoryPoint.Time

		t0 := 0.08 // TODO Add to robot parameters
		t1 := deltaTime * robot.AngularAccPercentage

		// Checkpoints in the trapezoid:
		t1Time := t0 + t1              // End of increase
		tMiddle := deltaTime - t0 - t1 // Start of decrease
		t1AftertMiddle := tMiddle + t1 // End of decrease

		maxOmega := deltaHeading / (deltaTime - 2*t0 - t1)
		angleAcc := maxOmega / t1

		for i := headingPoint.index; i <= nextHeadingPoint.index; i++ {

			t := trajectoryPoints[i].Time - headingTrajectoryPoint.Time

			if t < t0 {
				trajectoryPoints[i].Omega = 0 // Before trapezoid (To Start driving before turning so that modules don't start diagonaly)
			}

			if t > t0 && t < t1Time {
				trajectoryPoints[i].Omega = angleAcc * (t - t0) // Increase of trapezoid
			}
			if t > t1Time && t < tMiddle {
				trajectoryPoints[i].Omega = maxOmega // Max of trapezoid
			}

			if t > tMiddle && t < t1AftertMiddle {
				trajectoryPoints[i].Omega = maxOmega - (t-tMiddle)*angleAcc // Decrease of trapezoid
			}

			if t > t1AftertMiddle {
				trajectoryPoints[i].Omega = 0 // After trapezoid
			}

			var prevPointTime float64
			var prevHeading float64
			if i == 0 {
				prevPointTime = trajectoryPoints[0].Time
				prevHeading = trajectoryPoints[0].Heading
			} else {
				prevPointTime = trajectoryPoints[i-1].Time
				prevHeading = trajectoryPoints[i-1].Heading
			}

			dt := trajectoryPoints[i].Time - prevPointTime
			trajectoryPoints[i].Heading = utils.WrapAngle(prevHeading + trajectoryPoints[i].Omega*dt)
		}
	}
}

type SwerveTrajectoryPoint struct {
	Time     float64
	Position vector.Vector
	Velocity vector.Vector
	Heading  float64
	Omega    float64
	Action   string
}

func Get2DTrajectory(trajectory1D []*TrajectoryPoint, path spline.Spline) []SwerveTrajectoryPoint {
	swerveTrajectory := []SwerveTrajectoryPoint{}

	pathDerivative := path.Derivative()

	for _, trajectoryPoint1D := range trajectory1D {
		swerveTrajectory = append(swerveTrajectory, SwerveTrajectoryPoint{
			Time:     trajectoryPoint1D.Time,
			Position: trajectoryPoint1D.Position,
			Velocity: vector.FromPolar(pathDerivative.Evaluate(trajectoryPoint1D.S).Angle(), trajectoryPoint1D.Velocity),
			Heading:  trajectoryPoint1D.Heading,
			Omega:    trajectoryPoint1D.Omega,
			Action:   trajectoryPoint1D.Action,
		})
	}

	return swerveTrajectory
}

func ToRpcSwervePoint(point *SwerveTrajectoryPoint) *rpc.TrajectoryResponse_SwervePoint {
	return &rpc.TrajectoryResponse_SwervePoint{
		Time:            float32(point.Time),
		Position:        point.Position.ToRpc(),
		Velocity:        point.Velocity.ToRpc(),
		Heading:         float32(point.Heading),
		AngularVelocity: float32(point.Omega),
		Action:          point.Action,
	}
}

func ReverseTime(trajectory []*TrajectoryPoint) {
	for i, j := 0, len(trajectory)-1; i < j; i, j = i+1, j-1 {
		trajectory[i].Time, trajectory[j].Time = trajectory[j].Time, trajectory[i].Time
	}
}
