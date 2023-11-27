COMMIT_SUFFIX=$(git rev-parse --short HEAD)
OUTPUT_DIR=dist-$COMMIT_SUFFIX

sh scripts/build.sh
"./$OUTPUT_DIR/Pathfinder-algorithm.exe" &