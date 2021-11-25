import 'package:pathfinder/models/Point.dart';

class RelativePoint extends Point {
  final int floatingFrom;
  final double floatingDistance;

  RelativePoint(this.floatingFrom, this.floatingDistance);
}
