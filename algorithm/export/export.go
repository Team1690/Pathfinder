package export

import (
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils"
)

type OutputTrajectoryPoint struct {
	Time            float32 `csv:"time"`
	PositionX       float32 `csv:"position_x"`
	PositionY       float32 `csv:"position_y"`
	VelocityX       float32 `csv:"velocity_x"`
	VelocityY       float32 `csv:"velocity_y"`
	Heading         float32 `csv:"heading"`
	AngularVelocity float32 `csv:"angular_velocity"`
	Action          string  `csv:"action"`
}

func ExportTrajectory(trajectory *rpc.TrajectoryResponse) {
	var out []*OutputTrajectoryPoint
	for _, point := range trajectory.SwervePoints {
		out = append(out, &OutputTrajectoryPoint{
			Time:            float32(utils.RoundToDecimal(float64(point.Time), 2)),
			PositionX:       point.Position.X,
			PositionY:       point.Position.Y,
			VelocityX:       point.Velocity.X,
			VelocityY:       point.Velocity.Y,
			Heading:         point.Heading,
			AngularVelocity: point.AngularVelocity,
			Action:          point.Action,
		})
	}

	const outputFilePath = "./out/output.csv"
	utils.SaveCSV(outputFilePath, &out)
}
