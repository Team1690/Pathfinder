package main

type Drivetrain int

const (
	Swerve Drivetrain = iota
	Tank
)

func (drivetrain *Drivetrain) Name() string {
	return [...]string{"Swerve", "Tank"}[*drivetrain]
}

func (drivetrain *Drivetrain) Next() Drivetrain {
	return (*drivetrain + 1) % 2
}
