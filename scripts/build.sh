OUTPUT_DIR=dist

rm -rf $OUTPUT_DIR

echo "Building flutter"
flutter build windows --no-sound-null-safety

echo "Building go"
cd algorithm
go build .
cd ../

echo "Putting everything in './$OUTPUT_DIR'"
mkdir $OUTPUT_DIR

cp -r build/windows/runner/Release/* $OUTPUT_DIR
mv algorithm/Pathfinder.exe $OUTPUT_DIR/Pathfinder-algorithm.exe