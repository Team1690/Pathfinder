package pathopt

import (
	"sort"

	"github.com/Team1690/Pathfinder/rpc"
	"golang.org/x/xerrors"
)

const (
	GENSIZE   = 50
	GENAMOUNT = 100
)

func OptimizePath(path *rpc.PathModel, swerveParams *rpc.SwerveRobotParams) *Individual {
	// make a slice to store the best path individual from each generation
	best := make([]*Individual, GENAMOUNT)

	// create the base individual
	baseIndividual := IndividualFromPathModel(path)

	// fill the base generation
	currentGeneration := make([]*Individual, GENSIZE)
	for i := range currentGeneration {
		currentGeneration[i] = baseIndividual.Copy()
	}

	// optimization loop
	for i := 0; i < GENAMOUNT; i++ {
		OptLoop(currentGeneration, swerveParams)

		best[i] = currentGeneration[0].Copy()
	}

	// sort best paths from each generation to get the best path overall
	sort.Slice(best, func(i, j int) bool {
		iFitness, _ := currentGeneration[i].CalcFitness(swerveParams)
		jFitness, _ := currentGeneration[j].CalcFitness(swerveParams)
		return iFitness < jFitness
	})

	return best[0]
}

func OptLoop(currentGeneration []*Individual, swerveParams *rpc.SwerveRobotParams) error {
	for idx, individual := range currentGeneration {
		if idx >= 0.1*GENSIZE {
			individual.Mutate()
		}
	}

	var err error

	sort.Slice(currentGeneration, func(i, j int) bool {
		iFitness, ierr := currentGeneration[i].CalcFitness(swerveParams)
		jFitness, jerr := currentGeneration[j].CalcFitness(swerveParams)
		if ierr != nil || jerr != nil {
			err = xerrors.New("Error in Calculating Fitness, Abort Optimization")
		}
		return iFitness < jFitness
	})

	return err
}

func CopyGeneration(gen []*Individual) []*Individual {
	newGeneration := make([]*Individual, len(gen))
	for i, individual := range gen {
		newGeneration[i] = individual.Copy()
	}
	return newGeneration
}
