MACOS=false

PROTOC_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-win64.zip"

if $MACOS; then
	PROTOC_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-osx-x86_64.zip"
fi

PROTOC_ZIP_FILE="protoc.zip"

TEMP_DIR=".temp"

# CD into the bin dir
mkdir ./.bin || true
cd ./.bin

mkdir $TEMP_DIR || true

curl -sL --output $TEMP_DIR/$PROTOC_ZIP_FILE $PROTOC_URL
unzip -p $TEMP_DIR/$PROTOC_ZIP_FILE bin/protoc* > protoc

rm -rf $TEMP_DIR

go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1
