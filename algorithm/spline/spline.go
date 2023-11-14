package spline

import "github.com/Team1690/Pathfinder/utils/vector"

type Spline interface {
	Evaluate(s float64) vector.Vector
	Derivative() Spline
	Length() float64
}

type DefaultSplineImpl struct {
}

var _ Spline = (*DefaultSplineImpl)(nil)

func (d DefaultSplineImpl) Evaluate(s float64) vector.Vector { return vector.Zero() }
func (d *DefaultSplineImpl) Derivative() Spline              { return d }

func (d *DefaultSplineImpl) Length() float64 {
	length := 0.0

	const dt float64 = 0.005

	prevPosition := vector.Zero()

	for t := 0.0; t <= 1; t += dt {
		currentPosition := d.Evaluate(t)
		length += currentPosition.Sub(prevPosition).Norm()
		prevPosition = currentPosition
	}

	return length
}

type PolynomialAndPoint struct {
	point      vector.Vector
	polynomial func(s float64) float64
}

func evaluateBasedOnPolynomaials(s float64, points []PolynomialAndPoint) vector.Vector {
	result := vector.Zero()

	for _, point := range points {
		pointFactor := point.polynomial(s)
		result = result.Add(point.point.Scale(pointFactor))
	}

	return result
}
