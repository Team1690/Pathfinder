package rpc

import (
	"context"
	"fmt"
)

type pathFinderServerImpl struct {
	UnimplementedPathFinderServer
}

var _ PathFinderServer = (*pathFinderServerImpl)(nil)

func NewServer() *pathFinderServerImpl {
	return &pathFinderServerImpl{}
}

func (s *pathFinderServerImpl) Greet(ctx context.Context, p *Person) (*GreetResponse, error) {
	name := p.Name

	return &GreetResponse{
		Message: fmt.Sprintf("Hello %s", name),
	}, nil
}
