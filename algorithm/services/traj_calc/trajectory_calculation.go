package trajcalc

import (
	"sync"

	"github.com/Team1690/Pathfinder/export"
	"github.com/Team1690/Pathfinder/rpc"
	"github.com/Team1690/Pathfinder/services/spline_calc/spline"
	"golang.org/x/xerrors"
)

// Calculates the Trajectory of a single section (like it's a full path)
func CalculateSectionTrajectory(section *rpc.Section, robot *RobotParameters) ([]*rpc.SwervePoints_SwervePoint, error) {
	// fill list with points
	points := []*rpc.PathPoint{}
	for _, segment := range section.Segments {
		points = append(points, segment.Points...)
	}
	if len(points) < 2 {
		return nil, xerrors.New("requested a path of one point")
	}

	// Initialize the path with the points from the section (make a spline from the points)
	path, err := spline.InitializePath(points)
	if err != nil {
		return nil, xerrors.Errorf("error in init path: %w", err)
	}

	// creates the array of trajectory points
	// (without 2D, meaning that there is no direction yet for the velocity)
	trajectory, err := CreateTrajectoryPointArray(path, robot, section.Segments)
	if err != nil {
		return nil, xerrors.Errorf("error in creating trajectory point array: %w", err)
	}

	// Add a heading for the velocity (from the spline)
	trajectory2D := Get2DTrajectory(trajectory, path)

	// Change the trajectory points to (in this case swerve points)
	var swerveTrajectory []*rpc.SwervePoints_SwervePoint // TODO: generalize for tank
	for _, point := range trajectory2D {
		swerveTrajectory = append(swerveTrajectory, ToRpcSwervePoint(point))
	}

	// return the calculated swerve trajectory
	return swerveTrajectory, nil
} // * CalculateSectionTrajectory

func CalculateTrajectory(trajRequest *rpc.TrajectoryRequest) (*rpc.TrajectoryResponse, error) {
	// Get robot parameters
	robot := GetRobotParamsTraj(trajRequest)

	// waitgroup to wait for section calculations
	trajWg := sync.WaitGroup{}

	// recieve each sections points
	results := make([][]*rpc.SwervePoints_SwervePoint, len(trajRequest.Sections))
	var oerr error // optional error

	// calculate each section
	trajWg.Add(len(trajRequest.Sections))
	for idx, section := range trajRequest.Sections {
		go func(idx int, section *rpc.Section) {
			points, err := CalculateSectionTrajectory(section, robot)

			if err != nil {
				oerr = err
				return
			}

			results[idx] = points
			trajWg.Done()
		}(idx, section)
	}

	trajWg.Wait()

	if oerr != nil {
		return nil, oerr
	}

	// flatten the results slice
	var points []*rpc.SwervePoints_SwervePoint
	for _, trajectoryRes := range results {
		points = append(points, trajectoryRes...)
	}

	// TODO : maybe move this to server.go
	// make a response from the points
	res := &rpc.TrajectoryResponse{Points: &rpc.TrajectoryResponse_SwervePoints{ // TODO : add Tank
		SwervePoints: &rpc.SwervePoints{
			SwervePoints: points,
		},
	}}

	// TODO because you already send to the gui the trajectory i think the gui should handle exporting traj
	// * Write results to a csv file
	if err := export.ExportTrajectory(res, trajRequest.FileName); err != nil {
		return nil, xerrors.Errorf("error in ExportTrajectory: %w", err)
	}

	// return response to be used in the server
	return res, nil
}
