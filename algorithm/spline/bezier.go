package spline

import (
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type Bezier struct {
	Points []vector.Vector
	degree int
}

var _ Spline = (*Bezier)(nil)

func NewBezier(points []vector.Vector) *Bezier {
	return &Bezier{
		Points: points,
		degree: len(points) - 1,
	}
}

func (b *Bezier) Evaluate(s float64) vector.Vector {
	result := vector.Zero()

	for index, point := range b.Points {
		pointFactor := utils.GetBernstein(b.degree, index)(s)
		result = result.Add(point.Scale(pointFactor))
	}

	return result
}

func (b *Bezier) Length() float64 {
	length := 0.0

	const dt float64 = 0.005

	prevPosition := vector.Zero()

	for t := 0.0; t <= 1; t += dt {
		currentPosition := b.Evaluate(t)
		length += currentPosition.Sub(prevPosition).Norm()
		prevPosition = currentPosition
	}

	return length
}

func (b *Bezier) Derivative() Spline {
	derivativePoints := []vector.Vector{}
	for i := 0; i < len(b.Points)-1; i++ {
		derivativePoints = append(derivativePoints, b.Points[i+1].Sub(b.Points[i]).Scale(float64(b.degree)))
	}
	return NewBezier(derivativePoints)
}