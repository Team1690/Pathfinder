package pathopt

import (
	"math/rand"
	"sync"

	"github.com/Team1690/Pathfinder/rpc"
	trajcalc "github.com/Team1690/Pathfinder/services/traj_calc"
)

// TODO : maybe Individual should hold the robot params
type Individual struct {
	Points      []*rpc.PathPoint
	OptSegments []*rpc.OptSegment
	OptSections []*rpc.OptSection
	Fitness     float32
}

/* Constructors */
// Makes a path individual from a path model
func IndividualFromPathModel(pathmodel *rpc.PathModel) *Individual {
	newIndividual := &Individual{
		Points:      pathmodel.PathPoints,
		OptSegments: pathmodel.Segments,
		OptSections: pathmodel.Sections,
	}
	return newIndividual.Copy()
}

func (individual *Individual) toPathModel() *rpc.PathModel {
	return &rpc.PathModel{
		PathPoints: individual.Points,
		Segments:   individual.OptSegments,
		Sections:   individual.OptSections,
	}
}

/* Fitness Funcs */
// Calculate the fitness (time to run trajectory) of a path
func (path *Individual) CalcFitness(robotParams *trajcalc.RobotParameters) (float32, error) {
	// fitness waitgroup
	fitnessWg := sync.WaitGroup{}

	// fitness var
	var fitness float32
	var err error

	// for each section calculate its fitness (time) and add it to overall fitness
	sections := path.ToSections()
	fitnessWg.Add(len(sections))
	for _, section := range sections {
		go func(section *rpc.Section) {
			//calc section fitness
			sectionFitness, errc := CalcSectionFitness(section, robotParams)

			// add to overall fitness
			err = errc
			fitness += sectionFitness
			fitnessWg.Done()

		}(section)
	}

	fitnessWg.Wait()

	// set this individuals fitness (because this is an expensive task for sorting later)
	path.Fitness = fitness

	// return fitness and no error
	return fitness, err
} // * CalcFitness

func CalcSectionFitness(section *rpc.Section, robot *trajcalc.RobotParameters) (float32, error) {
	// fitness var
	var sectionFitness float32

	// calculate section trajectory and set its fitness to trajectory time
	trajPoints, err := trajcalc.CalculateSectionTrajectory(section, robot)
	if err == nil {
		// trajectory time is the time of the first point
		sectionFitness = trajPoints[0].Time
	}

	// return section fitness and maybe error
	return sectionFitness, err
} // * CalcSectionFitness

func (path *Individual) ToSections() []*rpc.Section {
	// get pathSegments (all the segments of this path individual)
	pathSegments := path.ToSegments()

	// make a new slice of sections
	sections := make([]*rpc.Section, len(path.OptSections))

	// fill each section with its appropriate segments
	for i, optsec := range path.OptSections {
		segments := make([]*rpc.Segment, len(optsec.SegmentIndexes))
		for j, segmentIdx := range optsec.SegmentIndexes {
			segments[j] = pathSegments[segmentIdx]
		}

		sections[i] = &rpc.Section{
			Segments: segments,
		}
	}

	// return the slice of sections
	return sections
} // * ToSections

func (path *Individual) ToSegments() []*rpc.Segment {

	// make a new slice of segments
	segments := make([]*rpc.Segment, len(path.OptSegments))

	// fill each segment with points from the path according to its point indexes
	for i, optseg := range path.OptSegments {
		points := make([]*rpc.PathPoint, len(optseg.PointIndexes))
		for j, pointIdx := range optseg.PointIndexes {
			points[j] = path.Points[pointIdx]
		}

		segments[i] = &rpc.Segment{
			MaxVelocity: optseg.Speed,
			Points:      points,
		}
	}

	// return the slice of segments
	return segments
} // * ToSegments

/* Mutate funcs*/
// Mutates this individual **(does not return a copy)**
func (path *Individual) Mutate() {
	// mutate each point in the path
	for _, point := range path.Points {
		MutatePathPoint(point)
	}
} // * Mutate

func MutatePathPoint(pp *rpc.PathPoint) {
	// mutate in control point
	if pp.ControlIn != nil {
		pp.ControlIn = &rpc.Vector{
			X: pp.ControlIn.X + 2*rand.Float32() - 1,
			Y: pp.ControlIn.Y + 2*rand.Float32() - 1,
		}
	}

	// mutate out control point (if not last)
	if pp.ControlOut != nil {
		pp.ControlOut = &rpc.Vector{
			X: pp.ControlOut.X + 2*rand.Float32() - 1,
			Y: pp.ControlOut.Y + 2*rand.Float32() - 1,
		}
	}
} // * MutatePathPoint

/*Sexual Breeding Funcs*/
//TODO : implement
// func (path *Individual) Breed(otherPath *Individual) *Individual {
// 	prob := rand.Float32()
// 	if
// }

/* Copy Funcs */
// Returns a hard copy of this path individual
func (path *Individual) Copy() *Individual {
	// make a new path Individual
	newPath := &Individual{
		Fitness: path.Fitness,
	}
	newPath.Points = make([]*rpc.PathPoint, len(path.Points))
	newPath.OptSegments = make([]*rpc.OptSegment, len(path.OptSegments))
	newPath.OptSections = make([]*rpc.OptSection, len(path.OptSections))

	// copy points
	for i, point := range path.Points {
		newPath.Points[i] = CopyPathPoint(point)
	}

	// copy opt segments
	for i, optSegment := range path.OptSegments {
		newPath.OptSegments[i] = CopyOptSegment(optSegment)
	}

	// copy opt sections
	for i, optSection := range path.OptSections {
		newPath.OptSections[i] = CopyOptSection(optSection)
	}

	// return new path copy
	return newPath
} // * Copy

func CopyPathPoint(pp *rpc.PathPoint) *rpc.PathPoint {
	// make new PathPoint
	newPathPoint := &rpc.PathPoint{
		Heading:    pp.GetHeading(),
		UseHeading: pp.GetUseHeading(),
	}

	// copy values into new path point
	if pp.Position != nil {
		newPathPoint.Position = &rpc.Vector{
			X: pp.Position.X,
			Y: pp.Position.Y,
		}
	}
	if pp.ControlIn != nil {
		newPathPoint.ControlIn = &rpc.Vector{
			X: pp.ControlIn.X,
			Y: pp.ControlIn.Y,
		}
	}
	if pp.ControlOut != nil {
		newPathPoint.ControlOut = &rpc.Vector{
			X: pp.ControlOut.X,
			Y: pp.ControlOut.Y,
		}
	}
	if pp.Action != nil {
		newPathPoint.Action = &rpc.RobotAction{
			ActionType: pp.Action.ActionType,
			Time:       pp.Action.Time,
		}
	}

	// return new path point
	return newPathPoint
} // * CopyPathPoint

func CopyOptSegment(optseg *rpc.OptSegment) *rpc.OptSegment {
	// make new OptSegment
	newOptSegment := &rpc.OptSegment{
		Speed: optseg.Speed,
	}

	// Copy values into new OptSegment
	newOptSegment.PointIndexes = make([]int32, len(optseg.PointIndexes))
	copy(newOptSegment.PointIndexes, optseg.PointIndexes)

	// return new OptSegment copy
	return newOptSegment
} // * CopyOptSegment

func CopyOptSection(optsec *rpc.OptSection) *rpc.OptSection {
	// make new OptSection
	newOptSection := &rpc.OptSection{}

	// Copy values into new OptSection
	newOptSection.SegmentIndexes = make([]int32, len(optsec.SegmentIndexes))
	copy(newOptSection.SegmentIndexes, optsec.SegmentIndexes)

	// return new OptSection copy
	return newOptSection
} // * CopyOptSection
