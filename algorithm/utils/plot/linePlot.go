package plot

import (
	"fmt"
	"net/http"

	"github.com/go-echarts/go-echarts/v2/charts"
	"github.com/go-echarts/go-echarts/v2/opts"
	"github.com/go-echarts/go-echarts/v2/types"
)

func SetXAxis(chart *charts.Line, min float64, max float64, dx float64) {
	xAxisLabels := []string{}
	for x := min; x <= max; x += dx {
		xAxisLabels = append(xAxisLabels, fmt.Sprint(x))
	}
	chart.SetXAxis(xAxisLabels)
}

func PlotFunction(f func(float64) float64, min float64, max float64, title string) {
	http.HandleFunc("/", func(w http.ResponseWriter, _ *http.Request) {
		line := charts.NewLine()

		line.SetGlobalOptions(
			charts.WithInitializationOpts(opts.Initialization{Theme: types.ThemeRoma}),
			charts.WithTitleOpts(opts.Title{
				Title: title,
			}))

		dx := (max - min) / 1000

		SetXAxis(line, min, max, dx)

		data := []opts.LineData{}
		for x := min; x < max; x += dx {
			data = append(data, opts.LineData{Value: f(x)})
		}

		line.AddSeries(title, data)

		line.Render(w)
	})
}

func PlotData(inputData []float64, title string) {
	http.HandleFunc("/line", func(w http.ResponseWriter, _ *http.Request) {
		line := charts.NewLine()

		line.SetGlobalOptions(
			charts.WithInitializationOpts(opts.Initialization{Theme: types.ThemeRoma}),
			charts.WithTitleOpts(opts.Title{
				Title: title,
			}))

		SetXAxis(line, 0, float64(len(inputData)), 1)

		lineData := []opts.LineData{}
		for _, datapoint := range inputData {
			lineData = append(lineData, opts.LineData{Value: datapoint})
		}

		line.AddSeries(title, lineData)

		line.Render(w)
	})
}
