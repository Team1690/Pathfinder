package main

import (
	"context"
	"log"
	"math"
	"net/http"

	"github.com/Team1690/Pathfinder/rpc"
	trajcalc "github.com/Team1690/Pathfinder/services/traj_calc"
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

	path, err := spline.InitializePath(points)
	if err != nil {
		return nil, xerrors.Errorf("error in initPath: %w", err)
	}

	evaluatedPoints := path.EvaluateAtInterval(float64(r.PointInterval))

	segmentClassifier := trajcalc.NewSegmentClassifier(r.Segments)

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

func (s *pathFinderServerImpl) CalculateTrajectory(ctx context.Context, trajRequest *rpc.TrajectoryRequest) (*rpc.TrajectoryResponse, error) {
	return trajcalc.CalculateTrajectory(trajRequest)
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
