package main

import (
	"context"
	"math"

	"github.com/Team1690/Pathfinder/export"
	"github.com/Team1690/Pathfinder/pathfinder"
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/vector"
	"golang.org/x/xerrors"
)

type pathFinderServerImpl struct {
	rpc.UnimplementedPathFinderServer
}

var _ rpc.PathFinderServer = (*pathFinderServerImpl)(nil)

func NewServer() *pathFinderServerImpl {
	return &pathFinderServerImpl{}
}

func (s *pathFinderServerImpl) CalculateSplinePoints(ctx context.Context, r *rpc.SplineRequest) (*rpc.SplineResponse, error) {
	path := initPath(r.Points, rpc.SplineTypes_Bezier, r.SplineParameters)

	evaluatedPoints := path.EvaluateAtInterval(float64(r.EvaluatedPointsInterval))

	var responsePoints []*rpc.SplineResponse_Point

	for _, point := range evaluatedPoints {
		responsePoints = append(responsePoints, &rpc.SplineResponse_Point{Point: point.ToRpc()})
	}

	return &rpc.SplineResponse{
		SplineType:      rpc.SplineTypes_Bezier,
		EvaluatedPoints: responsePoints,
	}, nil
}

func (s *pathFinderServerImpl) CalculateTrajectory(ctx context.Context, r *rpc.TrajectoryRequest) (*rpc.TrajectoryResponse, error) {
	res := &rpc.TrajectoryResponse{}
	for _, section := range r.Sections {
		points, err := calculateSectionTrajectory(section, r.SwerveRobotParams)
		if err != nil {
			return nil, xerrors.Errorf("error in calculateSectionTrajectory: %w", err)
		}

		res.SwervePoints = append(res.SwervePoints, points...)
	}

	// * Write results to a csv file
	export.ExportTrajectory(res)

	return res, nil
}

func calculateSectionTrajectory(section *rpc.Section, rpcRobot *rpc.TrajectoryRequest_SwerveRobotParams) ([]*rpc.TrajectoryResponse_SwervePoint, error) {
	points := []*rpc.Point{}

	for _, segment := range section.Segments {
		points = append(points, segment.Points...)
	}

	if len(points) < 2 {
		return nil, xerrors.New("requested a path of one point")
	}

	path := initPath(points, rpc.SplineTypes_Bezier, nil)

	robot := toRobotParams(rpcRobot)

	trajectory, err := pathfinder.CreateTrajectoryPointArray(path, robot, section.Segments)
	if err != nil {
		return nil, xerrors.Errorf("error in creating trajectory point array: %w", err)
	}

	pathfinder.LimitVelocityWithCentrifugalForce(trajectory, robot)
	pathfinder.CalculateKinematics(trajectory, robot)
	pathfinder.CalculateKinematicsReverse(trajectory, robot)
	pathfinder.CalculateDtAndOmegaAfterReverse(trajectory)

	quantizedTrajectory := pathfinder.QuantizeTrajectory(trajectory, robot.CycleTime)

	pathfinder.ReverseTime(quantizedTrajectory)

	trajectory2D := pathfinder.Get2DTrajectory(quantizedTrajectory, path)

	var swerveTrajectory []*rpc.TrajectoryResponse_SwervePoint
	for _, point := range trajectory2D {
		swerveTrajectory = append(swerveTrajectory, pathfinder.ToRpcSwervePoint(&point))
	}

	return swerveTrajectory, nil
}

func initPath(points []*rpc.Point, splineType rpc.SplineTypes, parameters *rpc.SplineParameters) *spline.Path {
	// TODO handle more spline types
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
	return path
}

func toRobotParams(rpcRobot *rpc.TrajectoryRequest_SwerveRobotParams) *pathfinder.RobotParameters {
	return &pathfinder.RobotParameters{
		CycleTime:        float64(rpcRobot.CycleTime),
		MaxVelocity:      float64(rpcRobot.MaxVelocity),
		MaxAcceleration:  float64(rpcRobot.MaxAcceleration),
		SkidAcceleration: float64(rpcRobot.SkidAcceleration),
		MaxJerk:          float64(rpcRobot.MaxJerk),
		Radius:           math.Hypot(float64(rpcRobot.Height), float64(rpcRobot.Width)),
	}
}
