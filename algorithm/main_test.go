package main

import (
	"context"
	"fmt"
	"log"
	"testing"

	"github.com/Team1690/Pathfinder/rpc"
)

func Test(_ *testing.T) {
	var (
		chester = &rpc.TrajectoryRequest_SwerveRobotParams{
			Width:                         float32(0.6),
			Height:                        float32(0.6),
			MaxVelocity:                   3.6,
			MaxAcceleration:               7.5,
			SkidAcceleration:              7.5,
			MaxJerk:                       50,
			CycleTime:                     0.02,
			AngularAccelerationPercentage: 0.1,
		}
		firstSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.6,
			Points: []*rpc.Point{
				{
					Position:   &rpc.Vector{X: 0, Y: 0},
					ControlOut: &rpc.Vector{X: 2, Y: 2},
					Heading:    0,
					UseHeading: true,
					Action:     &rpc.RobotAction{ActionType: ""},
				},
			},
		}

		secondSegment = &rpc.Segment{
			SplineType:            rpc.SplineTypes_Bezier,
			MaxVelocity:           3.6,
			IsPathFollowerHeading: true,
			Points: []*rpc.Point{
				{
					UseHeading: false,
					Position:   &rpc.Vector{X: 2.5, Y: 2.5},
					ControlIn:  &rpc.Vector{X: 1, Y: 1},
					ControlOut: &rpc.Vector{X: 4, Y: 4},
					Action:     &rpc.RobotAction{ActionType: ""},
				},
			},
		}

		thirdSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.6,
			Points: []*rpc.Point{
				{
					UseHeading: false,
					Position:   &rpc.Vector{X: 4, Y: 0},
					ControlIn:  &rpc.Vector{X: 7, Y: 0},
					ControlOut: &rpc.Vector{X: 1, Y: 0},
					Action:     &rpc.RobotAction{ActionType: ""},
				},
				{
					UseHeading: true,
					Heading:    0,
					Position:   &rpc.Vector{X: 0, Y: 0},
					ControlIn:  &rpc.Vector{X: 1, Y: 0},
					Action:     &rpc.RobotAction{ActionType: ""},
				},
			},
		}

		firstSectionSegments = []*rpc.Segment{firstSegment, secondSegment, thirdSegment}
		firstSection         = rpc.Section{Segments: firstSectionSegments}
	)

	logger := log.Default()
	grpcServer := NewServer(logger)

	res, err := grpcServer.CalculateTrajectory(context.TODO(), &rpc.TrajectoryRequest{
		SwerveRobotParams:  chester,
		Sections:           []*rpc.Section{&firstSection},
		TrajectoryFileName: "test",
	})
	if err != nil {
		if err != nil {
			log.Fatalf("Failed to calc trajectory: %v", err)
		}
	}

	fmt.Println("Written trajectory file.")

	GenerateGraphs(res, chester)
}
