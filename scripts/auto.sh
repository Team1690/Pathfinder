COMMIT_SUFFIX=$(git rev-parse --short HEAD)
OUTPUT_DIR=dist-Release

rm -rf $OUTPUT_DIR

echo "Building flutter"
cd gui
flutter pub get
flutter build windows
cd ../

echo "Building go"
cd algorithm
go build -ldflags="-H windowsgui" .
cd ../

echo "Putting everything in './$OUTPUT_DIR'"
mkdir $OUTPUT_DIR

cp -r gui/build/windows/x64/runner/Release/* $OUTPUT_DIR
mv algorithm/Pathfinder.exe $OUTPUT_DIR/Pathfinder-algorithm.exe