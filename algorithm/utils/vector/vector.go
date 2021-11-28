package vector

import "math"

type Vector struct {
	X, Y float64
}

func Zero() Vector {
	return Vector{0, 0}
}

func (a Vector) Add(b Vector) Vector {
	return Vector{a.X + b.X, a.Y + b.Y}
}

func (a Vector) Sub(b Vector) Vector {
	return Vector{a.X - b.X, a.Y - b.Y}
}

func (v Vector) Scale(factor float64) Vector {
	return Vector{v.X * factor, v.Y * factor}
}

func (v Vector) Array() [2]float64 {
	return [2]float64{v.X, v.Y}
}

func (v Vector) Norm() float64 {
	return math.Hypot(v.X, v.Y)
}

func (v Vector) Angle() float64 {
	return math.Atan2(v.Y, v.X)
}
