package path

import (
	"math"

	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type Path struct {
	Splines        []spline.Spline
	sForEachSpline float64
}

func NewPath(splines ...spline.Spline) Path {
	return Path{Splines: splines, sForEachSpline: 1 / float64(len(splines))}
}

func (p Path) Length() float64 {
	result := 0.0
	for _, spline := range p.Splines {
		result += spline.Length()
	}
	return result
}

func (p Path) Evaluate(s float64) vector.Vector {
	unscaledSForEvaluatedSpline := math.Mod(s, p.sForEachSpline)
	sForEvaluatedSpline := unscaledSForEvaluatedSpline / p.sForEachSpline

	evaluatedSplineIndex := int((s - unscaledSForEvaluatedSpline) / p.sForEachSpline)

	return p.Splines[evaluatedSplineIndex].Evaluate(sForEvaluatedSpline)
}
