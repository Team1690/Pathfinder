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
 - `Pathfinder.exe`
 - `pathfinder-algorithm.exe`

Confusingly the `pathfinder-alogirthm.exe` is the file you want to run to execute the app.

---
### Run & Debug

Go:
launch in vscode - `Debug Go Backend`


Flutter:
launch in vscode - `Debug Flutter Frontend`
<br/>
<br/>

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

The project is seperated into 2 parts:

1. GUI - written in flutter and runs as a flutter windows application
2. Algorithm server - written in go

The two communicate with each other using [protobuf](https://developers.google.com/protocol-buffers) grpc - in short protobuf is an efficient communication protocol defined using a typed language, and grpc is using protobuf to communicate between a client and a server over tcp connection.

The Algorithm server acts as a grpc server and the GUI is the client.

In the `/protos` dir of the project sit the protobuf files that define the types and commands between the GUI and the Algorithm server, and a dedicated script generates dart code (used for flutter) and go code to make the communication easier.


Directory structure -

```
.
├── ./scripts      # some bash scripts used for common tasks
├── ./protos       # definition of grpc protobuf protocol
├── ./algorithm    # Go code for the trajectory generation algorithm
├── ./.vscode      # vscode files
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
Install go 1.17.x ([download link](https://go.dev/dl/go1.17.11.windows-amd64.msi))
> Make sure to not update to any version greater than 1.17 because it will cause the hack of running the flutter GUI from the Go application (read in TBD) not to work.

#### Protobuf code gen tools
cd into the root of the project using `git bash` and run:
```bash
sh ./scripts/install.sh
```

This should:

1. Install `protoc` - a binary that used to compile the proto files
2. Install go plugin for protoc
3. Install dart plugin for protoc