package utils

import "math"

type Polynomial struct {
	Coefficients []float64
}

func (p *Polynomial) Evaluate(x float64) float64 {
	res := 0.0
	for index, coef := range p.Coefficients {
		res += coef * math.Pow(x, float64(index))
	}
	return res
}

func (p *Polynomial) Derivative() Polynomial {
	var coefficients []float64

	for index, coef := range p.Coefficients[1:] {
		coefficients = append(coefficients, coef*(float64(index)+1))
	}
	return Polynomial{
		Coefficients: coefficients,
	}
}
