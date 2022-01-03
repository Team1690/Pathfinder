package main

import (
	"context"
	"log"
	"math"
	"net/http"

	"github.com/Team1690/Pathfinder/export"
	"github.com/Team1690/Pathfinder/pathfinder"
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/plot"
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

func (s *pathFinderServerImpl) CalculateSplinePoints(ctx context.Context, r *rpc.SplineRequest) (*rpc.SplineResponse, error) {
	points := []*rpc.Point{}

	for _, segment := range r.Segments {
		points = append(points, segment.Points...)
	}

	path, err := initPath(points, rpc.SplineTypes_Bezier, r.SplineParameters)
	if err != nil {
		return nil, xerrors.Errorf("error in initPath: %w", err)
	}

	evaluatedPoints := path.EvaluateAtInterval(float64(r.EvaluatedPointsInterval))

	segmentClassifier := pathfinder.NewSegmentClassifier(r.Segments)

	var responsePoints []*rpc.SplineResponse_Point
	for index, evaluatedPoint := range evaluatedPoints {
		segmentClassifier.Update(&evaluatedPoint, index)
		responsePoints = append(responsePoints,
			&rpc.SplineResponse_Point{
				Point:        evaluatedPoint.ToRpc(),
				SegmentIndex: int32(segmentClassifier.GetCurrentSegmentIndex()),
			},
		)
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
	if err := export.ExportTrajectory(res, r.TrajectoryFileName); err != nil {
		return nil, xerrors.Errorf("error in ExportTrajectory: %w", err)
	}

	// // * Generate debug graphs
	// GenerateGraphs(res, r.SwerveRobotParams)

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

	trajectory, err := pathfinder.CreateTrajectoryPointArray(path, robot, section.Segments)
	if err != nil {
		return nil, xerrors.Errorf("error in creating trajectory point array: %w", err)
	}

	trajectory2D := pathfinder.Get2DTrajectory(trajectory, path)

	var swerveTrajectory []*rpc.TrajectoryResponse_SwervePoint
	for _, point := range trajectory2D {
		swerveTrajectory = append(swerveTrajectory, pathfinder.ToRpcSwervePoint(&point))
	}

	return swerveTrajectory, nil
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
		CycleTime:            float64(rpcRobot.CycleTime),
		MaxVelocity:          float64(rpcRobot.MaxVelocity),
		MaxAcceleration:      float64(rpcRobot.MaxAcceleration),
		SkidAcceleration:     float64(rpcRobot.SkidAcceleration),
		MaxJerk:              float64(rpcRobot.MaxJerk),
		Radius:               math.Hypot(float64(rpcRobot.Height)/2, float64(rpcRobot.Width)/2),
		AngularAccPercentage: float64(rpcRobot.AngularAccelerationPercentage),
	}
}

func GenerateGraphs(response *rpc.TrajectoryResponse, robot *rpc.TrajectoryRequest_SwerveRobotParams) {
	velTimeData := []vector.Vector{}
	velDirTimeData := []vector.Vector{}
	velXTimeData := []vector.Vector{}
	velYTimeData := []vector.Vector{}
	velDistanceData := []vector.Vector{}

	headingTimeData := []vector.Vector{}
	headingDistanceData := []vector.Vector{}

	omegaTimeData := []vector.Vector{}
	omegaDistanceData := []vector.Vector{}

	positionData := []vector.Vector{}

	curvatureDistanceData := []vector.Vector{}

	distance := 0.0
	prevPosition := vector.NewFromRpcVector(response.SwervePoints[0].Position)

	time := 0.0

	for _, point := range response.SwervePoints {
		currentPosition := vector.NewFromRpcVector(point.Position)
		prevToCurrentPosition := currentPosition.Sub(prevPosition)
		distance += prevToCurrentPosition.Norm()

		// * Position
		positionData = append(positionData, currentPosition)

		// * Velocity
		currentVelocity := vector.NewFromRpcVector(point.Velocity)

		velDirTimeData = append(velDirTimeData, vector.Vector{X: time, Y: currentVelocity.Angle()})

		velNorm := currentVelocity.Norm()

		velTimeData = append(velTimeData, vector.Vector{X: time, Y: velNorm})
		velXTimeData = append(velXTimeData, vector.Vector{X: time, Y: currentVelocity.X})
		velYTimeData = append(velYTimeData, vector.Vector{X: time, Y: currentVelocity.Y})
		velDistanceData = append(velDistanceData, vector.Vector{X: distance, Y: velNorm})

		// * Heading
		headingTimeData = append(headingTimeData, vector.Vector{X: time, Y: float64(point.Heading)})
		headingDistanceData = append(headingDistanceData, vector.Vector{X: distance, Y: float64(point.Heading)})

		// * Omega
		omegaTimeData = append(omegaTimeData, vector.Vector{X: time, Y: float64(point.AngularVelocity)})
		omegaDistanceData = append(omegaDistanceData, vector.Vector{X: distance, Y: float64(point.AngularVelocity)})

		// * curvature
		dAngle := math.Abs(prevToCurrentPosition.Angle())
		curvature := math.Min(dAngle/prevToCurrentPosition.Norm(), 1e6)
		curvatureDistanceData = append(curvatureDistanceData, vector.Vector{X: distance, Y: curvature})

		prevPosition = currentPosition
		time += float64(robot.CycleTime)
	}

	plot.PlotScatter(positionData, "Position")

	plot.PlotScatter(velTimeData, "Velocity-Time")
	plot.PlotScatter(velDistanceData, "Velocity-Distance")
	plot.PlotScatter(velDirTimeData, "VelocityDirection-Time")
	plot.PlotScatter(velXTimeData, "VelocityX-Time")
	plot.PlotScatter(velYTimeData, "VelocityY-Time")

	plot.PlotScatter(headingTimeData, "Heading-Time")
	plot.PlotScatter(headingDistanceData, "Heading-Distance")

	plot.PlotScatter(omegaTimeData, "Omega-Time")
	plot.PlotScatter(omegaDistanceData, "Omega-Distance")

	plot.PlotScatter(curvatureDistanceData, "Curvature-Distance")

	http.ListenAndServe(":8081", nil)
}
