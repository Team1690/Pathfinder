package pathfinder

import (
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
)

type indexedActionPoint struct {
	action *rpc.RobotAction
	index  int
}

type SegmentClassifier struct {
	segments  []*rpc.Segment
	wayPoints []*rpc.Point

	currentPointIndex              int
	currentSegmentIndex            int
	currentPointIndexInsideSegment int

	headingPoints []*indexedHeadingPoint

	actionPoints []*indexedActionPoint
}

func NewSegmentClassifier(segments []*rpc.Segment) *SegmentClassifier {
	points := []*rpc.Point{}

	for _, segment := range segments {
		points = append(points, segment.Points...)
	}

	headingPoints := []*indexedHeadingPoint{
		{heading: float64(segments[0].Points[0].Heading), index: 0}, // * Always using first point's heading
	}

	return &SegmentClassifier{
		segments:                       segments,
		wayPoints:                      points,
		currentPointIndex:              0,
		currentPointIndexInsideSegment: 0,
		currentSegmentIndex:            0,
		headingPoints:                  headingPoints,
	}
}

func shoutestRouteToHeading(initialHeading float64, endHeading float64) float64 {
	return initialHeading + utils.WrapAngle(endHeading-initialHeading)
}

func (s *SegmentClassifier) addHeadingPoint(waypoint *rpc.Point, trajectoryIndex int) {
	prevHeading := s.headingPoints[len(s.headingPoints)-1].heading
	s.headingPoints = append(s.headingPoints, &indexedHeadingPoint{
		// * Taking the shortest route to the wanted heading by wrapping angles
		heading: shoutestRouteToHeading(prevHeading, float64(waypoint.Heading)),
		index:   trajectoryIndex,
	})
}

func (s *SegmentClassifier) checkForNewSegment() {
	if s.currentPointIndexInsideSegment >= len(s.segments[s.currentSegmentIndex].Points) {
		s.currentSegmentIndex++
		s.currentPointIndexInsideSegment = 0
	}
}

func (s *SegmentClassifier) Update(position *vector.Vector, trajectoryIndex int) {
	nextWaypointPosition := vector.NewFromRpcVector(s.wayPoints[s.currentPointIndex+1].Position)

	if position.Sub(nextWaypointPosition).Norm() < deltaDistanceForEvaluation {
		s.currentPointIndex++

		if s.currentPointIndex == len(s.wayPoints)-1 {
			return // * Taking care of last heading in a separate function
		}

		currentWaypoint := s.wayPoints[s.currentPointIndex]
		if currentWaypoint.UseHeading {
			s.addHeadingPoint(currentWaypoint, trajectoryIndex)
		}

		if currentWaypoint.Action.ActionType != "" {
			s.actionPoints = append(s.actionPoints,
				&indexedActionPoint{index: trajectoryIndex, action: currentWaypoint.Action})
		}

		s.currentPointIndexInsideSegment++
		s.checkForNewSegment()
	}
}

func (s *SegmentClassifier) AddLastHeading(trajectoryLength int) {
	// * Adding the final heading
	lastPoint := s.wayPoints[len(s.wayPoints)-1]
	prevHeading := s.headingPoints[len(s.headingPoints)-1].heading
	if lastPoint.UseHeading {
		s.headingPoints = append(s.headingPoints, &indexedHeadingPoint{index: trajectoryLength - 1, heading: shoutestRouteToHeading(prevHeading, float64(lastPoint.Heading))})
	} else {
		// * If the last point doesn't use heading, the heading at the end is the previous heading
		s.headingPoints = append(s.headingPoints, &indexedHeadingPoint{index: trajectoryLength - 1, heading: prevHeading})
	}
}

func (s *SegmentClassifier) GetMaxVel() float64 {
	return float64(s.segments[s.currentSegmentIndex].MaxVelocity)
}

func (s *SegmentClassifier) GetActionPoints() []*indexedActionPoint {
	return s.actionPoints
}

func (s *SegmentClassifier) GetHeadingPoints() []*indexedHeadingPoint {
	return s.headingPoints
}
