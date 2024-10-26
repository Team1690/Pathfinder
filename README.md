# Pathfinder

Orbit 1690 Pathfinder app - a GUI tool to create autonomous trajectories for FRC robots.

To run/build the app you need to install some of the [ dev tools ](#dev-tools-install) first (all but the protobuf codegen stuff)
<br/>

---
### Build

To build the project and create a runnable file run:
```bash
sh scripts/build.sh
```
This should create a dist-\<commit-sha> folder with the files:
 - `pathfinder_gui.exe`
 - `pathfinder_algorithm.exe`
 - `pathfinder_manager.exe`

To run the app run `pathfinder_gui.exe` the app with the icon

---
### Deploy & Release

Use InnoSetup to make an installer script for the app
 - First run the build script above
 - Set Main Executable as `pathfinder_gui.exe`
 - Add additional files (everything in the dist dir)
 - Set the default location to the desktop
 - Bind the `.auton` file ending to the main executable 
 - Inno Setup will add pathfinder_gui.exe to the windows registry for you

---
### Run & Debug

Go:
launch in vscode - `Debug Go Backend`

Flutter:
launch in vscode - `Debug Flutter Frontend`


Alternativly you can run in bash:

Go:
```bash
cd ./algorithm
go run .
```

Flutter:
```bash
cd ./gui
flutter run -d windows
```

---
### General background

The project is generally seperated into 2 parts:

1. GUI - written in flutter and runs as a flutter windows application
2. Algorithm server - written in golang

The two processes communicate with each other using [protobuf](https://developers.google.com/protocol-buffers) grpc - in short protobuf is an efficient communication protocol defined using a typed language, and grpc uses protobuf to communicate between a client and a server over tcp connection.

The Algorithm server acts as a grpc server and the GUI is the client.

In the `/protos` dir of the project sit the protobuf files that define the types and commands between the GUI and the Algorithm server, and a dedicated script generates dart code (used for flutter) and go code to make the communication easier.


Directory structure -

```
.
├── ./algorithm    # Go code for the trajectory generation algorithm
├── ./docs         # Some documentation txt files to help new developers
├── ./gui          # Flutter code of GUI application
├── ./protos       # Definition of grpc protobuf protocol
├── ./scripts      # Some bash scripts used for common tasks
└── README.md
```

---

### <a name="dev-tools-install"></a>Dev tools installation

#### VScode
Install [vscode](https://code.visualstudio.com/download) - simple as that

#### Git bash
Install `git bash` - will be used to run <ins>all</ins> the scripts and should be installed anyway because you are using git!

> If one of the steps fails - google how to do it and make sure to choose the versions that are written in the install script.

#### Flutter
Follow [flutter official docs](https://docs.flutter.dev/development/tools/vs-code) on installing flutter with vscode.

Make sure to attach a windows device to run it as a flutter windows desktop app. (google that if needed)

#### Go
Install latest version of go ([download link](https://go.dev/doc/install))


#### Protobuf code gen tools
cd into the root of the project using `git bash` and run:
```bash
sh ./scripts/install.sh
```

This should:

1. Install `protoc` - a binary that used to compile the proto files
2. Install go plugin for protoc
3. Install dart plugin for protoc

To generate the pb files for each language run:
```bash
sh ./scripts/genproto.sh
```