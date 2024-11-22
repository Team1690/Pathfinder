package trajcalc

import (
	"math"

	"github.com/Team1690/Pathfinder/utils"
)

func getFirstPoint(distance float64, robot *RobotParameters) *TrajectoryPoint {
	// * x(t) = (1/6)*j*t^3 -> t(x) = (6*x/j)^(1/3)
	firstPointTime := math.Pow(6*distance/robot.MaxJerk, 1.0/3.0)

	return &TrajectoryPoint{
		Time:         firstPointTime,
		Velocity:     0.5 * robot.MaxJerk * math.Pow(firstPointTime, 2),
		Acceleration: robot.MaxJerk * firstPointTime,
	}
}

func dtFromDistanceAndVel(currentPoint *TrajectoryPoint, prevPoint *TrajectoryPoint) float64 {
	// * v = ∆x/∆t -> ∆t = ∆x/v
	return math.Abs(currentPoint.Distance-prevPoint.Distance) / prevPoint.Velocity
}

func calcOmega(currentPoint *TrajectoryPoint, prevPoint *TrajectoryPoint, dt float64) float64 {
	// * ω = ∆θ/∆t
	return (currentPoint.Heading - prevPoint.Heading) / dt
}

func maxVelAccordingToOmega(robot *RobotParameters, omega float64) float64 {
	// * v + ω*r <= robot.MaxVelocity
	// * v is always positive (because it's a length of a vector)
	return math.Max(robot.MaxVelocity-math.Abs(robot.Radius*omega), 0)
}

func CalculateKinematics(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters, reversed bool) {
	// the real first point of a trajectory is a stop point
	trajectoryPoints[0].Velocity = 0
	trajectoryPoints[0].Acceleration = 0

	// first point kinematics according to jerk
	firstPoint := getFirstPoint(trajectoryPoints[1].Distance, robot)
	trajectoryPoints[1].Time = firstPoint.Time
	trajectoryPoints[1].Velocity = firstPoint.Velocity
	trajectoryPoints[1].Acceleration = firstPoint.Acceleration

	// all the other points are calculated from the previous point
	for i := 2; i < len(trajectoryPoints); i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]

		// get dt
		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		currentPoint.Omega = calcOmega(currentPoint, prevPoint, dt)

		maxVelAccordingToOmega := maxVelAccordingToOmega(robot, currentPoint.Omega)

		// in forward pass kinematics we want to limit the acceleration
		maxAccForward := robot.MaxAcceleration * (1 - prevPoint.Velocity/maxVelAccordingToOmega)

		// limit the accel (or decel) by skid and max forward accel
		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
			maxAccForward,
		)

		// limit velocity by accel and omega
		currentPoint.Velocity = utils.Min(
			currentPoint.Velocity,
			maxVelAccordingToOmega,
			prevPoint.Velocity+prevPoint.Acceleration*dt,
		)

		// increment time
		currentPoint.Time = prevPoint.Time + dt
	}
} // * CalculateKinematics

func CalculateReversedKinematics(trajPoints []*TrajectoryPoint, robot *RobotParameters) {
	// reverse distances and time
	totalDistance := trajPoints[len(trajPoints)-1].Distance
	totalTime := trajPoints[len(trajPoints)-1].Time

	// the real first point of a trajectory is a stop point
	trajPoints[len(trajPoints)-1].Velocity = 0
	trajPoints[len(trajPoints)-1].Acceleration = 0
	// reverse first point
	trajPoints[len(trajPoints)-1].Distance = totalDistance - trajPoints[len(trajPoints)-1].Distance
	trajPoints[len(trajPoints)-1].Time = totalTime - trajPoints[len(trajPoints)-1].Time

	//reverse second point
	trajPoints[len(trajPoints)-2].Distance = totalDistance - trajPoints[len(trajPoints)-2].Distance
	trajPoints[len(trajPoints)-2].Time = totalTime - trajPoints[len(trajPoints)-2].Time
	// first point kinematics according to jerk
	firstPoint := getFirstPoint(trajPoints[len(trajPoints)-2].Distance, robot)
	trajPoints[len(trajPoints)-2].Time = firstPoint.Time
	trajPoints[len(trajPoints)-2].Velocity = firstPoint.Velocity
	trajPoints[len(trajPoints)-2].Acceleration = firstPoint.Acceleration

	// all the other points are calculated from the previous point
	for i := len(trajPoints) - 3; i >= 0; i-- {
		currentPoint := trajPoints[i]
		prevPoint := trajPoints[i+1]

		// reversing distance and time foreach point in the calculation
		currentPoint.Distance = totalDistance - currentPoint.Distance
		currentPoint.Time = totalTime - currentPoint.Time

		// get dt
		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		// get omega (reversed)
		currentPoint.Omega = -1 * calcOmega(currentPoint, prevPoint, dt)

		// get omega vel limit
		maxVelAccordingToOmega := maxVelAccordingToOmega(robot, currentPoint.Omega)

		// in reversed kinematics we want the deceleration to be as high as possible
		maxAccForward := robot.MaxAcceleration

		// limit the accel (or decel) by skid and max forward accel
		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
			maxAccForward,
		)

		// limit velocity by accel and omega
		currentPoint.Velocity = utils.Min(
			currentPoint.Velocity,
			maxVelAccordingToOmega,
			prevPoint.Velocity+prevPoint.Acceleration*dt,
		)

		// increment time
		currentPoint.Time = prevPoint.Time + dt

	}

	// reverse trajectory back
	totalDistance = trajPoints[0].Distance
	totalTime = trajPoints[0].Time
	for _, oldPoint := range trajPoints {
		oldPoint.Distance = totalDistance - oldPoint.Distance
		oldPoint.Time = totalTime - oldPoint.Time
	}
} // * CalculateReversedKinematics

func CalculateDt(trajectoryPoints []*TrajectoryPoint) {
	for i := 2; i < len(trajectoryPoints)-1; i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]

		dt := dtFromDistanceAndVel(currentPoint, prevPoint)

		currentPoint.Time = prevPoint.Time + dt
	}
}

// Does kinematics :)
func DoKinematics(trajectory []*TrajectoryPoint, robot *RobotParameters) []*TrajectoryPoint {
	CalculateKinematics(trajectory, robot, false)
	CalculateReversedKinematics(trajectory, robot)
	// before CalculateReversedKinematics:
	// 		CalculateKinematics(trajectory, robot, false)
	// 		trajectory = reverseTrajectory(trajectory)
	//		CalculateKinematics(trajectory, robot, true)
	// 		trajectory = reverseTrajectory(trajectory)
	return trajectory
}
