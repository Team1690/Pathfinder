package export

import (
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils"
)

type OutputTrajctoryPoint struct {
	Time            float32 `csv:"time"`
	PositionX       float32 `csv:"position_x"`
	PositionY       float32 `csv:"position_y"`
	VelocityX       float32 `csv:"velocity_x"`
	VelocityY       float32 `csv:"velocity_y"`
	Heading         float32 `csv:"heading"`
	AngularVelocity float32 `csv:"angular_velocitiy"`
}

func ExportTrajectory(trajectory *rpc.TrajectoryResponse) {
	var out []*OutputTrajctoryPoint
	for _, point := range trajectory.SwervePoints {
		out = append(out, &OutputTrajctoryPoint{
			Time:            point.Time,
			PositionX:       point.Position.X,
			PositionY:       point.Position.Y,
			VelocityX:       point.Velocity.X,
			VelocityY:       point.Velocity.Y,
			Heading:         point.Heading,
			AngularVelocity: point.AngularVelocity,
		})
	}

	const outputFilePath = "./output.csv"
	utils.SaveCSV(outputFilePath, &out)
}
