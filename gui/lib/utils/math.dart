import "dart:math";

double radians(final double deg) => pi * deg / 180;

double degrees(final double deg) => 180 * deg / pi;

double sign(final double number) => number < 0
    ? -1
    : number > 0
        ? 1
        : 0;
