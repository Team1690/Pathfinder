import "package:flutter/material.dart";
import "package:pathfinder/rpc/protos/PathFinder.pb.dart" as rpc;

class SplinePoint extends StatelessWidget {
  const SplinePoint({
    final Key? key,
    required this.point,
  });
  final rpc.SplineResponse_Point point;
  final Color color = const Color.fromARGB(75, 255, 255, 255);

  @override
  Widget build(final BuildContext context) {
    const double radius = 2;

    return Positioned(
      left: point.point.x - radius,
      top: point.point.y - radius,
      child: MouseRegion(
        child: GestureDetector(
          child: Container(
            width: 2 * radius,
            height: 2 * radius,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
