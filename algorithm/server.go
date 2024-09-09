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
	points := []*rpc.PathPoint{}

	for _, segment := range r.Segments {
		points = append(points, segment.Points...)
	}

	path, err := initPath(points)
	if err != nil {
		return nil, xerrors.Errorf("error in initPath: %w", err)
	}

	evaluatedPoints := path.EvaluateAtInterval(float64(r.PointInterval))

	segmentClassifier := pathfinder.NewSegmentClassifier(r.Segments)

	var responsePoints []*rpc.SplinePoint
	for index, evaluatedPoint := range evaluatedPoints {
		segmentClassifier.Update(&evaluatedPoint, index)
		responsePoints = append(responsePoints,
			&rpc.SplinePoint{
				Point:        evaluatedPoint.ToRpc(),
				SegmentIndex: int32(segmentClassifier.GetCurrentSegmentIndex()),
			},
		)
	}

	return &rpc.SplineResponse{
		SplinePoints: responsePoints,
	}, nil
}

type TrajectoryResult = struct {
	points []*rpc.SwervePoints_SwervePoint
	err    error
	index  int
}

func (s *pathFinderServerImpl) CalculateTrajectory(ctx context.Context, r *rpc.TrajectoryRequest) (*rpc.TrajectoryResponse, error) {

	resultChan := make(chan TrajectoryResult)

	for i, section := range r.Sections {
		go func(section *rpc.Section, index int) {
			points, err := calculateSectionTrajectory(section, r.GetSwerveParams())

			resultChan <- TrajectoryResult{points: points, err: err, index: index}
		}(section, i)
	}

	results := make([][]*rpc.SwervePoints_SwervePoint, len(r.Sections))

	for range r.Sections {
		result := <-resultChan

		if result.err != nil {
			return nil, result.err
		}

		results[result.index] = result.points
	}

	close(resultChan)
	var points []*rpc.SwervePoints_SwervePoint
	for _, trajectoryRes := range results {
		points = append(points, trajectoryRes...)
	}
	//ugly fix for having a oneof in proto
	res := &rpc.TrajectoryResponse{Points: &rpc.TrajectoryResponse_SwervePoints{
		SwervePoints: &rpc.SwervePoints{
			SwervePoints: points,
		},
	}}

	// * Write results to a csv file
	if err := export.ExportTrajectory(res, r.FileName); err != nil {
		return nil, xerrors.Errorf("error in ExportTrajectory: %w", err)
	}

	// // * Generate debug graphs
	// GenerateGraphs(res, r.SwerveRobotParams)

	return res, nil
}

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
		swerveTrajectory = append(swerveTrajectory, pathfinder.ToRpcSwervePoint(&point))
	}

	return swerveTrajectory, nil
}

func initPath(points []*rpc.PathPoint) (*spline.Path, error) {
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

func GenerateGraphs(response *rpc.TrajectoryResponse, robot *rpc.TrajectoryRequest_SwerveParams) {
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
	prevPosition := vector.NewFromRpcVector(response.GetSwervePoints().SwervePoints[0].Position)

	time := 0.0

	for _, point := range response.GetSwervePoints().SwervePoints {
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
		time += float64(robot.SwerveParams.CycleTime)
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
