package pathfinder

import (
	"math"

	"github.com/Team1690/Pathfinder/utils"
)

func GetFirstPoint(distance float64, robot *RobotParameters) *TrajectoryPoint {
	// * x(t) = (1/6)*j*t^3 -> t(x) = (6*x/j)^(1/3)
	firstPointTime := math.Pow(6*distance/robot.MaxJerk, 1.0/3.0)

	return &TrajectoryPoint{
		Time:         firstPointTime,
		Velocity:     0.5 * robot.MaxJerk * math.Pow(firstPointTime, 2),
		Acceleration: robot.MaxJerk * firstPointTime,
	}
}

func dtFromDistanceAndVel(currentPoint *TrajectoryPoint, prevPoint *TrajectoryPoint) float64 {
	distanceFromPrevPoint := math.Abs(currentPoint.Distance - prevPoint.Distance)
	// * v = ∆x/∆t -> ∆t = ∆x/v
	dt := distanceFromPrevPoint / prevPoint.Velocity
	return dt
}

func calcOmega(currentPoint *TrajectoryPoint, prevPoint *TrajectoryPoint, dt float64) float64 {
	// * v = ∆x/∆t
	return (currentPoint.Heading - prevPoint.Heading) / dt
}

func maxVelAccordingToOmega(robot *RobotParameters, omega float64) float64 {
	// * v + ω*r <= robot.MaxVelocity
	// * v is always positive (because it's a length of a vector)
	return math.Max(robot.MaxVelocity-math.Abs(robot.Radius*omega), 0)
}

func CalculateKinematics(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters) {
	firstPoint := GetFirstPoint(trajectoryPoints[1].Distance, robot)
	trajectoryPoints[1].Time = firstPoint.Time
	trajectoryPoints[1].Velocity = firstPoint.Velocity
	trajectoryPoints[1].Acceleration = firstPoint.Acceleration

	for i := 2; i < len(trajectoryPoints); i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		currentPoint.Omega = calcOmega(currentPoint, prevPoint, dt)

		maxVelAccordingToOmega := maxVelAccordingToOmega(robot, currentPoint.Omega)

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

		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		currentPoint.Omega = calcOmega(prevPoint, currentPoint, dt)

		maxVelAccordingToOmega := maxVelAccordingToOmega(robot, currentPoint.Omega)

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

		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		if calculateOmega {
			currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
		}

		currentPoint.Time = prevPoint.Time + dt
	}
	trajectoryPoints[len(trajectoryPoints)-1].Time = trajectoryPoints[len(trajectoryPoints)-2].Time + timeBetweenLastTwoPoints
}
