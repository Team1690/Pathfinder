package main_test

import (
	"math"
	"net/http"
	"testing"

	"github.com/Team1690/Pathfinder/path"
	"github.com/Team1690/Pathfinder/pathfinder"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/plot"
	"github.com/Team1690/Pathfinder/utils/vector"
)

func Test(_ *testing.T) {
	var (
		chester = pathfinder.RobotParameters{
			Radius:           0.3,
			MaxVelocity:      3.83,
			MaxAcceleration:  9,
			SkidAcceleration: 7.5,
			MaxJerk:          50,
			CycleTime:        0.02,
		}

		firstBezier = spline.NewBezier([]vector.Vector{{X: 0, Y: 0}, {X: 0, Y: 1}, {X: 2, Y: 2}, {X: 1, Y: 1}})
		// secondBezier = spline.NewBezier([]vector.Vector{{X: 1, Y: 1}, {X: 1.7, Y: 1}, {X: 1.3, Y: 2}, {X: 2, Y: 2}})

		path = path.NewPath(firstBezier)
	)
	plot.PlotSpline(path, "Path")

	const segmentMaxVel float64 = 3.8

	trajectory := pathfinder.CreateTrajectoryPointArray(path, chester)
	pathfinder.LimitVelocityWithCentrifugalForce(&trajectory, segmentMaxVel, chester)
	pathfinder.SetHeading(&trajectory, 0, math.Pi/2)
	pathfinder.CalculateKinematics(&trajectory, chester)
	pathfinder.CalculateKinematicsReverse(&trajectory, chester)
	pathfinder.CalculateDtAndOmegaAfterReverse(&trajectory)

	// quantizedTrajectory := pathfinder.QuantizeTrajectory(trajectory, chester.CycleTime)

	velTimeData := []vector.Vector{}
	headingTimeData := []vector.Vector{}
	headingDistanceData := []vector.Vector{}

	for _, trajectoryPoint := range trajectory {
		velTimeData = append(velTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Velocity})
		headingTimeData = append(headingTimeData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Heading})
		headingDistanceData = append(headingDistanceData, vector.Vector{X: trajectoryPoint.Distance, Y: trajectoryPoint.Heading})
	}
	plot.PlotScatter(velTimeData, "Velocity-Time")
	plot.PlotScatter(headingTimeData, "Heading-Time")
	plot.PlotScatter(headingDistanceData, "Heading-Distance")

	http.ListenAndServe(":8081", nil)
}
