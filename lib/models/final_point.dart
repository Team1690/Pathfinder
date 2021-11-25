import 'package:pathfinder/models/Point.dart';

class FinalPoint extends Point {
  final int finalFrom;
  final double finalDistance;

  FinalPoint(this.finalFrom, this.finalDistance);
}
