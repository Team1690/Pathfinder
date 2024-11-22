package splinecalc

import "github.com/Team1690/Pathfinder/utils/vector"

// This is a interface symbolizing a spline
//
// Examples for splines:
//
// Bezier, Hermite, B-spline, Catmull-Rom, linear, etc.
type Spline interface {
	Evaluate(s float64) vector.Vector
	Derivative() Spline
	Length() float64
}
