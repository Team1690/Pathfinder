import "dart:async";
import "dart:ui" as ui;
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:pathfinder/models/point.dart";
import "package:pathfinder/models/robot.dart";
import "package:pathfinder/models/segment.dart";

import "package:pathfinder/models/spline_point.dart" as modelspath;

import "package:pathfinder/widgets/editor/field_editor/point_type.dart";

import "package:pathfinder/widgets/editor/field_editor/field_painter.dart";
import "package:pathfinder/widgets/editor/field_editor/point_settings.dart";

import "package:pathfinder/widgets/editor/path_editor/full_dragging_point.dart";

const double headingLength = 50;

Map<PointType, PointSettings> pointSettings = <PointType, PointSettings>{
  PointType.path: PointSettings(const Color(0xbbdddddd), 8),
  PointType.inControl: PointSettings(Colors.orange, 6),
  PointType.outControl: PointSettings(Colors.yellow, 6),
  PointType.heading: PointSettings(const Color(0xffc80000), 6),
};

class FieldLoader extends StatefulWidget {
  FieldLoader(
    this.points,
    this.segments,
    this.selectedPoint,
    this.dragPoints,
    this.enableHeadingEditing,
    this.enableControlEditing,
    this.evaluatedPoints,
    this.setFieldSizePixels,
    this.robot,
    this.imageZoom,
    this.imageOffset,
  );
  final List<Point> points;
  final List<Segment> segments;
  final int? selectedPoint;
  final List<FullDraggingPoint> dragPoints;
  final bool enableHeadingEditing;
  final bool enableControlEditing;
  final List<modelspath.SplinePoint> evaluatedPoints;
  final Function(Offset) setFieldSizePixels;
  final Robot robot;
  final double imageZoom;
  final Offset imageOffset;

  @override
  _FieldLoaderState createState() => _FieldLoaderState();
}

ui.Image? globalImage;

class _FieldLoaderState extends State<FieldLoader> {
  bool isImageloaded = globalImage != null;
  void initState() {
    super.initState();
    init();
  }

  Future<Null> init() async {
    if (globalImage != null) {
      return;
    }

    final ByteData data =
        await rootBundle.load("assets/images/frc_2023_field.png");
    globalImage = await loadImage(Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(final Uint8List img) async {
    final Completer<ui.Image> completer = Completer<ui.Image>();
    ui.decodeImageFromList(img, (final ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Widget _buildImage() {
    final double width = 0.7 * MediaQuery.of(context).size.width;
    final double height = 0.6 * MediaQuery.of(context).size.height;
    widget.setFieldSizePixels(Offset(width, height));

    if (isImageloaded) {
      // if (false) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 14,
              offset: const Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: CustomPaint(
          painter: FieldPainter(
            globalImage!,
            widget.points,
            widget.segments,
            widget.selectedPoint,
            widget.dragPoints,
            widget.enableHeadingEditing,
            widget.enableControlEditing,
            widget.evaluatedPoints,
            widget.robot,
            widget.imageZoom,
            widget.imageOffset,
          ),
          size: Size(width, height),
        ),
      );
    } else {
      return const Center(child: Text("loading"));
    }
  }

  @override
  Widget build(final BuildContext context) => _buildImage();
}