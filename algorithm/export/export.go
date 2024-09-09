package export

import (
	"io/fs"
	"os"
	"path"

	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/utils"
	"golang.org/x/xerrors"
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

func ExportTrajectory(trajectory *rpc.TrajectoryResponse, fileName string) error {
	var out []*OutputTrajectoryPoint
	for _, point := range trajectory.GetSwervePoints().SwervePoints {
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

	const outputDirectory = "out"
	if err := os.MkdirAll(outputDirectory, fs.ModePerm); err != nil {
		return xerrors.Errorf("error in MkdirAll: %w", err)
	}

	outputFilePath := path.Join(outputDirectory, fileName)

	if err := utils.SaveCSV(outputFilePath, &out); err != nil {
		return xerrors.Errorf("error in SaveCsv: %w", err)
	}

	return nil
}
