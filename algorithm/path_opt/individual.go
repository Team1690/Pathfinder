package pathopt

import "github.com/Team1690/Pathfinder/rpc"

type Individual struct {
	points      []*rpc.PathPoint
	optSegments []*rpc.OptSegment
	optSections []*rpc.OptSection
}

func (path *Individual) CalcFitness()                            {}
func (path *Individual) Mutate() *Individual                     {}
func (path *Individual) Breed(otherPath *Individual) *Individual {}

/* Copy Funcs */
// Returns a hard copy of this path individual
func (path *Individual) Copy() *Individual {
	newPath := &Individual{}
	newPath.points = make([]*rpc.PathPoint, len(path.points))
	for i, point := range path.points {
		newPath.points[i] = CopyPathPoint(point)
	}
	newPath.optSegments = make([]*rpc.OptSegment, len(path.optSegments))
	for i, optSegment := range path.optSegments {
		newPath.optSegments[i] = CopyOptSegment(optSegment)
	}
	newPath.optSections = make([]*rpc.OptSection, len(path.optSections))
	for _, optSection := range path.optSections {
		newPath.optSections[i] = CopyOptSection(optSection)
	}
	return newPath
}

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
