package main

import (
	"context"
	"log"
	"math"
	"net/http"
	"testing"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils/plot"
	"github.com/Team1690/Pathfinder/utils/vector"
)

func Test(_ *testing.T) {
	var (
		chester = &rpc.TrajectoryRequest_SwerveRobotParams{
			Width:           float32(0.3),
			Height:          float32(0.3),
			MaxVelocity:     3.83,
			MaxAcceleration: 9,
			MaxJerk:         50,
		}
		firstSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.8,
			Points: []*rpc.Point{
				{
					Position:   &rpc.Vector{X: 0, Y: 0},
					ControlOut: &rpc.Vector{X: 0, Y: 1},
					Heading:    0,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 1, Y: 1},
					ControlIn:  &rpc.Vector{X: 2, Y: 2},
					ControlOut: &rpc.Vector{X: 0, Y: 0},
					Heading:    math.Pi / 2,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 1, Y: 0},
					ControlIn:  &rpc.Vector{X: 2, Y: 0},
					Heading:    0,
					UseHeading: true,
				},
			},
		}

		segments = []*rpc.Segment{firstSegment}
		section  = rpc.Section{Segments: segments}
	)

	grpcServer := NewServer()

	res, err := grpcServer.CalculateTrajectory(context.TODO(), &rpc.TrajectoryRequest{
		SwerveRobotParams: chester,
		Sections:          []*rpc.Section{&section},
	})
	if err != nil {
		if err != nil {
			log.Fatalf("Failed to calc trajectory: %v", err)
		}
	}

	velTimeData := []vector.Vector{}
	velXTimeData := []vector.Vector{}
	velYTimeData := []vector.Vector{}
	velDistanceData := []vector.Vector{}
	// accTimeData := []vector.Vector{}

	headingTimeData := []vector.Vector{}
	headingDistanceData := []vector.Vector{}

	omegaTimeData := []vector.Vector{}
	omegaDistanceData := []vector.Vector{}

	// positionXData := []vector.Vector{}
	// positionYData := []vector.Vector{}
	positionData := []vector.Vector{}

	distance := 0.0
	prevPosition := vector.NewFromRpcVector(firstSegment.Points[0].Position)

	for _, point := range res.SwervePoints {
		currentPosition := vector.NewFromRpcVector(point.Position)
		distance += currentPosition.Sub(prevPosition).Norm()

		// * Position
		positionData = append(positionData, currentPosition)

		// * Velocity
		currentVelocity := vector.NewFromRpcVector(point.Velocity)

		velNorm := currentVelocity.Norm()

		velTimeData = append(velTimeData, vector.Vector{X: float64(point.Time), Y: velNorm})
		velXTimeData = append(velXTimeData, vector.Vector{X: float64(point.Time), Y: currentVelocity.X})
		velYTimeData = append(velYTimeData, vector.Vector{X: float64(point.Time), Y: currentVelocity.Y})
		velDistanceData = append(velDistanceData, vector.Vector{X: distance, Y: velNorm})

		// * Heading
		headingTimeData = append(headingTimeData, vector.Vector{X: float64(point.Time), Y: float64(point.Heading)})
		headingDistanceData = append(headingDistanceData, vector.Vector{X: distance, Y: float64(point.Heading)})

		// * Omega
		omegaTimeData = append(omegaTimeData, vector.Vector{X: float64(point.Time), Y: float64(point.AngularVelocity)})
		omegaDistanceData = append(omegaDistanceData, vector.Vector{X: distance, Y: float64(point.AngularVelocity)})

		prevPosition = currentPosition
	}

	plot.PlotScatter(positionData, "Position")

	plot.PlotScatter(velTimeData, "Velocity-Time")
	plot.PlotScatter(velDistanceData, "Velocity-Distance")
	plot.PlotScatter(velXTimeData, "VelocityX-Time")
	plot.PlotScatter(velYTimeData, "VelocityY-Time")

	plot.PlotScatter(headingTimeData, "Heading-Time")
	plot.PlotScatter(headingDistanceData, "Heading-Distance")

	plot.PlotScatter(omegaTimeData, "Omega-Time")
	plot.PlotScatter(omegaDistanceData, "Omega-Distance")

	http.ListenAndServe(":8081", nil)
}