PROTOS_DIR="./protos"

# GO Stuff
GO_PACKAGE_DIR="./algorithm"
GO_RPC_OUT_DIR="$GO_PACKAGE_DIR/rpc"

# DART Stuff
DART_RPC_OUT_DIR="./gui/lib/rpc"

# TODO: move the plugins to a directory here
export PATH="$PATH:$HOME/AppData/Local/Pub/Cache/bin"
export PATH="$PATH:$(go env GOPATH)/bin"

for FILE in $PROTOS_DIR/*; do
	protoc --proto_path=protos --go_out=$GO_PACKAGE_DIR \
		--go-grpc_out=$GO_RPC_OUT_DIR --go-grpc_opt=paths=source_relative \
		$FILE
	echo "Generated GO code for '$FILE'"

	protoc --dart_out=grpc:$DART_RPC_OUT_DIR \
		$FILE
	echo "Generated DART code for '$FILE'"
done
