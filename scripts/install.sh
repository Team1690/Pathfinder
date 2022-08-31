PROTOC_URL="https://github.com/protocolbuffers/protobuf/releases/download/v3.19.1/protoc-3.19.1-win64.zip"

PROTOC_ZIP_FILE="protoc.zip"

TEMP_DIR=".temp"

# CD into the bin dir
mkdir ./.bin || true
cd ./.bin

mkdir $TEMP_DIR || true

curl -sL --output $TEMP_DIR/$PROTOC_ZIP_FILE $PROTOC_URL
unzip -p $TEMP_DIR/$PROTOC_ZIP_FILE bin/protoc* > protoc

rm -rf $TEMP_DIR

echo "Installing go plugin"
go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.26
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.1

echo "Installing flutter plugin"
dart pub global activate protoc_plugin 20.0.1
