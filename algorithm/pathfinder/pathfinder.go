package pathfinder

import (
	"math"

	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

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

func CreateTrajectoryPointArray(spline spline.Spline, robot RobotParameters) []TrajectoryPoint {
	const deltaDistanceForEvaluation float64 = 0.0001

	ds := deltaDistanceForEvaluation / spline.Length()

	trajectoryPointsCount := int(1 / ds)

	trajectoryPoints := make([]TrajectoryPoint, trajectoryPointsCount)

	trajectoryPoints[0] = TrajectoryPoint{Distance: 0, S: 0, Position: spline.Evaluate(0), Velocity: 0}

	for i := 1; i < trajectoryPointsCount; i++ {
		s := float64(i) * ds

		trajectoryPoints[i].S = s
		trajectoryPoints[i].Position = spline.Evaluate(s)
		prevPointToCurrent := trajectoryPoints[i].Position.Sub(trajectoryPoints[i-1].Position)

		distanceToPrevPoint := prevPointToCurrent.Norm()

		trajectoryPoints[i].Distance = trajectoryPoints[i-1].Distance + distanceToPrevPoint
	}

	return trajectoryPoints
}

func LimitVelocityWithCentrifugalForce(trajectoryPoints *[]TrajectoryPoint, segmentMaxVelocity float64, robot RobotParameters) {
	trajectoryPointsCount := len(*trajectoryPoints)
	for i := 1; i < trajectoryPointsCount-1; i++ {
		prevPointToCurrent := (*trajectoryPoints)[i].Position.Sub((*trajectoryPoints)[i-1].Position)

		distanceToPrevPoint := prevPointToCurrent.Norm()

		currentPointToNextPoint := (*trajectoryPoints)[i+1].Position.Sub((*trajectoryPoints)[i].Position)
		dAngle := math.Abs(utils.WrapAngle(currentPointToNextPoint.Angle() - prevPointToCurrent.Angle()))

		driveRadius := 0.0

		if dAngle == 0 {
			driveRadius = math.Inf(1)
		} else {
			driveRadius = distanceToPrevPoint / dAngle
		}

		maxVelAccordingToCentrifugalForce := math.Sqrt(driveRadius * robot.SkidAcceleration)

		// This is the max velocity allowed at this point
		(*trajectoryPoints)[i].Velocity = math.Min(segmentMaxVelocity, maxVelAccordingToCentrifugalForce)
	}
}

func SetHeading(trajectoryPoints *[]TrajectoryPoint, headingStart float64, headingEnd float64) {
	const distancePercentageForAngularAcceleration float64 = 0.25
	const oneMinusDistancePercentageForAcceleration float64 = 1 - distancePercentageForAngularAcceleration
	const twiceAccelerationPercentageTimesOneMinus = 2 * distancePercentageForAngularAcceleration * oneMinusDistancePercentageForAcceleration

	trajectoryPointsCount := len(*trajectoryPoints)
	travelDistance := (*trajectoryPoints)[trajectoryPointsCount-1].Distance - (*trajectoryPoints)[0].Distance

	distanceToAccelerate := distancePercentageForAngularAcceleration * travelDistance

	dHeading := headingEnd - headingStart

	travelDistanceSquared := math.Pow(travelDistance, 2)

	angularAcceleration := dHeading / (twiceAccelerationPercentageTimesOneMinus * travelDistanceSquared)
	constantOmega := dHeading / (oneMinusDistancePercentageForAcceleration * travelDistance)

	headingAtEndOfAcceleration := angularAcceleration * math.Pow(distanceToAccelerate, 2)

	for i := 0; i < trajectoryPointsCount; i++ {
		if (*trajectoryPoints)[i].Distance < distanceToAccelerate {
			// Acceleration parabola
			(*trajectoryPoints)[i].Heading = headingStart + angularAcceleration*math.Pow((*trajectoryPoints)[i].Distance, 2)

		} else if (*trajectoryPoints)[i].Distance < travelDistance-distanceToAccelerate {
			// Constant omega linear interpolation
			(*trajectoryPoints)[i].Heading = headingStart + headingAtEndOfAcceleration + constantOmega*((*trajectoryPoints)[i].Distance-distanceToAccelerate)

		} else {
			// Deceleration parabola
			(*trajectoryPoints)[i].Heading = headingEnd - angularAcceleration*math.Pow(travelDistance-(*trajectoryPoints)[i].Distance, 2)
		}
	}
}

func GetFirstPoint(distance float64, robot RobotParameters) TrajectoryPoint {
	const dt float64 = 0.0001

	currentPoint := TrajectoryPoint{Time: 0, Acceleration: 0, Velocity: 0, Distance: 0}
	var prevPoint TrajectoryPoint

	for time := 0.0; currentPoint.Distance < distance; time += dt {
		prevPoint = currentPoint
		currentPoint = TrajectoryPoint{
			Time:         time,
			Acceleration: prevPoint.Acceleration + robot.MaxJerk*dt,
			Velocity:     prevPoint.Velocity + prevPoint.Acceleration*dt,
			Distance:     prevPoint.Distance + prevPoint.Velocity*dt + 0.5*prevPoint.Acceleration*math.Pow(dt, 2),
		}
	}

	return prevPoint
}

func CalculateKinematics(trajectoryPoints *[]TrajectoryPoint, robot RobotParameters) {
	actualFirstPoint := (*trajectoryPoints)[0]
	(*trajectoryPoints)[0] = GetFirstPoint((*trajectoryPoints)[1].Distance, robot)
	(*trajectoryPoints)[0].Heading = actualFirstPoint.Heading

	for i := 1; i < len(*trajectoryPoints); i++ {
		currentPoint := &(*trajectoryPoints)[i]
		prevPoint := (*trajectoryPoints)[i-1]
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

	(*trajectoryPoints)[0] = actualFirstPoint
}

func CalculateKinematicsReverse(trajectoryPoints *[]TrajectoryPoint, robot RobotParameters) {
	actualLastPoint := (*trajectoryPoints)[len(*trajectoryPoints)-1]
	(*trajectoryPoints)[len(*trajectoryPoints)-1] = GetFirstPoint(
		actualLastPoint.Distance-(*trajectoryPoints)[len(*trajectoryPoints)-2].Distance,
		robot,
	)
	(*trajectoryPoints)[len(*trajectoryPoints)-1].Distance = actualLastPoint.Distance - (*trajectoryPoints)[len(*trajectoryPoints)-1].Distance
	(*trajectoryPoints)[len(*trajectoryPoints)-1].Heading = actualLastPoint.Heading

	for i := len(*trajectoryPoints) - 2; i >= 0; i-- {
		currentPoint := &(*trajectoryPoints)[i]
		prevPoint := (*trajectoryPoints)[i+1]

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

	(*trajectoryPoints)[len(*trajectoryPoints)-1] = actualLastPoint
}

func CalculateDtAndOmegaAfterReverse(trajectoryPoints *[]TrajectoryPoint) {
	(*trajectoryPoints)[0].Time = 0
	for i := 2; i < len(*trajectoryPoints); i++ {
		currentPoint := &(*trajectoryPoints)[i]
		prevPoint := (*trajectoryPoints)[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
		currentPoint.Time = prevPoint.Time + dt
	}
}

func SearchForTime(trajectoryPoints []TrajectoryPoint, time float64, lastSearchIndex int) int {
	for index, point := range trajectoryPoints[lastSearchIndex:] {
		if point.Time >= time {
			return index + lastSearchIndex
		}
	}
	return -1
}

func QuantizeTrajectory(trajectoryPoints []TrajectoryPoint, cycleTime float64) []TrajectoryPoint {
	quantizedTrajectory := []TrajectoryPoint{trajectoryPoints[0]}

	lastPointTime := trajectoryPoints[len(trajectoryPoints)-1].Time

	searchIndex := 0

	for t := cycleTime; t < lastPointTime; t += cycleTime {
		searchIndex = SearchForTime(trajectoryPoints, t, searchIndex)
		nextPoint := trajectoryPoints[searchIndex]
		prevPoint := trajectoryPoints[searchIndex-1]
		nextToPreviousPointRatio := utils.ReverseLerp(prevPoint.Time, nextPoint.Time, t)

		quantizedPoint := TrajectoryPoint{
			Time:     t,
			Position: vector.Lerp(prevPoint.Position, nextPoint.Position, nextToPreviousPointRatio),
			Velocity: utils.Lerp(prevPoint.Velocity, nextPoint.Velocity, nextToPreviousPointRatio),
			Heading:  utils.Lerp(prevPoint.Heading, nextPoint.Heading, nextToPreviousPointRatio),
			Omega:    utils.Lerp(prevPoint.Omega, nextPoint.Omega, nextToPreviousPointRatio),
		}
		quantizedTrajectory = append(quantizedTrajectory, quantizedPoint)
	}

	return quantizedTrajectory
}
