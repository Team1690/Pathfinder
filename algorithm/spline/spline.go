package spline

import "github.com/Team1690/Pathfinder/utils/vector"

type Spline interface {
	Evaluate(s float64) vector.Vector
	Derivative() Spline
	Length() float64
}