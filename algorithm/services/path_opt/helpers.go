package pathopt

import (
	"math"

	"github.com/Team1690/Pathfinder/pathfinder"
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/vector"
	"golang.org/x/xerrors"
)

func calculateSectionTrajectory(section *rpc.Section, rpcRobot *rpc.SwerveRobotParams) ([]*rpc.SwervePoints_SwervePoint, error) {
	points := []*rpc.PathPoint{}

	for _, segment := range section.Segments {
		points = append(points, segment.Points...)
	}

	if len(points) < 2 {
		return nil, xerrors.New("requested a path of one point")
	}

	path, err := initPath(points)
	if err != nil {
		return nil, xerrors.Errorf("error in init path: %w", err)
	}

	robot := toRobotParams(rpcRobot)

	trajectory, err := pathfinder.CreateTrajectoryPointArray(path, robot, section.Segments)
	if err != nil {
		return nil, xerrors.Errorf("error in creating trajectory point array: %w", err)
	}

	trajectory2D := pathfinder.Get2DTrajectory(trajectory, path)

	var swerveTrajectory []*rpc.SwervePoints_SwervePoint
	for _, point := range trajectory2D {
		swerveTrajectory = append(swerveTrajectory, pathfinder.ToRpcSwervePoint(point))
	}

	return swerveTrajectory, nil
}

func initPath(points []*rpc.PathPoint) (*spline.Path, error) {
	path := spline.NewPath()
	for i := 0; i < len(points)-1; i++ {
		bezier := spline.NewBezier([]vector.Vector{
			vector.NewFromRpcVector(points[i].Position),
			vector.NewFromRpcVector(points[i].ControlOut),
			vector.NewFromRpcVector(points[i+1].ControlIn),
			vector.NewFromRpcVector(points[i+1].Position),
		})
		path.AddSpline(bezier)
	}

	if len(path.Splines) == 0 {
		return nil, xerrors.New("not enough splines")
	}

	return path, nil
}

func toRobotParams(rpcRobot *rpc.SwerveRobotParams) *pathfinder.RobotParameters {
	return &pathfinder.RobotParameters{
		CycleTime:            float64(rpcRobot.CycleTime),
		MaxVelocity:          float64(rpcRobot.MaxVelocity),
		MaxAcceleration:      float64(rpcRobot.MaxAcceleration),
		SkidAcceleration:     float64(rpcRobot.SkidAcceleration),
		MaxJerk:              float64(rpcRobot.MaxJerk),
		Radius:               math.Hypot(float64(rpcRobot.Height)/2, float64(rpcRobot.Width)/2),
		AngularAccPercentage: float64(rpcRobot.AngularAccelerationPercentage),
	}
}
