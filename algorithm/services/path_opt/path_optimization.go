package pathopt

import (
	"fmt"
	"math"
	"slices"
	"sync"

	trajcalc "github.com/Team1690/Pathfinder/services/traj_calc"
)

const (
	GENSIZE   = 50 // Amount of path individuals per generation
	GENAMOUNT = 20 // Amount of generations to run
)

// Main Optimization Function
func OptimizePath(path *Individual, robotParams *trajcalc.RobotParameters) *Individual {
	// make a slice to store the best path individual from each generation
	best := make([]*Individual, GENAMOUNT)

	// create the base individual
	baseIndividual := path.Copy()

	// fill the base generation
	currentGeneration := make([]*Individual, GENSIZE)
	for i := range currentGeneration {
		currentGeneration[i] = baseIndividual.Copy()
	}

	// optimization loop
	for i := 0; i < GENAMOUNT; i++ {
		fmt.Printf("Gen #%d started\n", i+1)

		// optimize gen and add the best of this optimized generation to the best slice
		OptLoop(currentGeneration, robotParams)
		best[i] = currentGeneration[0].Copy() // we sort the slice inside OptLoop

		fitness := best[i].Fitness
		fmt.Printf("Gen #%d fitness = %f\n", i+1, fitness)

		fmt.Printf("Gen #%d finished\n", i+1)
	}

	// sort best paths from each generation to get the best path overall
	bestPathIdx := 0
	bestPathFitness := math.Inf(1)

	for idx, bestPath := range best {
		fitness := bestPath.Fitness
		if fitness < float32(bestPathFitness) {
			bestPathFitness = float64(fitness)
			bestPathIdx = idx
		}
	}

	// return the best path individual from all generations
	return best[bestPathIdx]
} // * OptimizePath

// optimization loop
func OptLoop(currentGeneration []*Individual, robotParams *trajcalc.RobotParameters) {
	// mutation waitgroup
	mutateWg := sync.WaitGroup{}

	// mutate and breed current generation
	mutateWg.Add(len(currentGeneration))
	for idx, individual := range currentGeneration {
		go func(idx int, individual *Individual) {
			// mutate if not the best in the generation (to keep genes pure)
			if idx >= 0.1*GENSIZE {
				individual.Mutate()
			}

			// calculate fitness inside the goroutine to save time later
			individual.CalcFitness(robotParams)

			mutateWg.Done()
		}(idx, individual)
	}

	mutateWg.Wait()

	// sort the curent generation according to fitness in ascending error
	slices.SortFunc(currentGeneration, func(i, j *Individual) int {
		if i.Fitness == j.Fitness {
			return 0
		} else if i.Fitness > j.Fitness {
			return 1
		}
		return -1
	})
} // * OptLoop
