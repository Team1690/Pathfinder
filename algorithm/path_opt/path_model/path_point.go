package pathmodel

import (
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type PathPoint struct {
	position   vector.Vector
	controlIn  vector.Vector
	controlOut vector.Vector
	useHeading bool
	heading    float64
	isStop     bool
	cutSegment bool
}

func (pp *PathPoint) ToRpcPathPoint() *rpc.PathPoint {
	return &rpc.PathPoint{
		Position:   pp.position.ToRpc(),
		ControlIn:  pp.controlIn.ToRpc(),
		ControlOut: pp.controlOut.ToRpc(),
		UseHeading: pp.useHeading,
		Heading:    float32(pp.heading),
	}
}
