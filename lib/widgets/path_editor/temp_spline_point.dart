import 'package:flutter/material.dart';
import 'package:pathfinder/rpc/protos/PathFinder.pb.dart' as rpc;

class SplinePoint extends StatelessWidget {
  final rpc.SplineResponse_Point point;
  final Color color = const Color.fromARGB(75, 255, 255, 255);

  const SplinePoint({
    Key? key,
    required this.point,
  });

  @override
  Widget build(BuildContext context) {
    double radius = 2;

    return Positioned(
      left: point.point.x - radius,
      top: point.point.y - radius,
      child: MouseRegion(
        child: GestureDetector(
          child: Container(
            width: 2 * radius,
            height: 2 * radius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
