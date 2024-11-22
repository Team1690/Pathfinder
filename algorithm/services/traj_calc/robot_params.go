package trajcalc

import (
	"math"

	"github.com/Team1690/Pathfinder/rpc"
)

// DriveTrain Enum type
type DriveTrain int

// DriveTrain Enum
const (
	Swerve DriveTrain = iota
	Tank
)

// struct representing a robot
type RobotParameters struct {
	Radius               float64
	MaxVelocity          float64
	MaxAcceleration      float64
	SkidAcceleration     float64
	MaxJerk              float64
	CycleTime            float64
	AngularAccPercentage float64
	DriveTrain           DriveTrain
}

// default robot params (~chester)
func DefaultRobotParameters() *RobotParameters {
	return &RobotParameters{
		CycleTime:            0.02,
		MaxVelocity:          3.6,
		MaxAcceleration:      7.5,
		SkidAcceleration:     7.5,
		MaxJerk:              50,
		Radius:               0.387,
		AngularAccPercentage: 0.1,
	}
}

// get robot according to drivetrain requested
func GetRobotParams(trajRequest *rpc.TrajectoryRequest) *RobotParameters {
	switch trajRequest.RobotParams.(type) {
	case *rpc.TrajectoryRequest_SwerveParams:
		rpcRobot := trajRequest.GetSwerveParams()
		return &RobotParameters{
			CycleTime:            float64(rpcRobot.CycleTime),
			MaxVelocity:          float64(rpcRobot.MaxVelocity),
			MaxAcceleration:      float64(rpcRobot.MaxAcceleration),
			SkidAcceleration:     float64(rpcRobot.SkidAcceleration),
			MaxJerk:              float64(rpcRobot.MaxJerk),
			Radius:               math.Hypot(float64(rpcRobot.Height)/2, float64(rpcRobot.Width)/2),
			AngularAccPercentage: float64(rpcRobot.AngularAccelerationPercentage),
			DriveTrain:           Swerve,
		}

	case *rpc.TrajectoryRequest_TankParams:
		rpcRobot := trajRequest.GetTankParams()
		return &RobotParameters{
			CycleTime:       float64(rpcRobot.CycleTime),
			MaxVelocity:     float64(rpcRobot.MaxVelocity),
			MaxAcceleration: float64(rpcRobot.MaxAcceleration),
			MaxJerk:         float64(rpcRobot.MaxJerk),
			Radius:          math.Hypot(float64(rpcRobot.Height)/2, float64(rpcRobot.Width)/2),
			DriveTrain:      Tank,
		}

	default:
		return DefaultRobotParameters()
	}
}
