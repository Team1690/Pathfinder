package spline

import (
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type QuinticHermite struct {
	DefaultSplineImpl

	Points      []vector.Vector
	Polynomials []utils.Polynomial
}

var _ Spline = (*QuinticHermite)(nil)

func NewQuinticHermite(p0, p1, v0, v1, a0, a1 vector.Vector) *QuinticHermite {
	return &QuinticHermite{
		Points: []vector.Vector{
			p0,
			p1,
			v0,
			a1,
			v1,
			p1,
		},
		Polynomials: hermitePoynomials[:],
	}
}

var hermitePoynomials = [6]utils.Polynomial{
	// H0(t) = 1 − 10t3 + 15t4 − 6t5
	{
		Coefficients: []float64{1, 0, 0, -10, 15, -6},
	},
	// H1(t) = t − 6t3 + 8t4 − 3t5
	{
		Coefficients: []float64{0, 1, 0, -6, 8, -3},
	},
	// H2(t) = 1 2 t2 − 3 2 t3 + 3 2 t4 − 1 2 t5
	{
		Coefficients: []float64{0, 0, 0.5, -1.5, 1.5, -0.5},
	},
	// H3(t) = 1 2 t3 − t4 + 1 2 t5
	{
		Coefficients: []float64{0, 0, 0, 0.5, -1, 0.5},
	},
	// H4(t) = −4t3 + 7t4 − 3t5
	{
		Coefficients: []float64{0, 0, 0, -4, 7, -3},
	},
	// H5(t) = 10t3 − 15t4 + 6t5
	{
		Coefficients: []float64{0, 0, 0, 10, -15, 6},
	},
}

func (b *QuinticHermite) Evaluate(s float64) vector.Vector {
	var pointsPolynomials []PolynomialAndPoint
	for index, point := range b.Points {
		polynomial := b.Polynomials[index].Evaluate
		pointsPolynomials = append(pointsPolynomials, PolynomialAndPoint{point: point, polynomial: polynomial})
	}

	return evaluateBasedOnPolynomaials(s, pointsPolynomials)
}

func (s *QuinticHermite) Derivative() Spline {
	var derivativeOfPolynomials []utils.Polynomial

	for _, polynomial := range s.Polynomials {
		derivativeOfPolynomials = append(derivativeOfPolynomials, polynomial.Derivative())
	}
	return &QuinticHermite{
		Points:      s.Points,
		Polynomials: derivativeOfPolynomials,
	}

}
