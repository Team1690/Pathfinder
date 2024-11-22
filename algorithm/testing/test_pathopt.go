package main

// import (
// 	"fmt"
// 	"time"

// 	"github.com/Team1690/Pathfinder/rpc"
// 	pathopt "github.com/Team1690/Pathfinder/services/path_opt"
// 	trajcalc "github.com/Team1690/Pathfinder/services/traj_calc"
// )

// func main() {
// 	// f, err := os.Create("cpu_profile.prof")
// 	// if err != nil {
// 	// 	log.Fatal(err)
// 	// }
// 	// defer f.Close()
// 	// if err := pprof.StartCPUProfile(f); err != nil {
// 	// 	log.Fatal(err)
// 	// }
// 	// defer pprof.StopCPUProfile()

// 	const loopamount = 1
// 	runtimes := make([]float64, loopamount)
// 	for i := 0; i < loopamount; i++ {
// 		runtimes[i] = loop()
// 	}
// 	for idx, runtime := range runtimes {
// 		if idx == len(runtimes)-1 {
// 			fmt.Printf("%.3f\n", runtime)
// 		} else {
// 			fmt.Printf("%.3f, ", runtime)
// 		}
// 	}
// }

// func loop() float64 {
// 	var (
// 		chester = &trajcalc.RobotParameters{
// 			Radius:           0.849,
// 			MaxVelocity:      3.6,
// 			MaxAcceleration:  7.5,
// 			SkidAcceleration: 7.5,
// 			MaxJerk:          50,
// 			CycleTime:        0.02,
// 		}

// 		points = []*rpc.PathPoint{
// 			{
// 				Position:   &rpc.Vector{X: 0, Y: 0},
// 				ControlOut: &rpc.Vector{X: 3, Y: 0},
// 				Heading:    0,
// 				UseHeading: true,
// 				Action: &rpc.RobotAction{
// 					ActionType: "none",
// 					Time:       0,
// 				},
// 			},
// 			{
// 				Position:   &rpc.Vector{X: 2.5, Y: 2.5},
// 				ControlIn:  &rpc.Vector{X: 2.5, Y: -0.5},
// 				ControlOut: &rpc.Vector{X: 2.5, Y: 3},
// 				Heading:    0,
// 				UseHeading: true,
// 				Action: &rpc.RobotAction{
// 					ActionType: "none",
// 					Time:       0,
// 				},
// 			},
// 			{
// 				Position:   &rpc.Vector{X: 0, Y: 0},
// 				ControlIn:  &rpc.Vector{X: 1, Y: 1},
// 				Heading:    0,
// 				UseHeading: true,
// 				Action: &rpc.RobotAction{
// 					ActionType: "none",
// 					Time:       0,
// 				},
// 			},
// 		}

// 		optSegments = []*rpc.OptSegment{
// 			{
// 				PointIndexes: []int32{0, 1},
// 				Speed:        3.6,
// 			},
// 			{
// 				PointIndexes: []int32{1, 2},
// 				Speed:        2,
// 			},
// 		}

// 		optSections = []*rpc.OptSection{
// 			{
// 				SegmentIndexes: []int32{0, 1},
// 			},
// 		}

// 		individual = &pathopt.Individual{
// 			Points:      points,
// 			OptSegments: optSegments,
// 			OptSections: optSections,
// 		}
// 	)

// 	fitnessBefore, _ := individual.CalcFitness(chester)
// 	fmt.Printf("fitness before optimization: %f\n", fitnessBefore)
// 	prev := time.Now().UnixMilli()
// 	optimizedPath := pathopt.OptimizePath(individual, chester)
// 	runtime := float64(time.Now().UnixMilli()-prev) / 1000.0
// 	fitnessAfter, _ := optimizedPath.CalcFitness(chester)
// 	fmt.Printf("fitness after optimization: %f\n", fitnessAfter)
// 	fmt.Println()
// 	fmt.Printf("runtime: %f\n", runtime)
// 	fmt.Println()
// 	return runtime
// }
