package main

import (
	"context"
	"fmt"
	"log"
	"math"
	"testing"

	"github.com/Team1690/Pathfinder/rpc"
)

func Test(_ *testing.T) {
	var (
		chester = &rpc.TrajectoryRequest_SwerveParams{
			SwerveParams: &rpc.SwerveRobotParams{
				Width:            float32(0.6),
				Height:           float32(0.6),
				MaxVelocity:      3.6,
				MaxAcceleration:  7.5,
				SkidAcceleration: 7.5,
				MaxJerk:          50,
				CycleTime:        0.02,
			},
		}
		firstSegment = &rpc.Segment{
			MaxVelocity: 3.6,
			Points: []*rpc.PathPoint{
				{
					Position:   &rpc.Vector{X: 0, Y: 0},
					ControlOut: &rpc.Vector{X: 3, Y: 0},
					Heading:    0,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 2.5, Y: 2.5},
					ControlIn:  &rpc.Vector{X: 2.5, Y: -0.5},
					ControlOut: &rpc.Vector{X: 2.5, Y: 3},
					Heading:    math.Pi,
					UseHeading: true,
				},
			},
		}

		secondSegment = &rpc.Segment{
			MaxVelocity: 3.6,
			Points: []*rpc.PathPoint{
				{
					Position:   &rpc.Vector{X: 2.5, Y: 2.5},
					ControlOut: &rpc.Vector{X: 1, Y: 1},
					Heading:    math.Pi,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 0, Y: 0},
					ControlIn:  &rpc.Vector{X: 1, Y: 1},
					Heading:    0,
					UseHeading: true,
				},
			},
		}

		firstSectionSegments = []*rpc.Segment{firstSegment}
		firstSection         = rpc.Section{Segments: firstSectionSegments}

		secondSectionSegments = []*rpc.Segment{secondSegment}
		secondSection         = rpc.Section{Segments: secondSectionSegments}
	)

	logger := log.Default()
	grpcServer := NewServer(logger)

	res, err := grpcServer.CalculateTrajectory(context.TODO(), &rpc.TrajectoryRequest{
		RobotParams: chester,
		Sections:    []*rpc.Section{&firstSection, &secondSection},
	})
	if err != nil {
		log.Fatalf("Failed to calc trajectory: %v", err)
	}

	fmt.Println("Written trajectory file.")

	GenerateGraphs(res, chester)
}
