package main

import (
	"context"
	"log"
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
	logger *log.Logger
}

var _ rpc.PathFinderServer = (*pathFinderServerImpl)(nil)

func NewServer(logger *log.Logger) *pathFinderServerImpl {
	return &pathFinderServerImpl{
		logger: logger,
	}
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

	path, err := initPath(points, rpc.SplineTypes_Bezier, nil)
	if err != nil {
		return nil, xerrors.Errorf("error in init path: %w", err)
	}

	robot := toRobotParams(rpcRobot)

	segClass := pathfinder.NewSegmentClassifier(path, section.Segments)

	trajectory, err := pathfinder.CreateTrajectoryPointArray(path, robot, segClass)
	if err != nil {
		return nil, xerrors.Errorf("error in creating trajectory point array: %w", err)
	}

	pathfinder.LimitVelocityWithCentrifugalForce(trajectory, robot, true)
	pathfinder.SetHeading(trajectory, 0, math.Pi/2)
	pathfinder.CalculateKinematics(trajectory, robot)
	pathfinder.CalculateKinematicsReverse(trajectory, robot)
	pathfinder.CalculateDtAndOmegaAfterReverse(trajectory)
	trajectory2D := pathfinder.Get2DTrajectory(trajectory, path)

	var swerveTrajectory []*rpc.TrajectoryResponse_SwervePoint
	for _, point := range trajectory2D {
		swerveTrajectory = append(swerveTrajectory, pathfinder.ToRpcSwervePoint(&point))
	}

	return swerveTrajectory, nil
}

func (s *pathFinderServerImpl) CalculateSplinePoints(ctx context.Context, r *rpc.SplineRequest) (*rpc.SplineResponse, error) {
	s.logger.Print("Request: CalculateSplinePoints")

	path, err := initPath(r.Points, rpc.SplineTypes_Bezier, r.SplineParameters)
	if err != nil {
		return nil, xerrors.Errorf("error in init path: %w", err)
	}

	evaluatedPoints := []*rpc.SplineResponse_Point{}

	// TODO s is not linear in splines and behaves differently in each spline
	ds := float64(r.EvaluatedPointsInterval) / path.Length()

	for s := 0.0; s <= 1; s += ds {
		evaluatedPoints = append(evaluatedPoints, &rpc.SplineResponse_Point{Point: path.Evaluate(s).ToRpc()})
	}

	s.logger.Print("Response: CalculateSplinePoints")

	return &rpc.SplineResponse{
		SplineType:      rpc.SplineTypes_Bezier,
		EvaluatedPoints: evaluatedPoints,
	}, nil
}

func initPath(points []*rpc.Point, splineType rpc.SplineTypes, parameters *rpc.SplineParameters) (*spline.Path, error) {
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

	if len(path.Splines) == 0 {
		return nil, xerrors.New("not enough splines")
	}

	return path, nil
}

func toRobotParams(rpcRobot *rpc.TrajectoryRequest_SwerveRobotParams) *pathfinder.RobotParameters {
	return &pathfinder.RobotParameters{
		CycleTime:        0.02, // TODO add cycle time to rpc
		MaxVelocity:      float64(rpcRobot.MaxVelocity),
		MaxAcceleration:  float64(rpcRobot.MaxAcceleration),
		SkidAcceleration: float64(rpcRobot.MaxAcceleration), // TODO add skid acceleration to rpc
		MaxJerk:          float64(rpcRobot.MaxJerk),
		Radius:           math.Hypot(float64(rpcRobot.Height), float64(rpcRobot.Width)), // TODO add radius to rpc
	}
}
