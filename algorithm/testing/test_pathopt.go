package main

import (
	pathopt "github.com/Team1690/Pathfinder/path_opt"
	"github.com/Team1690/Pathfinder/rpc"
)

func main() {
	var (
		chester = &rpc.SwerveRobotParams{
			Width:            float32(0.6),
			Height:           float32(0.6),
			MaxVelocity:      3.6,
			MaxAcceleration:  7.5,
			SkidAcceleration: 7.5,
			MaxJerk:          50,
			CycleTime:        0.02,
		}

		points = []*rpc.PathPoint{
			{
				Position:   &rpc.Vector{X: 0, Y: 0},
				ControlOut: &rpc.Vector{X: 3, Y: 0},
				Heading:    0,
				UseHeading: true,
				Action: &rpc.RobotAction{
					ActionType: "none",
					Time:       0,
				},
			},
			{
				Position:   &rpc.Vector{X: 2.5, Y: 2.5},
				ControlIn:  &rpc.Vector{X: 2.5, Y: -0.5},
				ControlOut: &rpc.Vector{X: 2.5, Y: 3},
				Heading:    0,
				UseHeading: true,
				Action: &rpc.RobotAction{
					ActionType: "none",
					Time:       0,
				},
			},
			{
				Position:   &rpc.Vector{X: 0, Y: 0},
				ControlIn:  &rpc.Vector{X: 1, Y: 1},
				Heading:    0,
				UseHeading: true,
				Action: &rpc.RobotAction{
					ActionType: "none",
					Time:       0,
				},
			},
		}

		optSegments = []*rpc.OptSegment{
			{
				PointIndexes: []int32{0, 1},
				Speed:        3.6,
			},
			{
				PointIndexes: []int32{1, 2},
				Speed:        2,
			},
		}

		optSections = []*rpc.OptSection{
			{
				SegmentIndexes: []int32{0, 1},
			},
		}

		individual = &pathopt.Individual{
			Points:      points,
			OptSegments: optSegments,
			OptSections: optSections,
		}
	)

}
