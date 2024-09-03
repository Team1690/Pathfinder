import "dart:math";

//TODO: do we need these functions?
double degToRad(final double deg) => pi * deg / 180;

double radToDeg(final double deg) => 180 * deg / pi;

int signum(final num number) => number.compareTo(0);
