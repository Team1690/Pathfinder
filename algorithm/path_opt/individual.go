package pathopt

import (
	"math/rand"

	"github.com/Team1690/Pathfinder/rpc"
)

type Individual struct {
	points      []*rpc.PathPoint
	optSegments []*rpc.OptSegment
	optSections []*rpc.OptSection
}

func (path *Individual) CalcFitness(swerveParams *rpc.SwerveRobotParams) {

}

func (path *Individual) ToSections() []*rpc.Section {
	// get pathSegments (all the segments of this path individual)
	pathSegments := path.ToSegments()

	// make a new slice of sections
	sections := make([]*rpc.Section, len(path.optSections))

	// fill each section with its appropriate segments
	for i, optsec := range path.optSections {
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
	segments := make([]*rpc.Segment, len(path.optSegments))

	// fill each segment with points from the path according to its point indexes
	for i, optseg := range path.optSegments {
		points := make([]*rpc.PathPoint, len(optseg.PointIndexes))
		for j, pointIdx := range optseg.PointIndexes {
			//TODO: do i care that this is by reference?
			points[j] = path.points[pointIdx]
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
	for _, point := range path.points {
		MutatePathPoint(point)
	}
} // * Mutate

func MutatePathPoint(pp *rpc.PathPoint) {
	// mutate in control point
	pp.ControlIn = &rpc.Vector{
		X: pp.ControlIn.X + 2*rand.Float32() - 1,
		Y: pp.ControlIn.Y + 2*rand.Float32() - 1,
	}

	// mutate out control point
	pp.ControlOut = &rpc.Vector{
		X: pp.ControlOut.X + 2*rand.Float32() - 1,
		Y: pp.ControlOut.Y + 2*rand.Float32() - 1,
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
	newPath := &Individual{}

	// copy points
	newPath.points = make([]*rpc.PathPoint, len(path.points))
	for i, point := range path.points {
		newPath.points[i] = CopyPathPoint(point)
	}

	// copy opt segments
	newPath.optSegments = make([]*rpc.OptSegment, len(path.optSegments))
	for i, optSegment := range path.optSegments {
		newPath.optSegments[i] = CopyOptSegment(optSegment)
	}

	// copy opt sections
	newPath.optSections = make([]*rpc.OptSection, len(path.optSections))
	for _, optSection := range path.optSections {
		newPath.optSections[i] = CopyOptSection(optSection)
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
	for i, pointIdx := range optseg.PointIndexes {
		newOptSegment.PointIndexes[i] = pointIdx
	}

	// return new OptSegment copy
	return newOptSegment
} // * CopyOptSegment

func CopyOptSection(optsec *rpc.OptSection) *rpc.OptSection {
	// make new OptSection
	newOptSection := &rpc.OptSection{}

	// Copy values into new OptSection
	newOptSection.SegmentIndexes = make([]int32, len(optsec.SegmentIndexes))
	for i, segIdx := range optsec.SegmentIndexes {
		newOptSection.SegmentIndexes[i] = segIdx
	}

	// return new OptSection copy
	return newOptSection
} // * CopyOptSection
