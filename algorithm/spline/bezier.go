package spline

import (
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type Bezier struct {
	Points    []vector.Vector
	degree    int
	Bernstein func(float64) vector.Vector
}

var _ Spline = (*Bezier)(nil)

func NewBezier(points []vector.Vector) *Bezier {
	bezier := &Bezier{
		Points: points,
		degree: len(points) - 1,
	}
	bezier.GetBernstein()
	return bezier
}

func MultPoint(p func(float64) float64, point vector.Vector) func(float64) vector.Vector {
	return func(s float64) vector.Vector {
		return point.Scale(p(s))
	}
}

func AddFunc(p1 func(float64) vector.Vector, p2 func(float64) vector.Vector) func(float64) vector.Vector {
	return func(s float64) vector.Vector {
		return p1(s).Add(p2(s))
	}
}

func (b *Bezier) GetBernstein() {
	result := func(float64) vector.Vector { return vector.Zero() }

	for index, point := range b.Points {
		pointFactor := utils.GetBernstein(b.degree, index)
		result = AddFunc(result, MultPoint(pointFactor, point))
	}

	b.Bernstein = result
}

func (b *Bezier) Evaluate(s float64) vector.Vector {
	return b.Bernstein(s)
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
