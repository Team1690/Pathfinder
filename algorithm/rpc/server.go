package rpc

import (
	"context"
)

type pathFinderServerImpl struct {
	UnimplementedPathFinderServer
}

var _ PathFinderServer = (*pathFinderServerImpl)(nil)

func NewServer() *pathFinderServerImpl {
	return &pathFinderServerImpl{}
}

func (s *pathFinderServerImpl) CalculateTrajectory(ctx context.Context, r *TrajectoryRequest) (*TrajectoryResponse, error) {
	return &TrajectoryResponse{}, nil
}