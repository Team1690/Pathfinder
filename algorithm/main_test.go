package main

import (
	"context"
	"fmt"
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
			Width:            float32(0.6),
			Height:           float32(0.6),
			MaxVelocity:      3.6,
			MaxAcceleration:  7.5,
			SkidAcceleration: 7.5,
			MaxJerk:          50,
			CycleTime:        0.02,
		}
		firstSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.6,
			Points: []*rpc.Point{
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
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.6,
			Points: []*rpc.Point{
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

	grpcServer := NewServer()

	res, err := grpcServer.CalculateTrajectory(context.TODO(), &rpc.TrajectoryRequest{
		SwerveRobotParams: chester,
		Sections:          []*rpc.Section{&firstSection, &secondSection},
	})
	if err != nil {
		if err != nil {
			log.Fatalf("Failed to calc trajectory: %v", err)
		}
	}

	fmt.Println("Written trajectory file.")

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

	curvatureDistanceData := []vector.Vector{}

	distance := 0.0
	prevPosition := vector.NewFromRpcVector(firstSegment.Points[0].Position)

	time := 0.0

	for _, point := range res.SwervePoints {
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
		time += float64(chester.CycleTime)
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
