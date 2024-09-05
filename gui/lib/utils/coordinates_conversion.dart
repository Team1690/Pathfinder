import "package:flutter/cupertino.dart";

Offset flipYAxisByField(Offset val, final Offset fieldSizePixels) {
  val = val.translate(0, -fieldSizePixels.dy);
  val = val.scale(1, -1);
  return val;
}

Offset flipYAxis(final Offset val) => val.scale(1, -1);
