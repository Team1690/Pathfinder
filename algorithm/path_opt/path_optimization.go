package pathopt

import (
	"fmt"
	"sort"

	"github.com/Team1690/Pathfinder/rpc"
	"golang.org/x/xerrors"
)

const (
	GENSIZE   = 10 // Amount of path individuals per generation
	GENAMOUNT = 5  // Amount of generations to run
)

// Main Optimization Function
func OptimizePath(path *Individual, swerveParams *rpc.SwerveRobotParams) *Individual {
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
		OptLoop(currentGeneration, swerveParams)
		best[i] = currentGeneration[0].Copy() // we sort the slice inside OptLoop

		fitness, _ := best[i].CalcFitness(swerveParams)
		fmt.Printf("Gen #%d fitness = %f\n", i+1, fitness)

		fmt.Printf("Gen #%d finished\n", i+1)
	}

	// sort best paths from each generation to get the best path overall
	sort.Slice(best, func(i, j int) bool {
		iFitness, _ := currentGeneration[i].CalcFitness(swerveParams)
		jFitness, _ := currentGeneration[j].CalcFitness(swerveParams)
		return iFitness > jFitness
	})

	// return the best path individual from all generations
	return best[0]
} // * OptimizePath

// optimization loop
func OptLoop(currentGeneration []*Individual, swerveParams *rpc.SwerveRobotParams) error {
	// mutate and breed current generation
	for idx, individual := range currentGeneration {
		// mutate if not the best in the generation (to keep genes pure)
		if idx >= 0.1*GENSIZE {
			individual.Mutate()
		}
	}

	// optional error
	var err error = nil

	// sort the curent generation according to fitness in ascending error
	sort.Slice(currentGeneration, func(i, j int) bool {
		iFitness, ierr := currentGeneration[i].CalcFitness(swerveParams)
		jFitness, jerr := currentGeneration[j].CalcFitness(swerveParams)

		if ierr != nil || jerr != nil {
			err = xerrors.New("Error in Calculating Fitness, Abort Optimization")
		}

		return iFitness < jFitness
	})

	// return an error (may be nil)
	return err
} // * OptLoop
