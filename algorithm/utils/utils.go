package utils

import (
	"math"
)

var twoPi float64 = math.Pi * 2

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

var factorialCache []int = []int{1, 1}

func Factorial(n int) int {
	if n <= 1 {
		return 1
	}
	if len(factorialCache) < n+1 {
		factorialCache = append(factorialCache, n*Factorial(n-1))
	}
	return factorialCache[n]
}

func BinomialCoefficients(n int, k int) int {
	if k < 0 || k > n { // "outside" Pascal's triangle
		return 0
	}
	return Factorial(n) / (Factorial(k) * Factorial(n-k))
}

func GetBernstein(n int, k int) func(s float64) float64 {
	binomialCoefficient := float64(BinomialCoefficients(n, k))
	return func(s float64) float64 {
		return binomialCoefficient * math.Pow(s, float64(k)) * math.Pow((1-s), float64((n-k)))
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
