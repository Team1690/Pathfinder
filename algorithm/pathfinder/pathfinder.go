package pathfinder

import (
	"math"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
	"golang.org/x/xerrors"
)

const deltaDistanceForEvaluation = 0.00001

type TrajectoryPoint struct {
	Time         float64
	S            float64
	Distance     float64
	Position     vector.Vector
	Velocity     float64
	Acceleration float64
	Heading      float64
	Omega        float64
}

type RobotParameters struct {
	Radius           float64
	MaxVelocity      float64
	MaxAcceleration  float64
	SkidAcceleration float64
	MaxJerk          float64
	CycleTime        float64
}

func getSegmentIndexBySplineIndex(segments []*rpc.Segment, splineIndex int) (int, error) {
	numberOfSplinesUntilCurrentSegment := 0
	for index, segment := range segments {
		if splineIndex >= numberOfSplinesUntilCurrentSegment {
			return index, nil
		}

		numberOfSplinesUntilCurrentSegment += len(segment.Points) - 1
	}

	return -1, xerrors.New("spline index is greater than number of splines in segments")
}

// Waypoint is a point which is used to define the splines (position, control in/out, heading, useHeading...)
func getWaypointByIndex(segments []*rpc.Segment, pointIndex int) *rpc.Point {
	numberOfPointUntilCurrentSegment := 0
	for _, segment := range segments {
		if pointIndex <= numberOfPointUntilCurrentSegment+len(segment.Points) {
			return segment.Points[pointIndex-numberOfPointUntilCurrentSegment]
		}

		numberOfPointUntilCurrentSegment += len(segment.Points) - 1
	}

	return nil
}

type indexedHeadingPoint struct {
	index   int
	heading float64
}

func CreateTrajectoryPointArray(path *spline.Path, robot *RobotParameters, segments []*rpc.Segment) ([]*TrajectoryPoint, error) {
	firstPoint := TrajectoryPoint{Distance: 0, S: 0, Position: path.Evaluate(0), Velocity: 0, Time: 0}

	trajectory := []*TrajectoryPoint{&firstPoint}

	prevSplineIndex := 0

	headingPoints := []*indexedHeadingPoint{
		{index: 0, heading: float64(segments[0].Points[0].Heading)}, // * Always using first point's heading
	}

	pathDerivative := path.Derivative()

	ds := deltaDistanceForEvaluation / (pathDerivative.Evaluate(0).Norm() * float64(path.NumberOfSplines))

	currentHeading := segments[0].Points[0].Heading

	for s := ds; s <= 1; s += ds {
		ds = deltaDistanceForEvaluation / (pathDerivative.Evaluate(s).Norm() * float64(path.NumberOfSplines))

		point := TrajectoryPoint{S: s, Position: path.Evaluate(s)}

		prevPointToCurrent := point.Position.Sub(trajectory[len(trajectory)-1].Position)
		distanceToPrevPoint := prevPointToCurrent.Norm()
		point.Distance = trajectory[len(trajectory)-1].Distance + distanceToPrevPoint

		splineIndex := path.GetSplineIndex(s + ds)

		currentSegmentIndex, err := getSegmentIndexBySplineIndex(segments, splineIndex)
		if err != nil {
			return nil, xerrors.Errorf("error in getting segment for point: %w", err)
		}

		point.Velocity = float64(segments[currentSegmentIndex].MaxVelocity)

		if splineIndex != prevSplineIndex {
			waypoint := getWaypointByIndex(segments, splineIndex)
			currentHeading = waypoint.Heading
			if waypoint.UseHeading && s+ds < 1 {
				headingPoints = append(headingPoints, &indexedHeadingPoint{
					index:   len(trajectory),
					heading: float64(waypoint.Heading),
				})
			}
		}

		point.Heading = float64(currentHeading)

		trajectory = append(trajectory, &point)

		prevSplineIndex = splineIndex
	}

	// * Adding the final heading
	lastSegment := segments[len(segments)-1]
	lastPoint := lastSegment.Points[len(lastSegment.Points)-1]
	if lastPoint.UseHeading {
		headingPoints = append(headingPoints, &indexedHeadingPoint{index: len(trajectory) - 1, heading: float64(lastPoint.Heading)})
	} else {
		// * If the last point doesn't use heading, the heading at the end is the previous heading
		headingPoints = append(headingPoints, &indexedHeadingPoint{index: len(trajectory) - 1, heading: float64(headingPoints[len(headingPoints)-1].heading)})
	}

	calculateKinematicsNoHeading(trajectory, robot)
	calculateKinematicsReverseNoHeading(trajectory, robot)
	CalculateDtAndOmegaAfterReverse(trajectory)
	LimitVelocityWithCentrifugalForce(trajectory, robot, headingPoints)

	// for i := 0; i < len(headingPoints)-1; i++ {
	// 	currentHeadingChangePoint := headingPoints[i]
	// 	nextHeadingChangePoint := headingPoints[i+1]
	// 	SetHeading(
	// 		trajectory,
	// 		currentHeadingChangePoint.heading,
	// 		nextHeadingChangePoint.heading,
	// 		currentHeadingChangePoint.index,
	// 		nextHeadingChangePoint.index,
	// 	)
	// }

	return trajectory, nil
}

func LimitVelocityWithCentrifugalForce(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters, headingPoints []*indexedHeadingPoint) {
	trajectoryPointsCount := len(trajectoryPoints)
	for i := 1; i < trajectoryPointsCount-1; i++ {
		prevPointToCurrent := trajectoryPoints[i].Position.Sub(trajectoryPoints[i-1].Position)

		distanceToPrevPoint := prevPointToCurrent.Norm()

		currentPointToNextPoint := trajectoryPoints[i+1].Position.Sub(trajectoryPoints[i].Position)
		dAngle := math.Abs(utils.WrapAngle(currentPointToNextPoint.Angle() - prevPointToCurrent.Angle()))

		driveRadius := 0.0

		if dAngle == 0 {
			driveRadius = math.Inf(1)
		} else {
			driveRadius = distanceToPrevPoint / dAngle
		}

		maxVelAccordingToCentrifugalForce := math.Sqrt(driveRadius * robot.SkidAcceleration)

		var maxVelAccordingToRobotAcceleration float64

		if trajectoryPoints[i].Velocity > trajectoryPoints[i-1].Velocity {
			maxVelAccordingToRobotAcceleration = trajectoryPoints[i].Velocity
		} else {
			maxVelAccordingToRobotAcceleration = robot.MaxVelocity
		}

		// * This is the max velocity allowed at this point
		trajectoryPoints[i].Velocity = math.Min(trajectoryPoints[i].Velocity, maxVelAccordingToCentrifugalForce)

		trajectoryPoints[i].Omega = (maxVelAccordingToRobotAcceleration - trajectoryPoints[i].Velocity) / driveRadius
	}

	for headingPointIndex := 0; headingPointIndex < len(headingPoints)-1; headingPointIndex++ {
		currentHeadingPoint := headingPoints[headingPointIndex]
		nextHeadingPoint := headingPoints[headingPointIndex+1]

		trajectoryPoints[currentHeadingPoint.index].Heading = currentHeadingPoint.heading
		for trajectoryPointIndex := currentHeadingPoint.index + 1; trajectoryPointIndex < nextHeadingPoint.index; trajectoryPointIndex++ {
			currentTrajectoryPoint := trajectoryPoints[trajectoryPointIndex]
			prevTrajectoryPoint := trajectoryPoints[trajectoryPointIndex-1]

			averageOmega := (currentTrajectoryPoint.Omega + prevTrajectoryPoint.Omega) / 2
			dt := currentTrajectoryPoint.Time - prevTrajectoryPoint.Time

			trajectoryPoints[trajectoryPointIndex].Heading = trajectoryPoints[trajectoryPointIndex-1].Heading + averageOmega*dt
		}

		headingEnd := trajectoryPoints[nextHeadingPoint.index-1].Heading
		wantedDeltaHeading := nextHeadingPoint.heading - currentHeadingPoint.heading
		actualDeltaHeading := headingEnd - currentHeadingPoint.heading

		if headingEnd >= nextHeadingPoint.heading {
			// * scale omega
			omegaScaleFactor := wantedDeltaHeading / actualDeltaHeading

			for trajectoryPointIndex := currentHeadingPoint.index; trajectoryPointIndex < nextHeadingPoint.index; trajectoryPointIndex++ {
				trajectoryPoints[trajectoryPointIndex].Omega *= omegaScaleFactor
			}
		} else {
			// * spread left heading on top of current heading
			dHeadingLeft := wantedDeltaHeading - actualDeltaHeading
			SetHeading(
				trajectoryPoints,
				dHeadingLeft,
				currentHeadingPoint.index,
				nextHeadingPoint.index,
			)
		}
	}

	// for _, point := range trajectoryPoints {
	// 	fmt.Println(point.Heading)
	// }

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

	for i := headingStartIndex; i <= headingEndIndex; i++ {
		distanceFromStartOfRotation := trajectoryPoints[i].Distance - trajectoryPoints[headingStartIndex].Distance

		if distanceFromStartOfRotation < distanceToAccelerate {
			// Acceleration parabola
			trajectoryPoints[i].Heading += angularAcceleration * math.Pow(distanceFromStartOfRotation, 2)

		} else if distanceFromStartOfRotation < travelDistance-distanceToAccelerate {
			// Constant omega linear interpolation
			trajectoryPoints[i].Heading += constantOmega * (distanceFromStartOfRotation - distanceToAccelerate)

		} else {
			// Deceleration parabola
			trajectoryPoints[i].Heading += angularAcceleration * math.Pow(travelDistance-distanceFromStartOfRotation, 2)
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

func calculateKinematicsNoHeading(trajectory []*TrajectoryPoint, robot *RobotParameters) {
	firstPoint := GetFirstPoint(trajectory[1].Distance, robot)
	trajectory[1].Time = firstPoint.Time
	trajectory[1].Velocity = firstPoint.Velocity
	trajectory[1].Acceleration = firstPoint.Acceleration

	for i := 2; i < len(trajectory); i++ {
		currentPoint := trajectory[i]
		prevPoint := trajectory[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, prevPoint.Velocity+prevPoint.Acceleration*dt)
		currentPoint.Time = prevPoint.Time + dt
	}
}

func calculateKinematicsReverseNoHeading(trajectory []*TrajectoryPoint, robot *RobotParameters) {
	lastPoint := trajectory[len(trajectory)-1]
	secondToLastPoint := trajectory[len(trajectory)-2]
	distanceBetweenLastTwoPoints := lastPoint.Distance - secondToLastPoint.Distance

	firstPoint := GetFirstPoint(distanceBetweenLastTwoPoints, robot)

	trajectory[len(trajectory)-2].Time = firstPoint.Time
	trajectory[len(trajectory)-2].Velocity = firstPoint.Velocity
	trajectory[len(trajectory)-2].Acceleration = firstPoint.Acceleration

	trajectory[len(trajectory)-1].Velocity = 0
	trajectory[len(trajectory)-1].Acceleration = 0

	for i := len(trajectory) - 3; i >= 0; i-- {
		currentPoint := trajectory[i]
		prevPoint := trajectory[i+1]

		distanceFromPrevPoint := prevPoint.Distance - currentPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (prevPoint.Heading - currentPoint.Heading) / dt

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			robot.MaxAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, prevPoint.Velocity+prevPoint.Acceleration*dt)
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

		maxVelAccordingToOmega := robot.MaxVelocity - math.Abs(robot.Radius*currentPoint.Omega)

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

func CalculateDtAndOmegaAfterReverse(trajectoryPoints []*TrajectoryPoint) {
	trajectoryPoints[0].Time = 0

	// The time of the "first point"
	timeBetweenLastTwoPoints := trajectoryPoints[len(trajectoryPoints)-2].Time

	for i := 2; i < len(trajectoryPoints)-1; i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
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
	}
}

func ReverseTime(trajectory []*TrajectoryPoint) {
	for i, j := 0, len(trajectory)-1; i < j; i, j = i+1, j-1 {
		trajectory[i].Time, trajectory[j].Time = trajectory[j].Time, trajectory[i].Time
	}
}
