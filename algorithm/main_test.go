package main

import (
	"context"
	"fmt"
	"log"
	"math"
	"net/http"
	"testing"

	"github.com/Team1690/Pathfinder/export"
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils/plot"
	"github.com/Team1690/Pathfinder/utils/vector"
)

func Test(_ *testing.T) {
	var (
		chester = &rpc.TrajectoryRequest_SwerveRobotParams{
			Width:            float32(0.3),
			Height:           float32(0.3),
			MaxVelocity:      3.83,
			MaxAcceleration:  9,
			SkidAcceleration: 7.5,
			MaxJerk:          50,
			CycleTime:        0.02,
		}
		firstSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.8,
			Points: []*rpc.Point{
				{
					Position:   &rpc.Vector{X: 1, Y: 2},
					ControlOut: &rpc.Vector{X: 3, Y: 2},
					Heading:    0,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 2, Y: 0},
					ControlIn:  &rpc.Vector{X: 0, Y: 1},
					ControlOut: &rpc.Vector{X: 4, Y: -1},
					Heading:    0,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 1, Y: 2},
					ControlIn:  &rpc.Vector{X: 5, Y: 4},
					Heading:    math.Pi / 2,
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
	velDirTimeData := []vector.Vector{}
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

		velDirTimeData = append(velDirTimeData, vector.Vector{X: float64(point.Time), Y: currentVelocity.Angle()})

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
	plot.PlotScatter(velDirTimeData, "VelocityDirection-Time")
	plot.PlotScatter(velXTimeData, "VelocityX-Time")
	plot.PlotScatter(velYTimeData, "VelocityY-Time")

	plot.PlotScatter(headingTimeData, "Heading-Time")
	plot.PlotScatter(headingDistanceData, "Heading-Distance")

	plot.PlotScatter(omegaTimeData, "Omega-Time")
	plot.PlotScatter(omegaDistanceData, "Omega-Distance")

	// * Write results to a csv file
	export.ExportTrajectory(res)
	fmt.Println("Written trajectory file")

	http.ListenAndServe(":8081", nil)
}
