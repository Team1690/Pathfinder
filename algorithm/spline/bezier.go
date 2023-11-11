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
	var pointsPolynomials []PolynomialAndPoint
	for index, point := range b.Points {
		polynomial := utils.GetBernstein(b.degree, index)
		pointsPolynomials = append(pointsPolynomials, PolynomialAndPoint{point: point, polynomial: polynomial})
	}

	return evaluateBasedOnPolynomaials(s, pointsPolynomials)
}

func (b *Bezier) Length() float64 {
	return Length(b)
}

func (b *Bezier) Derivative() Spline {
	derivativePoints := []vector.Vector{}
	for i := 0; i < len(b.Points)-1; i++ {
		derivativePoints = append(derivativePoints, b.Points[i+1].Sub(b.Points[i]).Scale(float64(b.degree)))
	}
	return NewBezier(derivativePoints)
}
