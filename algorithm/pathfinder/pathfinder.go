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
	Radius           float64
	MaxVelocity      float64
	MaxAcceleration  float64
	SkidAcceleration float64
	MaxJerk          float64
	CycleTime        float64
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

		point.Action = segmentClassifier.GetAction()

		trajectory = append(trajectory, &point)
	}

	segmentClassifier.AddLastHeading(len(trajectory))

	// TODO: export all kinematics to thier corresponding file
	CalculateKinematics(trajectory, robot)
	CalculateKinematicsReverse(trajectory, robot)
	CalculateDtAndOmega(trajectory, true)

	headingPoints := segmentClassifier.GetHeadingPoints()
	LimitVelocityWithCentrifugalForce(trajectory, robot, headingPoints)

	CalculateKinematics(trajectory, robot)
	CalculateKinematicsReverse(trajectory, robot)
	CalculateDtAndOmega(trajectory, true)

	return trajectory, nil
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
	CalculateDtAndOmega(trajectoryPoints, false)

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

			for trajectoryPointIndex := currentHeadingPoint.index + 1; trajectoryPointIndex < len(trajectoryPoints); trajectoryPointIndex++ {
				trajectoryPoints[trajectoryPointIndex].Omega *= omegaScaleFactor
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
			)

			if headingPointIndex <= len(headingPoints)-2 {
				for trajectoryPointIndex := nextHeadingPoint.index + 1; trajectoryPointIndex < len(trajectoryPoints); trajectoryPointIndex++ {
					trajectoryPoints[trajectoryPointIndex].Heading += dHeadingLeft
				}
			}
		}
	}
}

func SetHeading(trajectoryPoints []*TrajectoryPoint, dHeading float64, headingStartIndex int, headingEndIndex int) {
	const distancePercentageForAngularAcceleration float64 = 0.1
	const oneMinusDistancePercentageForAcceleration float64 = 1 - distancePercentageForAngularAcceleration
	const twiceAccelerationPercentageTimesOneMinus = 2 * distancePercentageForAngularAcceleration * oneMinusDistancePercentageForAcceleration

	travelDistance := trajectoryPoints[headingEndIndex].Distance - trajectoryPoints[headingStartIndex].Distance

	distanceToAccelerate := distancePercentageForAngularAcceleration * travelDistance

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

func GetFirstPoint(distance float64, robot *RobotParameters) *TrajectoryPoint {
	firstPointTime := math.Pow(6*distance/robot.MaxJerk, float64(1)/float64(3))

	return &TrajectoryPoint{
		Time:         firstPointTime,
		Velocity:     0.5 * robot.MaxJerk * firstPointTime * firstPointTime,
		Acceleration: robot.MaxJerk * firstPointTime,
	}
}

func CalculateKinematics(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters) {
	firstPoint := GetFirstPoint(trajectoryPoints[1].Distance, robot)
	trajectoryPoints[1].Time = firstPoint.Time
	trajectoryPoints[1].Velocity = firstPoint.Velocity
	trajectoryPoints[1].Acceleration = firstPoint.Acceleration

	for i := 2; i < len(trajectoryPoints); i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt

		maxVelAccordingToOmega := math.Max(robot.MaxVelocity-math.Abs(robot.Radius*currentPoint.Omega), 0)

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
			robot.MaxAcceleration*(1-prevPoint.Velocity/maxVelAccordingToOmega),
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, maxVelAccordingToOmega, prevPoint.Velocity+prevPoint.Acceleration*dt)
		currentPoint.Time = prevPoint.Time + dt
	}
}

func CalculateKinematicsReverse(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters) {
	lastPoint := trajectoryPoints[len(trajectoryPoints)-1]
	secondToLastPoint := trajectoryPoints[len(trajectoryPoints)-2]
	distanceBetweenLastTwoPoints := lastPoint.Distance - secondToLastPoint.Distance

	firstPoint := GetFirstPoint(distanceBetweenLastTwoPoints, robot)

	trajectoryPoints[len(trajectoryPoints)-2].Time = firstPoint.Time
	trajectoryPoints[len(trajectoryPoints)-2].Velocity = firstPoint.Velocity
	trajectoryPoints[len(trajectoryPoints)-2].Acceleration = firstPoint.Acceleration

	trajectoryPoints[len(trajectoryPoints)-1].Velocity = 0
	trajectoryPoints[len(trajectoryPoints)-1].Acceleration = 0

	for i := len(trajectoryPoints) - 3; i >= 0; i-- {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i+1]

		distanceFromPrevPoint := prevPoint.Distance - currentPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (prevPoint.Heading - currentPoint.Heading) / dt

		maxVelAccordingToOmega := robot.MaxVelocity - math.Abs(robot.Radius*currentPoint.Omega)

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			robot.MaxAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, maxVelAccordingToOmega, prevPoint.Velocity+prevPoint.Acceleration*dt)
	}
}

func CalculateDtAndOmega(trajectoryPoints []*TrajectoryPoint, calculateOmega bool) {
	trajectoryPoints[0].Time = 0

	// * The time of the "first point" found in reverse run
	timeBetweenLastTwoPoints := trajectoryPoints[len(trajectoryPoints)-2].Time

	// TODO second point time and omega (point at index 1)

	for i := 2; i < len(trajectoryPoints)-1; i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		if calculateOmega {
			currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
		}

		currentPoint.Time = prevPoint.Time + dt
	}
	trajectoryPoints[len(trajectoryPoints)-1].Time = trajectoryPoints[len(trajectoryPoints)-2].Time + timeBetweenLastTwoPoints
}

func SearchForTime(trajectoryPoints []*TrajectoryPoint, time float64, lastSearchIndex int) int {
	for index, point := range trajectoryPoints[lastSearchIndex:] {
		if point.Time >= time {
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
