package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"testing"

	"github.com/Team1690/Pathfinder/rpc"
)

func Test(_ *testing.T) {
	var (
		firstSegment = &rpc.Segment{
			SplineType:  rpc.SplineTypes_Bezier,
			MaxVelocity: 3.8,
			Points: []*rpc.Point{
				{
					Position:   &rpc.Vector{X: 0.1, Y: 0.1},
					ControlOut: &rpc.Vector{X: 0, Y: 1},
					Heading:    0,
					UseHeading: true,
				},
				{
					Position:   &rpc.Vector{X: 1, Y: 1},
					ControlIn:  &rpc.Vector{X: 2, Y: 2},
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
		SwerveRobotParams: &rpc.TrajectoryRequest_SwerveRobotParams{
			Width:           float32(0.3),
			Height:          float32(0.3),
			MaxVelocity:     3.83,
			MaxAcceleration: 9,
			MaxJerk:         50,
		},
		Sections: []*rpc.Section{&section},
	})
	if err != nil {
		if err != nil {
			log.Fatalf("Failed to calc trajectory: %v", err)
		}
	}

	// TODO add debug for the result of the trajectory calculation from server
	for _, point := range res.SwervePoints {
		fmt.Println(point)
	}

	// plot.PlotSpline(path, "Path")
	// plot.PlotSpline(path.Derivative(), "Path-Derivative")

	// trajectory, _ := pathfinder.CreateTrajectoryPointArray(path, &chester, segments)
	// pathfinder.LimitVelocityWithCentrifugalForce(trajectory, &chester)
	// pathfinder.CalculateKinematics(trajectory, &chester)
	// pathfinder.CalculateKinematicsReverse(trajectory, &chester)
	// pathfinder.CalculateDtAndOmegaAfterReverse(trajectory)

	// quantizedTrajectory := pathfinder.QuantizeTrajectory(trajectory, chester.CycleTime)

	// swerveTrajectory := pathfinder.Get2DTrajectory(quantizedTrajectory, path)

	// velTimeData := []vector.Vector{}
	// velXTimeData := []vector.Vector{}
	// velYTimeData := []vector.Vector{}
	// velDistanceData := []vector.Vector{}
	// accTimeData := []vector.Vector{}

	// headingTimeData := []vector.Vector{}
	// headingDistanceData := []vector.Vector{}

	// omegaTimeData := []vector.Vector{}
	// omegaDistanceData := []vector.Vector{}

	// positionXData := []vector.Vector{}
	// positionYData := []vector.Vector{}
	// positionData := []vector.Vector{}

	// for _, trajectoryPoint := range quantizedTrajectory {
	// 	velTimeData = append(velTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Velocity})
	// 	accTimeData = append(accTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Acceleration})
	// 	velDistanceData = append(velDistanceData, vector.Vector{X: trajectoryPoint.Distance, Y: trajectoryPoint.Velocity})

	// 	headingTimeData = append(headingTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Heading})
	// 	headingDistanceData = append(headingDistanceData, vector.Vector{X: trajectoryPoint.Distance, Y: trajectoryPoint.Heading})

	// 	omegaTimeData = append(omegaTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Omega})
	// 	omegaDistanceData = append(omegaDistanceData, vector.Vector{X: trajectoryPoint.Distance, Y: trajectoryPoint.Omega})

	// 	positionXData = append(positionXData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Position.X})
	// 	positionYData = append(positionYData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Position.Y})
	// 	positionData = append(positionData, trajectoryPoint.Position)

	// }

	// for _, point := range swerveTrajectory {
	// 	velXTimeData = append(velXTimeData, vector.Vector{X: point.Time, Y: point.Velocity.X})
	// 	velYTimeData = append(velYTimeData, vector.Vector{X: point.Time, Y: point.Velocity.Y})
	// }
	// plot.PlotScatter(positionData, "Position")
	// plot.PlotScatter(positionXData, "PositionX-Time")
	// plot.PlotScatter(positionYData, "PositionY-Time")

	// plot.PlotScatter(velTimeData, "Velocity-Time")
	// plot.PlotScatter(velXTimeData, "VelocityX-Time")
	// plot.PlotScatter(velYTimeData, "VelocityY-Time")
	// plot.PlotScatter(accTimeData, "Acceleration-Time")
	// plot.PlotScatter(velDistanceData, "Velocity-Distance")

	// plot.PlotScatter(headingTimeData, "Heading-Time")
	// plot.PlotScatter(headingDistanceData, "Heading-Distance")

	// plot.PlotScatter(omegaTimeData, "Omega-Time")
	// plot.PlotScatter(omegaDistanceData, "Omega-Distance")

	http.ListenAndServe(":8081", nil)
}
