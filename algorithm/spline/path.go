package spline

import (
	"math"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils/vector"
	"golang.org/x/xerrors"
)

type Path struct {
	Splines         []Spline
	SForEachSpline  float64
	length          *float64
	NumberOfSplines int
}

func NewPath(splines ...Spline) *Path {
	return &Path{Splines: splines, SForEachSpline: 1 / float64(len(splines)), NumberOfSplines: len(splines)}
}

// Initialize a path defined by the list of all the waypoints
func InitializePath(points []*rpc.PathPoint) (*Path, error) {
	// TODO handle more spline types
	// Fill path with 3rd deg beziers
	path := NewPath()
	for i := 0; i < len(points)-1; i++ {
		bezier := NewBezier([]vector.Vector{
			vector.NewFromRpcVector(points[i].Position),
			vector.NewFromRpcVector(points[i].ControlOut),
			vector.NewFromRpcVector(points[i+1].ControlIn),
			vector.NewFromRpcVector(points[i+1].Position),
		})
		path.AddSpline(bezier)
	}

	// If for some reason failed to add splines (less than one point possibly)
	if len(path.Splines) == 0 {
		return nil, xerrors.New("not enough splines")
	}

	return path, nil
} // * InitializePath

func (p *Path) Length() float64 {
	if p.length != nil {
		return *p.length
	}

	result := 0.0
	for _, spline := range p.Splines {
		result += spline.Length()
	}

	p.length = &result
	return result
}

func (p *Path) Evaluate(s float64) vector.Vector {
	unscaledSForEvaluatedSpline := math.Mod(s, p.SForEachSpline)
	sForEvaluatedSpline := unscaledSForEvaluatedSpline / p.SForEachSpline

	evaluatedSplineIndex := int((s - unscaledSForEvaluatedSpline) / p.SForEachSpline)

	return p.Splines[evaluatedSplineIndex].Evaluate(sForEvaluatedSpline)
}

func (p *Path) AddSpline(s Spline) {
	newSplines := append(p.Splines, s)
	*p = *NewPath(newSplines...)
}

func (p *Path) Derivative() Spline {
	derivatives := []Spline{}

	for _, spline := range p.Splines {
		derivatives = append(derivatives, spline.Derivative())
	}

	return NewPath(derivatives...)
}

func (p *Path) GetSplineIndex(s float64) int {
	unscaledSForEvaluatedSpline := math.Mod(s, p.SForEachSpline)
	evaluatedSplineIndex := int((s - unscaledSForEvaluatedSpline) / p.SForEachSpline)

	return evaluatedSplineIndex
}

// Get an array of points on the path, evaluated in an interval which is defined in units of length.
func (p *Path) EvaluateAtInterval(interval float64) []vector.Vector {
	var points []vector.Vector
	for _, spline := range p.Splines {
		ds := interval / spline.Length()
		for s := 0.0; s <= 1; s += ds {
			points = append(points, spline.Evaluate(s))
		}
	}
	return points
}
