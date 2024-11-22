package splinecalc

import (
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/services/spline_calc/spline"
	trajcalc "github.com/Team1690/Pathfinder/services/traj_calc"
	"golang.org/x/xerrors"
)

func CalculateSpline(r *rpc.SplineRequest) (*rpc.SplineResponse, error) {
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
