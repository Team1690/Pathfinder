package plot

import (
	"net/http"

	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils/vector"
	"github.com/go-echarts/go-echarts/v2/charts"
	"github.com/go-echarts/go-echarts/v2/opts"
	"github.com/go-echarts/go-echarts/v2/types"
)

func addSplineDataPoints(b spline.Spline, chart *charts.Scatter) {
	data := []opts.ScatterData{}
	const dt float64 = 0.001
	for t := 0.0; t <= 1; t += dt {
		datapoint := b.Evaluate(t)
		data = append(data, opts.ScatterData{Value: datapoint.Array()})
	}
	chart.AddSeries("", data)
}

func PlotSpline(s spline.Spline, title string) {
	http.HandleFunc("/spline", func(w http.ResponseWriter, _ *http.Request) {
		scatter := charts.NewScatter()

		scatter.SetGlobalOptions(
			charts.WithInitializationOpts(opts.Initialization{Theme: types.ThemeRoma}),
			charts.WithTitleOpts(opts.Title{
				Title: title,
			}))

		addSplineDataPoints(s, scatter)
		scatter.Render(w)
	})
}

func PlotScatter(data []vector.Vector, title string) {
	http.HandleFunc("/scatter", func(w http.ResponseWriter, _ *http.Request) {
		scatter := charts.NewScatter()

		scatter.SetGlobalOptions(
			charts.WithInitializationOpts(opts.Initialization{Theme: types.ThemeRoma}),
			charts.WithTitleOpts(opts.Title{
				Title: title,
			}))

		chartDataPoints := []opts.ScatterData{}
		for _, dataPoint := range data {
			chartDataPoints = append(chartDataPoints, opts.ScatterData{Value: dataPoint.Array()})
		}

		scatter.AddSeries("", chartDataPoints)
		scatter.Render(w)
	})
}
