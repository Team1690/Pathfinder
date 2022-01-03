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

func CalculateKinematics(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters, reversed bool) {
	trajectoryPoints[0].Velocity = 0
	trajectoryPoints[0].Acceleration = 0

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

		var maxAccForward float64

		if !reversed {
			maxAccForward = robot.MaxAcceleration * (1 - prevPoint.Velocity/maxVelAccordingToOmega)
		} else {
			maxAccForward = robot.MaxAcceleration
		}

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
			maxAccForward,
		)

		currentPoint.Velocity = utils.Min(
			currentPoint.Velocity,
			maxVelAccordingToOmega,
			prevPoint.Velocity+prevPoint.Acceleration*dt,
		)

		currentPoint.Time = prevPoint.Time + dt
	}
}

func CalculateDtAndOmega(trajectoryPoints []*TrajectoryPoint, calculateOmega bool) {
	for i := 2; i < len(trajectoryPoints)-1; i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]

		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		if calculateOmega {
			currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
		}

		currentPoint.Time = prevPoint.Time + dt
	}
}

func ReverseTrajectory(trajectory []*TrajectoryPoint) []*TrajectoryPoint {
	totalDistance := math.Max(trajectory[0].Distance, trajectory[len(trajectory)-1].Distance)
	totalTime := math.Max(trajectory[0].Time, trajectory[len(trajectory)-1].Time)
	totalHeading := math.Max(trajectory[0].Heading, trajectory[len(trajectory)-1].Heading)

	var reversedTrajectory []*TrajectoryPoint

	for i := len(trajectory) - 1; i >= 0; i-- {
		oldPoint := trajectory[i]
		var newPoint *TrajectoryPoint = oldPoint

		newPoint.Distance = totalDistance - oldPoint.Distance
		newPoint.Heading = totalHeading - oldPoint.Heading
		newPoint.Time = totalTime - oldPoint.Time

		reversedTrajectory = append(reversedTrajectory, newPoint)
	}
	return reversedTrajectory
}

func DoKinematics(trajectory []*TrajectoryPoint, robot *RobotParameters) []*TrajectoryPoint {
	CalculateKinematics(trajectory, robot, false)
	trajectory = ReverseTrajectory(trajectory)
	CalculateKinematics(trajectory, robot, true)
	trajectory = ReverseTrajectory(trajectory)
	return trajectory
}
