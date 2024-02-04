//
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'PathFinder.pbenum.dart';

export 'PathFinder.pbenum.dart';

class RobotAction extends $pb.GeneratedMessage {
  factory RobotAction({
    $core.String? actionType,
    $core.double? time,
  }) {
    final $result = create();
    if (actionType != null) {
      $result.actionType = actionType;
    }
    if (time != null) {
      $result.time = time;
    }
    return $result;
  }
  RobotAction._() : super();
  factory RobotAction.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RobotAction.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RobotAction', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'actionType', protoName: 'actionType')
    ..a<$core.double>(2, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RobotAction clone() => RobotAction()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RobotAction copyWith(void Function(RobotAction) updates) => super.copyWith((message) => updates(message as RobotAction)) as RobotAction;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RobotAction create() => RobotAction._();
  RobotAction createEmptyInstance() => create();
  static $pb.PbList<RobotAction> createRepeated() => $pb.PbList<RobotAction>();
  @$core.pragma('dart2js:noInline')
  static RobotAction getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RobotAction>(create);
  static RobotAction? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get actionType => $_getSZ(0);
  @$pb.TagNumber(1)
  set actionType($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasActionType() => $_has(0);
  @$pb.TagNumber(1)
  void clearActionType() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get time => $_getN(1);
  @$pb.TagNumber(2)
  set time($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearTime() => clearField(2);
}

class Vector extends $pb.GeneratedMessage {
  factory Vector({
    $core.double? x,
    $core.double? y,
  }) {
    final $result = create();
    if (x != null) {
      $result.x = x;
    }
    if (y != null) {
      $result.y = y;
    }
    return $result;
  }
  Vector._() : super();
  factory Vector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Vector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Vector', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'y', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Vector clone() => Vector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Vector copyWith(void Function(Vector) updates) => super.copyWith((message) => updates(message as Vector)) as Vector;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Vector create() => Vector._();
  Vector createEmptyInstance() => create();
  static $pb.PbList<Vector> createRepeated() => $pb.PbList<Vector>();
  @$core.pragma('dart2js:noInline')
  static Vector getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Vector>(create);
  static Vector? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get x => $_getN(0);
  @$pb.TagNumber(1)
  set x($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasX() => $_has(0);
  @$pb.TagNumber(1)
  void clearX() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get y => $_getN(1);
  @$pb.TagNumber(2)
  set y($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasY() => $_has(1);
  @$pb.TagNumber(2)
  void clearY() => clearField(2);
}

class Point extends $pb.GeneratedMessage {
  factory Point({
    Vector? position,
    Vector? controlIn,
    Vector? controlOut,
    $core.bool? useHeading,
    $core.double? heading,
    RobotAction? action,
  }) {
    final $result = create();
    if (position != null) {
      $result.position = position;
    }
    if (controlIn != null) {
      $result.controlIn = controlIn;
    }
    if (controlOut != null) {
      $result.controlOut = controlOut;
    }
    if (useHeading != null) {
      $result.useHeading = useHeading;
    }
    if (heading != null) {
      $result.heading = heading;
    }
    if (action != null) {
      $result.action = action;
    }
    return $result;
  }
  Point._() : super();
  factory Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point', createEmptyInstance: create)
    ..aOM<Vector>(1, _omitFieldNames ? '' : 'position', subBuilder: Vector.create)
    ..aOM<Vector>(2, _omitFieldNames ? '' : 'controlIn', protoName: 'controlIn', subBuilder: Vector.create)
    ..aOM<Vector>(3, _omitFieldNames ? '' : 'controlOut', protoName: 'controlOut', subBuilder: Vector.create)
    ..aOB(4, _omitFieldNames ? '' : 'useHeading', protoName: 'useHeading')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OF)
    ..aOM<RobotAction>(6, _omitFieldNames ? '' : 'action', subBuilder: RobotAction.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point copyWith(void Function(Point) updates) => super.copyWith((message) => updates(message as Point)) as Point;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  Point createEmptyInstance() => create();
  static $pb.PbList<Point> createRepeated() => $pb.PbList<Point>();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  Vector get position => $_getN(0);
  @$pb.TagNumber(1)
  set position(Vector v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPosition() => $_has(0);
  @$pb.TagNumber(1)
  void clearPosition() => clearField(1);
  @$pb.TagNumber(1)
  Vector ensurePosition() => $_ensure(0);

  @$pb.TagNumber(2)
  Vector get controlIn => $_getN(1);
  @$pb.TagNumber(2)
  set controlIn(Vector v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasControlIn() => $_has(1);
  @$pb.TagNumber(2)
  void clearControlIn() => clearField(2);
  @$pb.TagNumber(2)
  Vector ensureControlIn() => $_ensure(1);

  @$pb.TagNumber(3)
  Vector get controlOut => $_getN(2);
  @$pb.TagNumber(3)
  set controlOut(Vector v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasControlOut() => $_has(2);
  @$pb.TagNumber(3)
  void clearControlOut() => clearField(3);
  @$pb.TagNumber(3)
  Vector ensureControlOut() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get useHeading => $_getBF(3);
  @$pb.TagNumber(4)
  set useHeading($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasUseHeading() => $_has(3);
  @$pb.TagNumber(4)
  void clearUseHeading() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get heading => $_getN(4);
  @$pb.TagNumber(5)
  set heading($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHeading() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeading() => clearField(5);

  @$pb.TagNumber(6)
  RobotAction get action => $_getN(5);
  @$pb.TagNumber(6)
  set action(RobotAction v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => clearField(6);
  @$pb.TagNumber(6)
  RobotAction ensureAction() => $_ensure(5);
}

class Segment extends $pb.GeneratedMessage {
  factory Segment({
    $core.Iterable<Point>? points,
    $core.double? maxVelocity,
    SplineTypes? splineType,
    SplineParameters? splineParameters,
  }) {
    final $result = create();
    if (points != null) {
      $result.points.addAll(points);
    }
    if (maxVelocity != null) {
      $result.maxVelocity = maxVelocity;
    }
    if (splineType != null) {
      $result.splineType = splineType;
    }
    if (splineParameters != null) {
      $result.splineParameters = splineParameters;
    }
    return $result;
  }
  Segment._() : super();
  factory Segment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Segment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Segment', createEmptyInstance: create)
    ..pc<Point>(1, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..e<SplineTypes>(3, _omitFieldNames ? '' : 'splineType', $pb.PbFieldType.OE, protoName: 'splineType', defaultOrMaker: SplineTypes.None, valueOf: SplineTypes.valueOf, enumValues: SplineTypes.values)
    ..aOM<SplineParameters>(4, _omitFieldNames ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Segment clone() => Segment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Segment copyWith(void Function(Segment) updates) => super.copyWith((message) => updates(message as Segment)) as Segment;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Segment create() => Segment._();
  Segment createEmptyInstance() => create();
  static $pb.PbList<Segment> createRepeated() => $pb.PbList<Segment>();
  @$core.pragma('dart2js:noInline')
  static Segment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Segment>(create);
  static Segment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Point> get points => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get maxVelocity => $_getN(1);
  @$pb.TagNumber(2)
  set maxVelocity($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxVelocity() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxVelocity() => clearField(2);

  @$pb.TagNumber(3)
  SplineTypes get splineType => $_getN(2);
  @$pb.TagNumber(3)
  set splineType(SplineTypes v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSplineType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSplineType() => clearField(3);

  @$pb.TagNumber(4)
  SplineParameters get splineParameters => $_getN(3);
  @$pb.TagNumber(4)
  set splineParameters(SplineParameters v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSplineParameters() => $_has(3);
  @$pb.TagNumber(4)
  void clearSplineParameters() => clearField(4);
  @$pb.TagNumber(4)
  SplineParameters ensureSplineParameters() => $_ensure(3);
}

class Section extends $pb.GeneratedMessage {
  factory Section({
    $core.Iterable<Segment>? segments,
  }) {
    final $result = create();
    if (segments != null) {
      $result.segments.addAll(segments);
    }
    return $result;
  }
  Section._() : super();
  factory Section.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Section.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Section', createEmptyInstance: create)
    ..pc<Segment>(1, _omitFieldNames ? '' : 'segments', $pb.PbFieldType.PM, subBuilder: Segment.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Section clone() => Section()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Section copyWith(void Function(Section) updates) => super.copyWith((message) => updates(message as Section)) as Section;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Section create() => Section._();
  Section createEmptyInstance() => create();
  static $pb.PbList<Section> createRepeated() => $pb.PbList<Section>();
  @$core.pragma('dart2js:noInline')
  static Section getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Section>(create);
  static Section? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Segment> get segments => $_getList(0);
}

class SplineParameters extends $pb.GeneratedMessage {
  factory SplineParameters({
    $core.Iterable<$core.double>? params,
  }) {
    final $result = create();
    if (params != null) {
      $result.params.addAll(params);
    }
    return $result;
  }
  SplineParameters._() : super();
  factory SplineParameters.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineParameters.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineParameters', createEmptyInstance: create)
    ..p<$core.double>(1, _omitFieldNames ? '' : 'params', $pb.PbFieldType.KF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineParameters clone() => SplineParameters()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineParameters copyWith(void Function(SplineParameters) updates) => super.copyWith((message) => updates(message as SplineParameters)) as SplineParameters;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineParameters create() => SplineParameters._();
  SplineParameters createEmptyInstance() => create();
  static $pb.PbList<SplineParameters> createRepeated() => $pb.PbList<SplineParameters>();
  @$core.pragma('dart2js:noInline')
  static SplineParameters getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineParameters>(create);
  static SplineParameters? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.double> get params => $_getList(0);
}

class SplineRequest_OptimizationParams_Hermite extends $pb.GeneratedMessage {
  factory SplineRequest_OptimizationParams_Hermite() => create();
  SplineRequest_OptimizationParams_Hermite._() : super();
  factory SplineRequest_OptimizationParams_Hermite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Hermite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest.OptimizationParams.Hermite', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Hermite clone() => SplineRequest_OptimizationParams_Hermite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Hermite copyWith(void Function(SplineRequest_OptimizationParams_Hermite) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Hermite)) as SplineRequest_OptimizationParams_Hermite;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Hermite create() => SplineRequest_OptimizationParams_Hermite._();
  SplineRequest_OptimizationParams_Hermite createEmptyInstance() => create();
  static $pb.PbList<SplineRequest_OptimizationParams_Hermite> createRepeated() => $pb.PbList<SplineRequest_OptimizationParams_Hermite>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Hermite getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest_OptimizationParams_Hermite>(create);
  static SplineRequest_OptimizationParams_Hermite? _defaultInstance;
}

class SplineRequest_OptimizationParams_Bezier extends $pb.GeneratedMessage {
  factory SplineRequest_OptimizationParams_Bezier() => create();
  SplineRequest_OptimizationParams_Bezier._() : super();
  factory SplineRequest_OptimizationParams_Bezier.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Bezier.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest.OptimizationParams.Bezier', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Bezier clone() => SplineRequest_OptimizationParams_Bezier()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Bezier copyWith(void Function(SplineRequest_OptimizationParams_Bezier) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Bezier)) as SplineRequest_OptimizationParams_Bezier;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Bezier create() => SplineRequest_OptimizationParams_Bezier._();
  SplineRequest_OptimizationParams_Bezier createEmptyInstance() => create();
  static $pb.PbList<SplineRequest_OptimizationParams_Bezier> createRepeated() => $pb.PbList<SplineRequest_OptimizationParams_Bezier>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Bezier getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest_OptimizationParams_Bezier>(create);
  static SplineRequest_OptimizationParams_Bezier? _defaultInstance;
}

class SplineRequest_OptimizationParams_Polynomial extends $pb.GeneratedMessage {
  factory SplineRequest_OptimizationParams_Polynomial() => create();
  SplineRequest_OptimizationParams_Polynomial._() : super();
  factory SplineRequest_OptimizationParams_Polynomial.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Polynomial.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest.OptimizationParams.Polynomial', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Polynomial clone() => SplineRequest_OptimizationParams_Polynomial()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Polynomial copyWith(void Function(SplineRequest_OptimizationParams_Polynomial) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Polynomial)) as SplineRequest_OptimizationParams_Polynomial;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Polynomial create() => SplineRequest_OptimizationParams_Polynomial._();
  SplineRequest_OptimizationParams_Polynomial createEmptyInstance() => create();
  static $pb.PbList<SplineRequest_OptimizationParams_Polynomial> createRepeated() => $pb.PbList<SplineRequest_OptimizationParams_Polynomial>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams_Polynomial getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest_OptimizationParams_Polynomial>(create);
  static SplineRequest_OptimizationParams_Polynomial? _defaultInstance;
}

class SplineRequest_OptimizationParams extends $pb.GeneratedMessage {
  factory SplineRequest_OptimizationParams({
    SplineRequest_OptimizationParams_Hermite? hermite,
    SplineRequest_OptimizationParams_Bezier? bezier,
    SplineRequest_OptimizationParams_Polynomial? polynomial,
  }) {
    final $result = create();
    if (hermite != null) {
      $result.hermite = hermite;
    }
    if (bezier != null) {
      $result.bezier = bezier;
    }
    if (polynomial != null) {
      $result.polynomial = polynomial;
    }
    return $result;
  }
  SplineRequest_OptimizationParams._() : super();
  factory SplineRequest_OptimizationParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest.OptimizationParams', createEmptyInstance: create)
    ..aOM<SplineRequest_OptimizationParams_Hermite>(5, _omitFieldNames ? '' : 'hermite', subBuilder: SplineRequest_OptimizationParams_Hermite.create)
    ..aOM<SplineRequest_OptimizationParams_Bezier>(6, _omitFieldNames ? '' : 'bezier', subBuilder: SplineRequest_OptimizationParams_Bezier.create)
    ..aOM<SplineRequest_OptimizationParams_Polynomial>(7, _omitFieldNames ? '' : 'polynomial', subBuilder: SplineRequest_OptimizationParams_Polynomial.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams clone() => SplineRequest_OptimizationParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams copyWith(void Function(SplineRequest_OptimizationParams) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams)) as SplineRequest_OptimizationParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams create() => SplineRequest_OptimizationParams._();
  SplineRequest_OptimizationParams createEmptyInstance() => create();
  static $pb.PbList<SplineRequest_OptimizationParams> createRepeated() => $pb.PbList<SplineRequest_OptimizationParams>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest_OptimizationParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest_OptimizationParams>(create);
  static SplineRequest_OptimizationParams? _defaultInstance;

  @$pb.TagNumber(5)
  SplineRequest_OptimizationParams_Hermite get hermite => $_getN(0);
  @$pb.TagNumber(5)
  set hermite(SplineRequest_OptimizationParams_Hermite v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasHermite() => $_has(0);
  @$pb.TagNumber(5)
  void clearHermite() => clearField(5);
  @$pb.TagNumber(5)
  SplineRequest_OptimizationParams_Hermite ensureHermite() => $_ensure(0);

  @$pb.TagNumber(6)
  SplineRequest_OptimizationParams_Bezier get bezier => $_getN(1);
  @$pb.TagNumber(6)
  set bezier(SplineRequest_OptimizationParams_Bezier v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasBezier() => $_has(1);
  @$pb.TagNumber(6)
  void clearBezier() => clearField(6);
  @$pb.TagNumber(6)
  SplineRequest_OptimizationParams_Bezier ensureBezier() => $_ensure(1);

  @$pb.TagNumber(7)
  SplineRequest_OptimizationParams_Polynomial get polynomial => $_getN(2);
  @$pb.TagNumber(7)
  set polynomial(SplineRequest_OptimizationParams_Polynomial v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasPolynomial() => $_has(2);
  @$pb.TagNumber(7)
  void clearPolynomial() => clearField(7);
  @$pb.TagNumber(7)
  SplineRequest_OptimizationParams_Polynomial ensurePolynomial() => $_ensure(2);
}

class SplineRequest extends $pb.GeneratedMessage {
  factory SplineRequest({
    $core.Iterable<Segment>? segments,
    SplineParameters? splineParameters,
    $core.double? evaluatedPointsInterval,
    SplineRequest_OptimizationParams? optimizationParams,
  }) {
    final $result = create();
    if (segments != null) {
      $result.segments.addAll(segments);
    }
    if (splineParameters != null) {
      $result.splineParameters = splineParameters;
    }
    if (evaluatedPointsInterval != null) {
      $result.evaluatedPointsInterval = evaluatedPointsInterval;
    }
    if (optimizationParams != null) {
      $result.optimizationParams = optimizationParams;
    }
    return $result;
  }
  SplineRequest._() : super();
  factory SplineRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest', createEmptyInstance: create)
    ..pc<Segment>(1, _omitFieldNames ? '' : 'segments', $pb.PbFieldType.PM, subBuilder: Segment.create)
    ..aOM<SplineParameters>(2, _omitFieldNames ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'evaluatedPointsInterval', $pb.PbFieldType.OF, protoName: 'evaluatedPointsInterval')
    ..aOM<SplineRequest_OptimizationParams>(4, _omitFieldNames ? '' : 'optimizationParams', protoName: 'optimizationParams', subBuilder: SplineRequest_OptimizationParams.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest clone() => SplineRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest copyWith(void Function(SplineRequest) updates) => super.copyWith((message) => updates(message as SplineRequest)) as SplineRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineRequest create() => SplineRequest._();
  SplineRequest createEmptyInstance() => create();
  static $pb.PbList<SplineRequest> createRepeated() => $pb.PbList<SplineRequest>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest>(create);
  static SplineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Segment> get segments => $_getList(0);

  @$pb.TagNumber(2)
  SplineParameters get splineParameters => $_getN(1);
  @$pb.TagNumber(2)
  set splineParameters(SplineParameters v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSplineParameters() => $_has(1);
  @$pb.TagNumber(2)
  void clearSplineParameters() => clearField(2);
  @$pb.TagNumber(2)
  SplineParameters ensureSplineParameters() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get evaluatedPointsInterval => $_getN(2);
  @$pb.TagNumber(3)
  set evaluatedPointsInterval($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvaluatedPointsInterval() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvaluatedPointsInterval() => clearField(3);

  @$pb.TagNumber(4)
  SplineRequest_OptimizationParams get optimizationParams => $_getN(3);
  @$pb.TagNumber(4)
  set optimizationParams(SplineRequest_OptimizationParams v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasOptimizationParams() => $_has(3);
  @$pb.TagNumber(4)
  void clearOptimizationParams() => clearField(4);
  @$pb.TagNumber(4)
  SplineRequest_OptimizationParams ensureOptimizationParams() => $_ensure(3);
}

class SplineResponse_Point extends $pb.GeneratedMessage {
  factory SplineResponse_Point({
    Vector? point,
    $core.int? segmentIndex,
  }) {
    final $result = create();
    if (point != null) {
      $result.point = point;
    }
    if (segmentIndex != null) {
      $result.segmentIndex = segmentIndex;
    }
    return $result;
  }
  SplineResponse_Point._() : super();
  factory SplineResponse_Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineResponse_Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineResponse.Point', createEmptyInstance: create)
    ..aOM<Vector>(1, _omitFieldNames ? '' : 'point', subBuilder: Vector.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'segmentIndex', $pb.PbFieldType.O3, protoName: 'segmentIndex')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineResponse_Point clone() => SplineResponse_Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineResponse_Point copyWith(void Function(SplineResponse_Point) updates) => super.copyWith((message) => updates(message as SplineResponse_Point)) as SplineResponse_Point;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineResponse_Point create() => SplineResponse_Point._();
  SplineResponse_Point createEmptyInstance() => create();
  static $pb.PbList<SplineResponse_Point> createRepeated() => $pb.PbList<SplineResponse_Point>();
  @$core.pragma('dart2js:noInline')
  static SplineResponse_Point getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineResponse_Point>(create);
  static SplineResponse_Point? _defaultInstance;

  @$pb.TagNumber(1)
  Vector get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Vector v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => clearField(1);
  @$pb.TagNumber(1)
  Vector ensurePoint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.int get segmentIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set segmentIndex($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSegmentIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearSegmentIndex() => clearField(2);
}

class SplineResponse extends $pb.GeneratedMessage {
  factory SplineResponse({
    SplineParameters? splineParameters,
    SplineTypes? splineType,
    $core.Iterable<SplineResponse_Point>? evaluatedPoints,
  }) {
    final $result = create();
    if (splineParameters != null) {
      $result.splineParameters = splineParameters;
    }
    if (splineType != null) {
      $result.splineType = splineType;
    }
    if (evaluatedPoints != null) {
      $result.evaluatedPoints.addAll(evaluatedPoints);
    }
    return $result;
  }
  SplineResponse._() : super();
  factory SplineResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineResponse', createEmptyInstance: create)
    ..aOM<SplineParameters>(1, _omitFieldNames ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..e<SplineTypes>(2, _omitFieldNames ? '' : 'splineType', $pb.PbFieldType.OE, protoName: 'splineType', defaultOrMaker: SplineTypes.None, valueOf: SplineTypes.valueOf, enumValues: SplineTypes.values)
    ..pc<SplineResponse_Point>(3, _omitFieldNames ? '' : 'evaluatedPoints', $pb.PbFieldType.PM, protoName: 'evaluatedPoints', subBuilder: SplineResponse_Point.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineResponse clone() => SplineResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineResponse copyWith(void Function(SplineResponse) updates) => super.copyWith((message) => updates(message as SplineResponse)) as SplineResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplineResponse create() => SplineResponse._();
  SplineResponse createEmptyInstance() => create();
  static $pb.PbList<SplineResponse> createRepeated() => $pb.PbList<SplineResponse>();
  @$core.pragma('dart2js:noInline')
  static SplineResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineResponse>(create);
  static SplineResponse? _defaultInstance;

  @$pb.TagNumber(1)
  SplineParameters get splineParameters => $_getN(0);
  @$pb.TagNumber(1)
  set splineParameters(SplineParameters v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSplineParameters() => $_has(0);
  @$pb.TagNumber(1)
  void clearSplineParameters() => clearField(1);
  @$pb.TagNumber(1)
  SplineParameters ensureSplineParameters() => $_ensure(0);

  @$pb.TagNumber(2)
  SplineTypes get splineType => $_getN(1);
  @$pb.TagNumber(2)
  set splineType(SplineTypes v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSplineType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSplineType() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<SplineResponse_Point> get evaluatedPoints => $_getList(2);
}

class TrajectoryRequest_SwerveRobotParams extends $pb.GeneratedMessage {
  factory TrajectoryRequest_SwerveRobotParams({
    $core.double? width,
    $core.double? height,
    $core.double? maxVelocity,
    $core.double? maxAcceleration,
    $core.double? skidAcceleration,
    $core.double? maxJerk,
    $core.double? cycleTime,
    $core.double? angularAccelerationPercentage,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (maxVelocity != null) {
      $result.maxVelocity = maxVelocity;
    }
    if (maxAcceleration != null) {
      $result.maxAcceleration = maxAcceleration;
    }
    if (skidAcceleration != null) {
      $result.skidAcceleration = skidAcceleration;
    }
    if (maxJerk != null) {
      $result.maxJerk = maxJerk;
    }
    if (cycleTime != null) {
      $result.cycleTime = cycleTime;
    }
    if (angularAccelerationPercentage != null) {
      $result.angularAccelerationPercentage = angularAccelerationPercentage;
    }
    return $result;
  }
  TrajectoryRequest_SwerveRobotParams._() : super();
  factory TrajectoryRequest_SwerveRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_SwerveRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryRequest.SwerveRobotParams', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxAcceleration', $pb.PbFieldType.OF, protoName: 'maxAcceleration')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'skidAcceleration', $pb.PbFieldType.OF, protoName: 'skidAcceleration')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'maxJerk', $pb.PbFieldType.OF, protoName: 'maxJerk')
    ..a<$core.double>(7, _omitFieldNames ? '' : 'cycleTime', $pb.PbFieldType.OF, protoName: 'cycleTime')
    ..a<$core.double>(8, _omitFieldNames ? '' : 'angularAccelerationPercentage', $pb.PbFieldType.OF, protoName: 'angularAccelerationPercentage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_SwerveRobotParams clone() => TrajectoryRequest_SwerveRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_SwerveRobotParams copyWith(void Function(TrajectoryRequest_SwerveRobotParams) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_SwerveRobotParams)) as TrajectoryRequest_SwerveRobotParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_SwerveRobotParams create() => TrajectoryRequest_SwerveRobotParams._();
  TrajectoryRequest_SwerveRobotParams createEmptyInstance() => create();
  static $pb.PbList<TrajectoryRequest_SwerveRobotParams> createRepeated() => $pb.PbList<TrajectoryRequest_SwerveRobotParams>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_SwerveRobotParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryRequest_SwerveRobotParams>(create);
  static TrajectoryRequest_SwerveRobotParams? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get maxVelocity => $_getN(2);
  @$pb.TagNumber(3)
  set maxVelocity($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxVelocity() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxAcceleration => $_getN(3);
  @$pb.TagNumber(4)
  set maxAcceleration($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxAcceleration() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAcceleration() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get skidAcceleration => $_getN(4);
  @$pb.TagNumber(5)
  set skidAcceleration($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSkidAcceleration() => $_has(4);
  @$pb.TagNumber(5)
  void clearSkidAcceleration() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxJerk => $_getN(5);
  @$pb.TagNumber(6)
  set maxJerk($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxJerk() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxJerk() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get cycleTime => $_getN(6);
  @$pb.TagNumber(7)
  set cycleTime($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCycleTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCycleTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get angularAccelerationPercentage => $_getN(7);
  @$pb.TagNumber(8)
  set angularAccelerationPercentage($core.double v) { $_setFloat(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasAngularAccelerationPercentage() => $_has(7);
  @$pb.TagNumber(8)
  void clearAngularAccelerationPercentage() => clearField(8);
}

class TrajectoryRequest_TankRobotParams extends $pb.GeneratedMessage {
  factory TrajectoryRequest_TankRobotParams({
    $core.double? width,
    $core.double? height,
    $core.double? maxVelocity,
    $core.double? maxAcceleration,
    $core.double? maxJerk,
    $core.double? cycleTime,
  }) {
    final $result = create();
    if (width != null) {
      $result.width = width;
    }
    if (height != null) {
      $result.height = height;
    }
    if (maxVelocity != null) {
      $result.maxVelocity = maxVelocity;
    }
    if (maxAcceleration != null) {
      $result.maxAcceleration = maxAcceleration;
    }
    if (maxJerk != null) {
      $result.maxJerk = maxJerk;
    }
    if (cycleTime != null) {
      $result.cycleTime = cycleTime;
    }
    return $result;
  }
  TrajectoryRequest_TankRobotParams._() : super();
  factory TrajectoryRequest_TankRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_TankRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryRequest.TankRobotParams', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'width', $pb.PbFieldType.OF)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'height', $pb.PbFieldType.OF)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'maxAcceleration', $pb.PbFieldType.OF, protoName: 'maxAcceleration')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'maxJerk', $pb.PbFieldType.OF, protoName: 'maxJerk')
    ..a<$core.double>(6, _omitFieldNames ? '' : 'cycleTime', $pb.PbFieldType.OF, protoName: 'cycleTime')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_TankRobotParams clone() => TrajectoryRequest_TankRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_TankRobotParams copyWith(void Function(TrajectoryRequest_TankRobotParams) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_TankRobotParams)) as TrajectoryRequest_TankRobotParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_TankRobotParams create() => TrajectoryRequest_TankRobotParams._();
  TrajectoryRequest_TankRobotParams createEmptyInstance() => create();
  static $pb.PbList<TrajectoryRequest_TankRobotParams> createRepeated() => $pb.PbList<TrajectoryRequest_TankRobotParams>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_TankRobotParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryRequest_TankRobotParams>(create);
  static TrajectoryRequest_TankRobotParams? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get width => $_getN(0);
  @$pb.TagNumber(1)
  set width($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasWidth() => $_has(0);
  @$pb.TagNumber(1)
  void clearWidth() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get height => $_getN(1);
  @$pb.TagNumber(2)
  set height($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasHeight() => $_has(1);
  @$pb.TagNumber(2)
  void clearHeight() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get maxVelocity => $_getN(2);
  @$pb.TagNumber(3)
  set maxVelocity($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMaxVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearMaxVelocity() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get maxAcceleration => $_getN(3);
  @$pb.TagNumber(4)
  set maxAcceleration($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasMaxAcceleration() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaxAcceleration() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get maxJerk => $_getN(4);
  @$pb.TagNumber(5)
  set maxJerk($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxJerk() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxJerk() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get cycleTime => $_getN(5);
  @$pb.TagNumber(6)
  set cycleTime($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasCycleTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearCycleTime() => clearField(6);
}

class TrajectoryRequest extends $pb.GeneratedMessage {
  factory TrajectoryRequest({
    $core.Iterable<Section>? sections,
    TrajectoryRequest_DriveTrain? driveTrain,
    TrajectoryRequest_SwerveRobotParams? swerveRobotParams,
    TrajectoryRequest_TankRobotParams? tankRobotParams,
    $core.String? trajectoryFileName,
  }) {
    final $result = create();
    if (sections != null) {
      $result.sections.addAll(sections);
    }
    if (driveTrain != null) {
      $result.driveTrain = driveTrain;
    }
    if (swerveRobotParams != null) {
      $result.swerveRobotParams = swerveRobotParams;
    }
    if (tankRobotParams != null) {
      $result.tankRobotParams = tankRobotParams;
    }
    if (trajectoryFileName != null) {
      $result.trajectoryFileName = trajectoryFileName;
    }
    return $result;
  }
  TrajectoryRequest._() : super();
  factory TrajectoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryRequest', createEmptyInstance: create)
    ..pc<Section>(1, _omitFieldNames ? '' : 'sections', $pb.PbFieldType.PM, subBuilder: Section.create)
    ..e<TrajectoryRequest_DriveTrain>(4, _omitFieldNames ? '' : 'driveTrain', $pb.PbFieldType.OE, protoName: 'driveTrain', defaultOrMaker: TrajectoryRequest_DriveTrain.Swerve, valueOf: TrajectoryRequest_DriveTrain.valueOf, enumValues: TrajectoryRequest_DriveTrain.values)
    ..aOM<TrajectoryRequest_SwerveRobotParams>(5, _omitFieldNames ? '' : 'swerveRobotParams', protoName: 'swerveRobotParams', subBuilder: TrajectoryRequest_SwerveRobotParams.create)
    ..aOM<TrajectoryRequest_TankRobotParams>(6, _omitFieldNames ? '' : 'tankRobotParams', protoName: 'tankRobotParams', subBuilder: TrajectoryRequest_TankRobotParams.create)
    ..aOS(7, _omitFieldNames ? '' : 'trajectoryFileName', protoName: 'trajectoryFileName')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest clone() => TrajectoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest copyWith(void Function(TrajectoryRequest) updates) => super.copyWith((message) => updates(message as TrajectoryRequest)) as TrajectoryRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest create() => TrajectoryRequest._();
  TrajectoryRequest createEmptyInstance() => create();
  static $pb.PbList<TrajectoryRequest> createRepeated() => $pb.PbList<TrajectoryRequest>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryRequest>(create);
  static TrajectoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Section> get sections => $_getList(0);

  @$pb.TagNumber(4)
  TrajectoryRequest_DriveTrain get driveTrain => $_getN(1);
  @$pb.TagNumber(4)
  set driveTrain(TrajectoryRequest_DriveTrain v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasDriveTrain() => $_has(1);
  @$pb.TagNumber(4)
  void clearDriveTrain() => clearField(4);

  @$pb.TagNumber(5)
  TrajectoryRequest_SwerveRobotParams get swerveRobotParams => $_getN(2);
  @$pb.TagNumber(5)
  set swerveRobotParams(TrajectoryRequest_SwerveRobotParams v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasSwerveRobotParams() => $_has(2);
  @$pb.TagNumber(5)
  void clearSwerveRobotParams() => clearField(5);
  @$pb.TagNumber(5)
  TrajectoryRequest_SwerveRobotParams ensureSwerveRobotParams() => $_ensure(2);

  @$pb.TagNumber(6)
  TrajectoryRequest_TankRobotParams get tankRobotParams => $_getN(3);
  @$pb.TagNumber(6)
  set tankRobotParams(TrajectoryRequest_TankRobotParams v) { setField(6, v); }
  @$pb.TagNumber(6)
  $core.bool hasTankRobotParams() => $_has(3);
  @$pb.TagNumber(6)
  void clearTankRobotParams() => clearField(6);
  @$pb.TagNumber(6)
  TrajectoryRequest_TankRobotParams ensureTankRobotParams() => $_ensure(3);

  @$pb.TagNumber(7)
  $core.String get trajectoryFileName => $_getSZ(4);
  @$pb.TagNumber(7)
  set trajectoryFileName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(7)
  $core.bool hasTrajectoryFileName() => $_has(4);
  @$pb.TagNumber(7)
  void clearTrajectoryFileName() => clearField(7);
}

class TrajectoryResponse_SwervePoint extends $pb.GeneratedMessage {
  factory TrajectoryResponse_SwervePoint({
    $core.double? time,
    Vector? position,
    Vector? velocity,
    $core.double? heading,
    $core.double? angularVelocity,
    $core.String? action,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (position != null) {
      $result.position = position;
    }
    if (velocity != null) {
      $result.velocity = velocity;
    }
    if (heading != null) {
      $result.heading = heading;
    }
    if (angularVelocity != null) {
      $result.angularVelocity = angularVelocity;
    }
    if (action != null) {
      $result.action = action;
    }
    return $result;
  }
  TrajectoryResponse_SwervePoint._() : super();
  factory TrajectoryResponse_SwervePoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse_SwervePoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryResponse.SwervePoint', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OF)
    ..aOM<Vector>(2, _omitFieldNames ? '' : 'position', subBuilder: Vector.create)
    ..aOM<Vector>(3, _omitFieldNames ? '' : 'velocity', subBuilder: Vector.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OF)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'angularVelocity', $pb.PbFieldType.OF, protoName: 'angularVelocity')
    ..aOS(6, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_SwervePoint clone() => TrajectoryResponse_SwervePoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_SwervePoint copyWith(void Function(TrajectoryResponse_SwervePoint) updates) => super.copyWith((message) => updates(message as TrajectoryResponse_SwervePoint)) as TrajectoryResponse_SwervePoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse_SwervePoint create() => TrajectoryResponse_SwervePoint._();
  TrajectoryResponse_SwervePoint createEmptyInstance() => create();
  static $pb.PbList<TrajectoryResponse_SwervePoint> createRepeated() => $pb.PbList<TrajectoryResponse_SwervePoint>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse_SwervePoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryResponse_SwervePoint>(create);
  static TrajectoryResponse_SwervePoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  Vector get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(Vector v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => clearField(2);
  @$pb.TagNumber(2)
  Vector ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  Vector get velocity => $_getN(2);
  @$pb.TagNumber(3)
  set velocity(Vector v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearVelocity() => clearField(3);
  @$pb.TagNumber(3)
  Vector ensureVelocity() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.double get heading => $_getN(3);
  @$pb.TagNumber(4)
  set heading($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasHeading() => $_has(3);
  @$pb.TagNumber(4)
  void clearHeading() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get angularVelocity => $_getN(4);
  @$pb.TagNumber(5)
  set angularVelocity($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasAngularVelocity() => $_has(4);
  @$pb.TagNumber(5)
  void clearAngularVelocity() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get action => $_getSZ(5);
  @$pb.TagNumber(6)
  set action($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => clearField(6);
}

class TrajectoryResponse_TankPoint extends $pb.GeneratedMessage {
  factory TrajectoryResponse_TankPoint({
    $core.double? time,
    Vector? position,
    $core.double? rightVelocity,
    $core.double? leftVelocity,
    $core.double? heading,
    $core.String? action,
  }) {
    final $result = create();
    if (time != null) {
      $result.time = time;
    }
    if (position != null) {
      $result.position = position;
    }
    if (rightVelocity != null) {
      $result.rightVelocity = rightVelocity;
    }
    if (leftVelocity != null) {
      $result.leftVelocity = leftVelocity;
    }
    if (heading != null) {
      $result.heading = heading;
    }
    if (action != null) {
      $result.action = action;
    }
    return $result;
  }
  TrajectoryResponse_TankPoint._() : super();
  factory TrajectoryResponse_TankPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse_TankPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryResponse.TankPoint', createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'time', $pb.PbFieldType.OF)
    ..aOM<Vector>(2, _omitFieldNames ? '' : 'position', subBuilder: Vector.create)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'rightVelocity', $pb.PbFieldType.OF, protoName: 'rightVelocity')
    ..a<$core.double>(4, _omitFieldNames ? '' : 'leftVelocity', $pb.PbFieldType.OF, protoName: 'leftVelocity')
    ..a<$core.double>(5, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OF)
    ..aOS(6, _omitFieldNames ? '' : 'action')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_TankPoint clone() => TrajectoryResponse_TankPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_TankPoint copyWith(void Function(TrajectoryResponse_TankPoint) updates) => super.copyWith((message) => updates(message as TrajectoryResponse_TankPoint)) as TrajectoryResponse_TankPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse_TankPoint create() => TrajectoryResponse_TankPoint._();
  TrajectoryResponse_TankPoint createEmptyInstance() => create();
  static $pb.PbList<TrajectoryResponse_TankPoint> createRepeated() => $pb.PbList<TrajectoryResponse_TankPoint>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse_TankPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryResponse_TankPoint>(create);
  static TrajectoryResponse_TankPoint? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get time => $_getN(0);
  @$pb.TagNumber(1)
  set time($core.double v) { $_setFloat(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearTime() => clearField(1);

  @$pb.TagNumber(2)
  Vector get position => $_getN(1);
  @$pb.TagNumber(2)
  set position(Vector v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPosition() => $_has(1);
  @$pb.TagNumber(2)
  void clearPosition() => clearField(2);
  @$pb.TagNumber(2)
  Vector ensurePosition() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.double get rightVelocity => $_getN(2);
  @$pb.TagNumber(3)
  set rightVelocity($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRightVelocity() => $_has(2);
  @$pb.TagNumber(3)
  void clearRightVelocity() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get leftVelocity => $_getN(3);
  @$pb.TagNumber(4)
  set leftVelocity($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasLeftVelocity() => $_has(3);
  @$pb.TagNumber(4)
  void clearLeftVelocity() => clearField(4);

  @$pb.TagNumber(5)
  $core.double get heading => $_getN(4);
  @$pb.TagNumber(5)
  set heading($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasHeading() => $_has(4);
  @$pb.TagNumber(5)
  void clearHeading() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get action => $_getSZ(5);
  @$pb.TagNumber(6)
  set action($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasAction() => $_has(5);
  @$pb.TagNumber(6)
  void clearAction() => clearField(6);
}

class TrajectoryResponse extends $pb.GeneratedMessage {
  factory TrajectoryResponse({
    $core.Iterable<TrajectoryResponse_SwervePoint>? swervePoints,
    $core.Iterable<TrajectoryResponse_TankPoint>? tankPoints,
  }) {
    final $result = create();
    if (swervePoints != null) {
      $result.swervePoints.addAll(swervePoints);
    }
    if (tankPoints != null) {
      $result.tankPoints.addAll(tankPoints);
    }
    return $result;
  }
  TrajectoryResponse._() : super();
  factory TrajectoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryResponse', createEmptyInstance: create)
    ..pc<TrajectoryResponse_SwervePoint>(1, _omitFieldNames ? '' : 'swervePoints', $pb.PbFieldType.PM, protoName: 'swervePoints', subBuilder: TrajectoryResponse_SwervePoint.create)
    ..pc<TrajectoryResponse_TankPoint>(2, _omitFieldNames ? '' : 'tankPoints', $pb.PbFieldType.PM, protoName: 'tankPoints', subBuilder: TrajectoryResponse_TankPoint.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse clone() => TrajectoryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse copyWith(void Function(TrajectoryResponse) updates) => super.copyWith((message) => updates(message as TrajectoryResponse)) as TrajectoryResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse create() => TrajectoryResponse._();
  TrajectoryResponse createEmptyInstance() => create();
  static $pb.PbList<TrajectoryResponse> createRepeated() => $pb.PbList<TrajectoryResponse>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryResponse>(create);
  static TrajectoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TrajectoryResponse_SwervePoint> get swervePoints => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<TrajectoryResponse_TankPoint> get tankPoints => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
