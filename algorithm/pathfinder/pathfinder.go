package pathfinder

import (
	"errors"
	"math"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/spline"
	"github.com/Team1690/Pathfinder/utils"
	"github.com/Team1690/Pathfinder/utils/vector"
	"golang.org/x/xerrors"
)

type TrajectoryPoint struct {
	Time         float64
	S            float64
	Distance     float64
	Position     vector.Vector
	Velocity     float64
	Acceleration float64
	Heading      float64
	Omega        float64
}

type RobotParameters struct {
	Radius           float64
	MaxVelocity      float64
	MaxAcceleration  float64
	SkidAcceleration float64
	MaxJerk          float64
	CycleTime        float64
}

type segmentClassification struct {
	distance float64
	segment  *rpc.Segment
}

type segmentClassifier struct {
	classifications []*segmentClassification
}

func NewSegmentClassifier(path spline.Spline, segments []*rpc.Segment) *segmentClassifier {
	const deltaDistanceForEvaluation = 0.0001
	const resolutionForSegmentDeclaration = 10 * deltaDistanceForEvaluation

	ds := deltaDistanceForEvaluation / path.Length()

	prevPoint := path.Evaluate(0)

	distance := 0.0
	segmentIndex := 0
	currentSegmentStartingPoint := vector.NewFromRpcVector(segments[segmentIndex].Points[0].Position)

	var classifications []*segmentClassification

	for s := ds; s <= 1; s += ds {
		currentPoint := path.Evaluate(s)

		prevPointToCurrent := currentPoint.Sub(prevPoint)
		distanceToPrevPoint := prevPointToCurrent.Norm()
		distance += distanceToPrevPoint

		// TODO the path could intersect itself
		if currentPoint.Sub(currentSegmentStartingPoint).Norm() < resolutionForSegmentDeclaration {
			classifications = append(classifications, &segmentClassification{distance, segments[segmentIndex]})

			segmentIndex++
			if segmentIndex >= len(segments) {
				break
			}
			currentSegmentStartingPoint = vector.NewFromRpcVector(segments[segmentIndex].Points[0].Position)
		}
	}

	return &segmentClassifier{classifications}
}

func (s *segmentClassifier) getSegment(point *TrajectoryPoint) (*rpc.Segment, error) {
	for _, segmentClassification := range s.classifications {
		if point.Distance >= segmentClassification.distance {
			return segmentClassification.segment, nil
		}
	}

	return nil, errors.New("no segment was found")
}

func CreateTrajectoryPointArray(spline spline.Spline, robot *RobotParameters, segClass *segmentClassifier) ([]*TrajectoryPoint, error) {
	const deltaDistanceForEvaluation float64 = 0.00001

	splineLength := spline.Length()

	ds := deltaDistanceForEvaluation / splineLength

	trajectoryPointsCount := int(1 / ds)

	firstPoint := TrajectoryPoint{Distance: 0, S: 0, Position: spline.Evaluate(0), Velocity: 0}

	trajectory := []*TrajectoryPoint{&firstPoint}

	addPoint := func(s float64, prevPoint *TrajectoryPoint) error {
		point := TrajectoryPoint{S: s, Position: spline.Evaluate(s)}

		prevPointToCurrent := point.Position.Sub(prevPoint.Position)
		distanceToPrevPoint := prevPointToCurrent.Norm()
		point.Distance = prevPoint.Distance + distanceToPrevPoint

		if segClass != nil {
			// * In test, there will be no segments from rpc
			currentPointSegment, err := segClass.getSegment(&point)
			if err != nil {
				return xerrors.Errorf("error in getting segment for point: %w", err)
			}

			point.Velocity = float64(currentPointSegment.MaxVelocity)
		}

		trajectory = append(trajectory, &point)

		return nil
	}

	for i := 1; i < trajectoryPointsCount; i++ {
		s := ds * float64(i)
		addPoint(s, trajectory[i-1])
	}

	return trajectory, nil
}

func LimitVelocityWithCentrifugalForce(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters, hasSegments bool) {
	trajectoryPointsCount := len(trajectoryPoints)
	for i := 1; i < trajectoryPointsCount-1; i++ {
		prevPointToCurrent := trajectoryPoints[i].Position.Sub(trajectoryPoints[i-1].Position)

		distanceToPrevPoint := prevPointToCurrent.Norm()

		currentPointToNextPoint := trajectoryPoints[i+1].Position.Sub(trajectoryPoints[i].Position)
		dAngle := math.Abs(utils.WrapAngle(currentPointToNextPoint.Angle() - prevPointToCurrent.Angle()))

		driveRadius := 0.0

		if dAngle == 0 {
			driveRadius = math.Inf(1)
		} else {
			driveRadius = distanceToPrevPoint / dAngle
		}

		maxVelAccordingToCentrifugalForce := math.Sqrt(driveRadius * robot.SkidAcceleration)

		// * In test, there will be no segments, so the velocity will be initialized to zero
		if hasSegments {
			// * This is the max velocity allowed at this point
			trajectoryPoints[i].Velocity = math.Min(trajectoryPoints[i].Velocity, maxVelAccordingToCentrifugalForce)
		} else {
			trajectoryPoints[i].Velocity = maxVelAccordingToCentrifugalForce
		}
	}
}

func SetHeading(trajectoryPoints []*TrajectoryPoint, headingStart float64, headingEnd float64) {
	const distancePercentageForAngularAcceleration float64 = 0.05
	const oneMinusDistancePercentageForAcceleration float64 = 1 - distancePercentageForAngularAcceleration
	const twiceAccelerationPercentageTimesOneMinus = 2 * distancePercentageForAngularAcceleration * oneMinusDistancePercentageForAcceleration

	trajectoryPointsCount := len(trajectoryPoints)
	travelDistance := trajectoryPoints[trajectoryPointsCount-1].Distance - trajectoryPoints[0].Distance

	distanceToAccelerate := distancePercentageForAngularAcceleration * travelDistance

	dHeading := headingEnd - headingStart

	travelDistanceSquared := math.Pow(travelDistance, 2)

	angularAcceleration := dHeading / (twiceAccelerationPercentageTimesOneMinus * travelDistanceSquared)
	constantOmega := dHeading / (oneMinusDistancePercentageForAcceleration * travelDistance)

	headingAtEndOfAcceleration := angularAcceleration * math.Pow(distanceToAccelerate, 2)

	for i := 0; i < trajectoryPointsCount; i++ {
		if trajectoryPoints[i].Distance < distanceToAccelerate {
			// Acceleration parabola
			trajectoryPoints[i].Heading = headingStart + angularAcceleration*math.Pow(trajectoryPoints[i].Distance, 2)

		} else if trajectoryPoints[i].Distance < travelDistance-distanceToAccelerate {
			// Constant omega linear interpolation
			trajectoryPoints[i].Heading = headingStart + headingAtEndOfAcceleration + constantOmega*(trajectoryPoints[i].Distance-distanceToAccelerate)

		} else {
			// Deceleration parabola
			trajectoryPoints[i].Heading = headingEnd - angularAcceleration*math.Pow(travelDistance-trajectoryPoints[i].Distance, 2)
		}
	}
}

func GetFirstPoint(distance float64, robot *RobotParameters) *TrajectoryPoint {
	firstPointTime := math.Pow(6*distance/robot.MaxJerk, float64(1)/float64(3))

	return &TrajectoryPoint{
		Time:         firstPointTime,
		Velocity:     0.5 * robot.MaxJerk * firstPointTime * firstPointTime,
		Acceleration: robot.MaxJerk * firstPointTime,
	}
}

func CalculateKinematics(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters) {
	actualFirstPoint := trajectoryPoints[0]
	trajectoryPoints[0] = GetFirstPoint(trajectoryPoints[1].Distance, robot)

	trajectoryPoints[0].Heading = actualFirstPoint.Heading

	for i := 1; i < len(trajectoryPoints); i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt

		maxVelAccordingToOmega := robot.MaxVelocity - math.Abs(robot.Radius*currentPoint.Omega)

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
			robot.MaxAcceleration*(1-prevPoint.Velocity/maxVelAccordingToOmega),
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, maxVelAccordingToOmega, prevPoint.Velocity+prevPoint.Acceleration*dt)
		currentPoint.Time = prevPoint.Time + dt

	}

	trajectoryPoints[0] = actualFirstPoint
}

func CalculateKinematicsReverse(trajectoryPoints []*TrajectoryPoint, robot *RobotParameters) {
	actualLastPoint := trajectoryPoints[len(trajectoryPoints)-1]
	trajectoryPoints[len(trajectoryPoints)-1] = GetFirstPoint(
		actualLastPoint.Distance-trajectoryPoints[len(trajectoryPoints)-2].Distance,
		robot,
	)
	trajectoryPoints[len(trajectoryPoints)-1].Distance = actualLastPoint.Distance - trajectoryPoints[len(trajectoryPoints)-1].Distance
	trajectoryPoints[len(trajectoryPoints)-1].Heading = actualLastPoint.Heading

	for i := len(trajectoryPoints) - 2; i >= 0; i-- {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i+1]

		distanceFromPrevPoint := prevPoint.Distance - currentPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (prevPoint.Heading - currentPoint.Heading) / dt

		maxVelAccordingToOmega := robot.MaxVelocity - math.Abs(robot.Radius*currentPoint.Omega)

		currentPoint.Acceleration = utils.Min(
			robot.SkidAcceleration,
			robot.MaxAcceleration,
			prevPoint.Acceleration+robot.MaxJerk*dt,
		)

		currentPoint.Velocity = utils.Min(currentPoint.Velocity, maxVelAccordingToOmega, prevPoint.Velocity+prevPoint.Acceleration*dt)
	}

	trajectoryPoints[len(trajectoryPoints)-1] = actualLastPoint
	trajectoryPoints[len(trajectoryPoints)-1].Acceleration = 0
}

func CalculateDtAndOmegaAfterReverse(trajectoryPoints []*TrajectoryPoint) {
	trajectoryPoints[0].Time = 0
	for i := 2; i < len(trajectoryPoints); i++ {
		currentPoint := trajectoryPoints[i]
		prevPoint := trajectoryPoints[i-1]
		distanceFromPrevPoint := currentPoint.Distance - prevPoint.Distance
		dt := distanceFromPrevPoint / prevPoint.Velocity

		currentPoint.Omega = (currentPoint.Heading - prevPoint.Heading) / dt
		currentPoint.Time = prevPoint.Time + dt
		// TODO remove acc calculation (not used)
		currentPoint.Acceleration = (currentPoint.Velocity - prevPoint.Velocity) / dt
	}
}

func SearchForTime(trajectoryPoints []*TrajectoryPoint, time float64, lastSearchIndex int) int {
	for index, point := range trajectoryPoints[lastSearchIndex:] {
		if point.Time >= time {
			return index + lastSearchIndex
		}
	}
	return -1
}

func QuantizeTrajectory(trajectoryPoints []*TrajectoryPoint, cycleTime float64) []*TrajectoryPoint {
	quantizedTrajectory := []*TrajectoryPoint{trajectoryPoints[0]}

	lastPointTime := trajectoryPoints[len(trajectoryPoints)-1].Time

	searchIndex := 0

	for t := cycleTime; t < lastPointTime; t += cycleTime {
		searchIndex = SearchForTime(trajectoryPoints, t, searchIndex)
		nextPoint := trajectoryPoints[searchIndex]
		prevPoint := trajectoryPoints[searchIndex-1]
		nextToPreviousPointRatio := utils.ReverseLerp(prevPoint.Time, nextPoint.Time, t)

		// TODO remove Distance and Acceleration calculation (not used)
		quantizedPoint := TrajectoryPoint{
			Time:         t,
			S:            utils.Lerp(prevPoint.S, nextPoint.S, nextToPreviousPointRatio),
			Distance:     utils.Lerp(prevPoint.Distance, nextPoint.Distance, nextToPreviousPointRatio),
			Position:     vector.Lerp(prevPoint.Position, nextPoint.Position, nextToPreviousPointRatio),
			Velocity:     utils.Lerp(prevPoint.Velocity, nextPoint.Velocity, nextToPreviousPointRatio),
			Acceleration: utils.Lerp(prevPoint.Acceleration, nextPoint.Acceleration, nextToPreviousPointRatio),
			Heading:      utils.Lerp(prevPoint.Heading, nextPoint.Heading, nextToPreviousPointRatio),
			Omega:        utils.Lerp(prevPoint.Omega, nextPoint.Omega, nextToPreviousPointRatio),
		}
		quantizedTrajectory = append(quantizedTrajectory, &quantizedPoint)
	}

	return quantizedTrajectory
}

type SwerveTrajectoryPoint struct {
	Time     float64
	Position vector.Vector
	Velocity vector.Vector
	Heading  float64
	Omega    float64
}

func Get2DTrajectory(trajectory1D []*TrajectoryPoint, path spline.Spline) []SwerveTrajectoryPoint {
	swerveTrajectory := []SwerveTrajectoryPoint{}

	pathDerivative := path.Derivative()

	for _, trajectoryPoint1D := range trajectory1D {
		swerveTrajectory = append(swerveTrajectory, SwerveTrajectoryPoint{
			Time:     trajectoryPoint1D.Time,
			Position: trajectoryPoint1D.Position,
			Velocity: vector.FromPolar(pathDerivative.Evaluate(trajectoryPoint1D.S).Angle(), trajectoryPoint1D.Velocity),
			Heading:  trajectoryPoint1D.Heading,
			Omega:    trajectoryPoint1D.Omega,
		})
	}

	return swerveTrajectory
}

func ToRpcSwervePoint(point *SwerveTrajectoryPoint) *rpc.TrajectoryResponse_SwervePoint {
	return &rpc.TrajectoryResponse_SwervePoint{
		Time:            float32(point.Time),
		Position:        point.Position.ToRpc(),
		Velocity:        point.Velocity.ToRpc(),
		Heading:         float32(point.Heading),
		AngularVelocity: float32(point.Omega),
	}
}
