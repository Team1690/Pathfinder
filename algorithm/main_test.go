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
	main()
}

func main() {
	var (
		chester = pathfinder.RobotParameters{
			Radius:           0.3,
			MaxVelocity:      3.83,
			MaxAcceleration:  9,
			SkidAcceleration: 7.5,
			MaxJerk:          50,
			CycleTime:        0.02,
		}

		firstBezier  = spline.NewBezier([]vector.Vector{{X: 0, Y: 0}, {X: 0.42, Y: 0}, {X: 0.58, Y: 1}, {X: 1, Y: 1}})
		secondBezier = spline.NewBezier([]vector.Vector{{X: 1, Y: 1}, {X: 1.42, Y: 1}, {X: 1.58, Y: 0}, {X: 2, Y: 0}})

		path = path.NewPath(firstBezier, secondBezier)
	)
	plot.PlotSpline(path, "Path")

	const segmentMaxVel float64 = 3.8

	trajectory := pathfinder.CreateTrajectoryPointArray(path, chester)
	pathfinder.LimitVelocityWithCentrifugalForce(&trajectory, segmentMaxVel, chester)
	pathfinder.SetHeading(&trajectory, 0, math.Pi)
	pathfinder.CalculateKinematics(&trajectory, chester)
	pathfinder.CalculateKinematicsReverse(&trajectory, chester)

	scatterData := []vector.Vector{}

	for _, trajectoryPoint := range trajectory {
		scatterData = append(scatterData, vector.Vector{X: trajectoryPoint.Time, Y: trajectoryPoint.Velocity})
	}
	plot.PlotScatter(scatterData, "Velocity-Time")

	http.ListenAndServe(":8081", nil)
}
