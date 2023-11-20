package tank

type TrajectoryPoint struct {
	Time          float64
	S             float64
	DistanceL     float64
	VelocityL     float64
	AccelerationL float64
	DistanceR     float64
	VelocityR     float64
	AccelerationR float64
	Action        string
}

type RobotParameters struct {
	Width           float64
	Height          float64
	MaxVelocity     float64
	MaxAcceleration float64
	MaxJerk         float64
	CycleTime       float64
}
