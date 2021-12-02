///
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'PathFinder.pbenum.dart';

export 'PathFinder.pbenum.dart';

class Vector extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Vector', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'x', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'y', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Vector._() : super();
  factory Vector({
    $core.double? x,
    $core.double? y,
  }) {
    final _result = create();
    if (x != null) {
      _result.x = x;
    }
    if (y != null) {
      _result.y = y;
    }
    return _result;
  }
  factory Vector.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Vector.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Vector clone() => Vector()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Vector copyWith(void Function(Vector) updates) => super.copyWith((message) => updates(message as Vector)) as Vector; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Point', createEmptyInstance: create)
    ..aOM<Vector>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: Vector.create)
    ..aOM<Vector>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'controlIn', protoName: 'controlIn', subBuilder: Vector.create)
    ..aOM<Vector>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'controlOut', protoName: 'controlOut', subBuilder: Vector.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'useHeading', protoName: 'useHeading')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heading', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Point._() : super();
  factory Point({
    Vector? position,
    Vector? controlIn,
    Vector? controlOut,
    $core.bool? useHeading,
    $core.double? heading,
  }) {
    final _result = create();
    if (position != null) {
      _result.position = position;
    }
    if (controlIn != null) {
      _result.controlIn = controlIn;
    }
    if (controlOut != null) {
      _result.controlOut = controlOut;
    }
    if (useHeading != null) {
      _result.useHeading = useHeading;
    }
    if (heading != null) {
      _result.heading = heading;
    }
    return _result;
  }
  factory Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point copyWith(void Function(Point) updates) => super.copyWith((message) => updates(message as Point)) as Point; // ignore: deprecated_member_use
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
}

class Segment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Segment', createEmptyInstance: create)
    ..pc<Point>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point.create)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..e<SplineTypes>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineType', $pb.PbFieldType.OE, protoName: 'splineType', defaultOrMaker: SplineTypes.None, valueOf: SplineTypes.valueOf, enumValues: SplineTypes.values)
    ..aOM<SplineParameters>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..hasRequiredFields = false
  ;

  Segment._() : super();
  factory Segment({
    $core.Iterable<Point>? points,
    $core.double? maxVelocity,
    SplineTypes? splineType,
    SplineParameters? splineParameters,
  }) {
    final _result = create();
    if (points != null) {
      _result.points.addAll(points);
    }
    if (maxVelocity != null) {
      _result.maxVelocity = maxVelocity;
    }
    if (splineType != null) {
      _result.splineType = splineType;
    }
    if (splineParameters != null) {
      _result.splineParameters = splineParameters;
    }
    return _result;
  }
  factory Segment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Segment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Segment clone() => Segment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Segment copyWith(void Function(Segment) updates) => super.copyWith((message) => updates(message as Segment)) as Segment; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Section', createEmptyInstance: create)
    ..pc<Segment>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'segments', $pb.PbFieldType.PM, subBuilder: Segment.create)
    ..hasRequiredFields = false
  ;

  Section._() : super();
  factory Section({
    $core.Iterable<Segment>? segments,
  }) {
    final _result = create();
    if (segments != null) {
      _result.segments.addAll(segments);
    }
    return _result;
  }
  factory Section.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Section.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Section clone() => Section()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Section copyWith(void Function(Section) updates) => super.copyWith((message) => updates(message as Section)) as Section; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineParameters', createEmptyInstance: create)
    ..p<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'params', $pb.PbFieldType.PF)
    ..hasRequiredFields = false
  ;

  SplineParameters._() : super();
  factory SplineParameters({
    $core.Iterable<$core.double>? params,
  }) {
    final _result = create();
    if (params != null) {
      _result.params.addAll(params);
    }
    return _result;
  }
  factory SplineParameters.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineParameters.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineParameters clone() => SplineParameters()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineParameters copyWith(void Function(SplineParameters) updates) => super.copyWith((message) => updates(message as SplineParameters)) as SplineParameters; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineRequest.OptimizationParams.Hermite', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SplineRequest_OptimizationParams_Hermite._() : super();
  factory SplineRequest_OptimizationParams_Hermite() => create();
  factory SplineRequest_OptimizationParams_Hermite.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Hermite.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Hermite clone() => SplineRequest_OptimizationParams_Hermite()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Hermite copyWith(void Function(SplineRequest_OptimizationParams_Hermite) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Hermite)) as SplineRequest_OptimizationParams_Hermite; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineRequest.OptimizationParams.Bezier', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SplineRequest_OptimizationParams_Bezier._() : super();
  factory SplineRequest_OptimizationParams_Bezier() => create();
  factory SplineRequest_OptimizationParams_Bezier.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Bezier.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Bezier clone() => SplineRequest_OptimizationParams_Bezier()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Bezier copyWith(void Function(SplineRequest_OptimizationParams_Bezier) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Bezier)) as SplineRequest_OptimizationParams_Bezier; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineRequest.OptimizationParams.Polynomial', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  SplineRequest_OptimizationParams_Polynomial._() : super();
  factory SplineRequest_OptimizationParams_Polynomial() => create();
  factory SplineRequest_OptimizationParams_Polynomial.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams_Polynomial.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Polynomial clone() => SplineRequest_OptimizationParams_Polynomial()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams_Polynomial copyWith(void Function(SplineRequest_OptimizationParams_Polynomial) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams_Polynomial)) as SplineRequest_OptimizationParams_Polynomial; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineRequest.OptimizationParams', createEmptyInstance: create)
    ..aOM<SplineRequest_OptimizationParams_Hermite>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hermite', subBuilder: SplineRequest_OptimizationParams_Hermite.create)
    ..aOM<SplineRequest_OptimizationParams_Bezier>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'bezier', subBuilder: SplineRequest_OptimizationParams_Bezier.create)
    ..aOM<SplineRequest_OptimizationParams_Polynomial>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'polynomial', subBuilder: SplineRequest_OptimizationParams_Polynomial.create)
    ..hasRequiredFields = false
  ;

  SplineRequest_OptimizationParams._() : super();
  factory SplineRequest_OptimizationParams({
    SplineRequest_OptimizationParams_Hermite? hermite,
    SplineRequest_OptimizationParams_Bezier? bezier,
    SplineRequest_OptimizationParams_Polynomial? polynomial,
  }) {
    final _result = create();
    if (hermite != null) {
      _result.hermite = hermite;
    }
    if (bezier != null) {
      _result.bezier = bezier;
    }
    if (polynomial != null) {
      _result.polynomial = polynomial;
    }
    return _result;
  }
  factory SplineRequest_OptimizationParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest_OptimizationParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams clone() => SplineRequest_OptimizationParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest_OptimizationParams copyWith(void Function(SplineRequest_OptimizationParams) updates) => super.copyWith((message) => updates(message as SplineRequest_OptimizationParams)) as SplineRequest_OptimizationParams; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineRequest', createEmptyInstance: create)
    ..pc<Point>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'points', $pb.PbFieldType.PM, subBuilder: Point.create)
    ..e<SplineTypes>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineType', $pb.PbFieldType.OE, protoName: 'splineType', defaultOrMaker: SplineTypes.None, valueOf: SplineTypes.valueOf, enumValues: SplineTypes.values)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'evaluatedPointsInterval', $pb.PbFieldType.OF, protoName: 'evaluatedPointsInterval')
    ..aOM<SplineParameters>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..aOM<SplineRequest_OptimizationParams>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'optimizationParams', protoName: 'optimizationParams', subBuilder: SplineRequest_OptimizationParams.create)
    ..hasRequiredFields = false
  ;

  SplineRequest._() : super();
  factory SplineRequest({
    $core.Iterable<Point>? points,
    SplineTypes? splineType,
    $core.double? evaluatedPointsInterval,
    SplineParameters? splineParameters,
    SplineRequest_OptimizationParams? optimizationParams,
  }) {
    final _result = create();
    if (points != null) {
      _result.points.addAll(points);
    }
    if (splineType != null) {
      _result.splineType = splineType;
    }
    if (evaluatedPointsInterval != null) {
      _result.evaluatedPointsInterval = evaluatedPointsInterval;
    }
    if (splineParameters != null) {
      _result.splineParameters = splineParameters;
    }
    if (optimizationParams != null) {
      _result.optimizationParams = optimizationParams;
    }
    return _result;
  }
  factory SplineRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineRequest clone() => SplineRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineRequest copyWith(void Function(SplineRequest) updates) => super.copyWith((message) => updates(message as SplineRequest)) as SplineRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SplineRequest create() => SplineRequest._();
  SplineRequest createEmptyInstance() => create();
  static $pb.PbList<SplineRequest> createRepeated() => $pb.PbList<SplineRequest>();
  @$core.pragma('dart2js:noInline')
  static SplineRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplineRequest>(create);
  static SplineRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Point> get points => $_getList(0);

  @$pb.TagNumber(2)
  SplineTypes get splineType => $_getN(1);
  @$pb.TagNumber(2)
  set splineType(SplineTypes v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSplineType() => $_has(1);
  @$pb.TagNumber(2)
  void clearSplineType() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get evaluatedPointsInterval => $_getN(2);
  @$pb.TagNumber(3)
  set evaluatedPointsInterval($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasEvaluatedPointsInterval() => $_has(2);
  @$pb.TagNumber(3)
  void clearEvaluatedPointsInterval() => clearField(3);

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

  @$pb.TagNumber(5)
  SplineRequest_OptimizationParams get optimizationParams => $_getN(4);
  @$pb.TagNumber(5)
  set optimizationParams(SplineRequest_OptimizationParams v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasOptimizationParams() => $_has(4);
  @$pb.TagNumber(5)
  void clearOptimizationParams() => clearField(5);
  @$pb.TagNumber(5)
  SplineRequest_OptimizationParams ensureOptimizationParams() => $_ensure(4);
}

class SplineResponse_Point extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineResponse.Point', createEmptyInstance: create)
    ..aOM<Vector>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'point', subBuilder: Vector.create)
    ..hasRequiredFields = false
  ;

  SplineResponse_Point._() : super();
  factory SplineResponse_Point({
    Vector? point,
  }) {
    final _result = create();
    if (point != null) {
      _result.point = point;
    }
    return _result;
  }
  factory SplineResponse_Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineResponse_Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineResponse_Point clone() => SplineResponse_Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineResponse_Point copyWith(void Function(SplineResponse_Point) updates) => super.copyWith((message) => updates(message as SplineResponse_Point)) as SplineResponse_Point; // ignore: deprecated_member_use
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
}

class SplineResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'SplineResponse', createEmptyInstance: create)
    ..aOM<SplineParameters>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineParameters', protoName: 'splineParameters', subBuilder: SplineParameters.create)
    ..e<SplineTypes>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'splineType', $pb.PbFieldType.OE, protoName: 'splineType', defaultOrMaker: SplineTypes.None, valueOf: SplineTypes.valueOf, enumValues: SplineTypes.values)
    ..pc<SplineResponse_Point>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'evaluatedPoints', $pb.PbFieldType.PM, protoName: 'evaluatedPoints', subBuilder: SplineResponse_Point.create)
    ..hasRequiredFields = false
  ;

  SplineResponse._() : super();
  factory SplineResponse({
    SplineParameters? splineParameters,
    SplineTypes? splineType,
    $core.Iterable<SplineResponse_Point>? evaluatedPoints,
  }) {
    final _result = create();
    if (splineParameters != null) {
      _result.splineParameters = splineParameters;
    }
    if (splineType != null) {
      _result.splineType = splineType;
    }
    if (evaluatedPoints != null) {
      _result.evaluatedPoints.addAll(evaluatedPoints);
    }
    return _result;
  }
  factory SplineResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplineResponse clone() => SplineResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplineResponse copyWith(void Function(SplineResponse) updates) => super.copyWith((message) => updates(message as SplineResponse)) as SplineResponse; // ignore: deprecated_member_use
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
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest.SwerveRobotParams', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAcceleration', $pb.PbFieldType.OF, protoName: 'maxAcceleration')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxJerk', $pb.PbFieldType.OF, protoName: 'maxJerk')
    ..a<$core.double>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAngularVelocity', $pb.PbFieldType.OF, protoName: 'maxAngularVelocity')
    ..a<$core.double>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAngularAcceleration', $pb.PbFieldType.OF, protoName: 'maxAngularAcceleration')
    ..hasRequiredFields = false
  ;

  TrajectoryRequest_SwerveRobotParams._() : super();
  factory TrajectoryRequest_SwerveRobotParams({
    $core.double? width,
    $core.double? height,
    $core.double? maxVelocity,
    $core.double? maxAcceleration,
    $core.double? maxJerk,
    $core.double? maxAngularVelocity,
    $core.double? maxAngularAcceleration,
  }) {
    final _result = create();
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    if (maxVelocity != null) {
      _result.maxVelocity = maxVelocity;
    }
    if (maxAcceleration != null) {
      _result.maxAcceleration = maxAcceleration;
    }
    if (maxJerk != null) {
      _result.maxJerk = maxJerk;
    }
    if (maxAngularVelocity != null) {
      _result.maxAngularVelocity = maxAngularVelocity;
    }
    if (maxAngularAcceleration != null) {
      _result.maxAngularAcceleration = maxAngularAcceleration;
    }
    return _result;
  }
  factory TrajectoryRequest_SwerveRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_SwerveRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_SwerveRobotParams clone() => TrajectoryRequest_SwerveRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_SwerveRobotParams copyWith(void Function(TrajectoryRequest_SwerveRobotParams) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_SwerveRobotParams)) as TrajectoryRequest_SwerveRobotParams; // ignore: deprecated_member_use
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
  $core.double get maxJerk => $_getN(4);
  @$pb.TagNumber(5)
  set maxJerk($core.double v) { $_setFloat(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMaxJerk() => $_has(4);
  @$pb.TagNumber(5)
  void clearMaxJerk() => clearField(5);

  @$pb.TagNumber(6)
  $core.double get maxAngularVelocity => $_getN(5);
  @$pb.TagNumber(6)
  set maxAngularVelocity($core.double v) { $_setFloat(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasMaxAngularVelocity() => $_has(5);
  @$pb.TagNumber(6)
  void clearMaxAngularVelocity() => clearField(6);

  @$pb.TagNumber(7)
  $core.double get maxAngularAcceleration => $_getN(6);
  @$pb.TagNumber(7)
  set maxAngularAcceleration($core.double v) { $_setFloat(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasMaxAngularAcceleration() => $_has(6);
  @$pb.TagNumber(7)
  void clearMaxAngularAcceleration() => clearField(7);
}

class TrajectoryRequest_TankRobotParams extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest.TankRobotParams', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'width', $pb.PbFieldType.OF)
    ..a<$core.double>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'height', $pb.PbFieldType.OF)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxAcceleration', $pb.PbFieldType.OF, protoName: 'maxAcceleration')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'maxJerk', $pb.PbFieldType.OF, protoName: 'maxJerk')
    ..hasRequiredFields = false
  ;

  TrajectoryRequest_TankRobotParams._() : super();
  factory TrajectoryRequest_TankRobotParams({
    $core.double? width,
    $core.double? height,
    $core.double? maxVelocity,
    $core.double? maxAcceleration,
    $core.double? maxJerk,
  }) {
    final _result = create();
    if (width != null) {
      _result.width = width;
    }
    if (height != null) {
      _result.height = height;
    }
    if (maxVelocity != null) {
      _result.maxVelocity = maxVelocity;
    }
    if (maxAcceleration != null) {
      _result.maxAcceleration = maxAcceleration;
    }
    if (maxJerk != null) {
      _result.maxJerk = maxJerk;
    }
    return _result;
  }
  factory TrajectoryRequest_TankRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_TankRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_TankRobotParams clone() => TrajectoryRequest_TankRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_TankRobotParams copyWith(void Function(TrajectoryRequest_TankRobotParams) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_TankRobotParams)) as TrajectoryRequest_TankRobotParams; // ignore: deprecated_member_use
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
}

class TrajectoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest', createEmptyInstance: create)
    ..pc<Section>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sections', $pb.PbFieldType.PM, subBuilder: Section.create)
    ..e<TrajectoryRequest_DriveTrain>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'driveTrain', $pb.PbFieldType.OE, protoName: 'driveTrain', defaultOrMaker: TrajectoryRequest_DriveTrain.Swerve, valueOf: TrajectoryRequest_DriveTrain.valueOf, enumValues: TrajectoryRequest_DriveTrain.values)
    ..aOM<TrajectoryRequest_SwerveRobotParams>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swerveRobotParams', protoName: 'swerveRobotParams', subBuilder: TrajectoryRequest_SwerveRobotParams.create)
    ..aOM<TrajectoryRequest_TankRobotParams>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tankRobotParams', protoName: 'tankRobotParams', subBuilder: TrajectoryRequest_TankRobotParams.create)
    ..hasRequiredFields = false
  ;

  TrajectoryRequest._() : super();
  factory TrajectoryRequest({
    $core.Iterable<Section>? sections,
    TrajectoryRequest_DriveTrain? driveTrain,
    TrajectoryRequest_SwerveRobotParams? swerveRobotParams,
    TrajectoryRequest_TankRobotParams? tankRobotParams,
  }) {
    final _result = create();
    if (sections != null) {
      _result.sections.addAll(sections);
    }
    if (driveTrain != null) {
      _result.driveTrain = driveTrain;
    }
    if (swerveRobotParams != null) {
      _result.swerveRobotParams = swerveRobotParams;
    }
    if (tankRobotParams != null) {
      _result.tankRobotParams = tankRobotParams;
    }
    return _result;
  }
  factory TrajectoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest clone() => TrajectoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest copyWith(void Function(TrajectoryRequest) updates) => super.copyWith((message) => updates(message as TrajectoryRequest)) as TrajectoryRequest; // ignore: deprecated_member_use
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
}

class TrajectoryResponse_SwervePoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryResponse.SwervePoint', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OF)
    ..aOM<Vector>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: Vector.create)
    ..aOM<Vector>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'velocity', subBuilder: Vector.create)
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heading', $pb.PbFieldType.OF)
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'angularVelocity', $pb.PbFieldType.OF, protoName: 'angularVelocity')
    ..hasRequiredFields = false
  ;

  TrajectoryResponse_SwervePoint._() : super();
  factory TrajectoryResponse_SwervePoint({
    $core.double? time,
    Vector? position,
    Vector? velocity,
    $core.double? heading,
    $core.double? angularVelocity,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (position != null) {
      _result.position = position;
    }
    if (velocity != null) {
      _result.velocity = velocity;
    }
    if (heading != null) {
      _result.heading = heading;
    }
    if (angularVelocity != null) {
      _result.angularVelocity = angularVelocity;
    }
    return _result;
  }
  factory TrajectoryResponse_SwervePoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse_SwervePoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_SwervePoint clone() => TrajectoryResponse_SwervePoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_SwervePoint copyWith(void Function(TrajectoryResponse_SwervePoint) updates) => super.copyWith((message) => updates(message as TrajectoryResponse_SwervePoint)) as TrajectoryResponse_SwervePoint; // ignore: deprecated_member_use
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
}

class TrajectoryResponse_TankPoint extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryResponse.TankPoint', createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'time', $pb.PbFieldType.OF)
    ..aOM<Vector>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: Vector.create)
    ..a<$core.double>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'rightVelocity', $pb.PbFieldType.OF, protoName: 'rightVelocity')
    ..a<$core.double>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'leftVelocity', $pb.PbFieldType.OF, protoName: 'leftVelocity')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heading', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  TrajectoryResponse_TankPoint._() : super();
  factory TrajectoryResponse_TankPoint({
    $core.double? time,
    Vector? position,
    $core.double? rightVelocity,
    $core.double? leftVelocity,
    $core.double? heading,
  }) {
    final _result = create();
    if (time != null) {
      _result.time = time;
    }
    if (position != null) {
      _result.position = position;
    }
    if (rightVelocity != null) {
      _result.rightVelocity = rightVelocity;
    }
    if (leftVelocity != null) {
      _result.leftVelocity = leftVelocity;
    }
    if (heading != null) {
      _result.heading = heading;
    }
    return _result;
  }
  factory TrajectoryResponse_TankPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse_TankPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_TankPoint clone() => TrajectoryResponse_TankPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse_TankPoint copyWith(void Function(TrajectoryResponse_TankPoint) updates) => super.copyWith((message) => updates(message as TrajectoryResponse_TankPoint)) as TrajectoryResponse_TankPoint; // ignore: deprecated_member_use
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
}

class TrajectoryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryResponse', createEmptyInstance: create)
    ..pc<TrajectoryResponse_SwervePoint>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'swervePoints', $pb.PbFieldType.PM, protoName: 'swervePoints', subBuilder: TrajectoryResponse_SwervePoint.create)
    ..pc<TrajectoryResponse_TankPoint>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tankPoints', $pb.PbFieldType.PM, protoName: 'tankPoints', subBuilder: TrajectoryResponse_TankPoint.create)
    ..hasRequiredFields = false
  ;

  TrajectoryResponse._() : super();
  factory TrajectoryResponse({
    $core.Iterable<TrajectoryResponse_SwervePoint>? swervePoints,
    $core.Iterable<TrajectoryResponse_TankPoint>? tankPoints,
  }) {
    final _result = create();
    if (swervePoints != null) {
      _result.swervePoints.addAll(swervePoints);
    }
    if (tankPoints != null) {
      _result.tankPoints.addAll(tankPoints);
    }
    return _result;
  }
  factory TrajectoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryResponse clone() => TrajectoryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryResponse copyWith(void Function(TrajectoryResponse) updates) => super.copyWith((message) => updates(message as TrajectoryResponse)) as TrajectoryResponse; // ignore: deprecated_member_use
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

