package utils

import (
	"math"
)

const twoPi float64 = math.Pi * 2

func WrapAngle(theta float64) float64 {
	wrapped := math.Mod(theta, twoPi)
	if wrapped > math.Pi {
		return wrapped - twoPi
	} else if wrapped < -math.Pi {
		return wrapped + twoPi
	} else {
		return wrapped
	}
}

func Min(values ...float64) float64 {
	result := values[0]
	for i := 0; i < len(values); i++ {
		if values[i] < result {
			result = values[i]
		}
	}
	return result
}

func BinomialCoefficients(n int, k int) int {
	// "outside" Pascal's triangle
	if k < 0 || k > n {
		return 0
	}

	// binomial symmetry (less iterations )
	if k > n-k {
		k = n - k
	}

	// simplification of binomial formula: bn(n, k) = n!/(k!(n-k)!)
	mult := 1
	for i := 1; i <= k; i++ {
		mult *= (n - i + 1) / k
	}
	return mult
} // * BinomialCoefficients

func GetBernstein(n int, k int) func(s float64) float64 {
	binom := float64(BinomialCoefficients(n, k))
	return func(s float64) float64 {
		return binom * math.Pow(s, float64(k)) * math.Pow((1-s), float64((n-k)))
	}
}

// The value of the function ranges from x to y as t ranges from 0 to 1
func Lerp(x float64, y float64, t float64) float64 {
	return (1-t)*x + t*y
}

// Returns the ratio of the lerp of x and y that results in lerpValue
func ReverseLerp(x float64, y float64, lerpValue float64) float64 {
	return (lerpValue - x) / (y - x)
}

func Signum(x float64) int {
	if x > 0 {
		return 1
	}
	if x < 0 {
		return -1
	}
	return 0
}

func RoundToDecimal(x float64, decimalPlace int) float64 {
	tenToTheDecimal := math.Pow10(decimalPlace)
	return math.Round(float64(x*tenToTheDecimal)) / tenToTheDecimal
}
