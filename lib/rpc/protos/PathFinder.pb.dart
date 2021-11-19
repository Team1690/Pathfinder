///
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

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

class TrajectoryRequest_Point extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest.Point', createEmptyInstance: create)
    ..aOM<Vector>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'position', subBuilder: Vector.create)
    ..aOM<Vector>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'controlIn', protoName: 'controlIn', subBuilder: Vector.create)
    ..aOM<Vector>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'controlOut', protoName: 'controlOut', subBuilder: Vector.create)
    ..aOB(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'useHeading', protoName: 'useHeading')
    ..a<$core.double>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'heading', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  TrajectoryRequest_Point._() : super();
  factory TrajectoryRequest_Point({
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
  factory TrajectoryRequest_Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_Point clone() => TrajectoryRequest_Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_Point copyWith(void Function(TrajectoryRequest_Point) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_Point)) as TrajectoryRequest_Point; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_Point create() => TrajectoryRequest_Point._();
  TrajectoryRequest_Point createEmptyInstance() => create();
  static $pb.PbList<TrajectoryRequest_Point> createRepeated() => $pb.PbList<TrajectoryRequest_Point>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_Point getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryRequest_Point>(create);
  static TrajectoryRequest_Point? _defaultInstance;

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

class TrajectoryRequest_Segment extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest.Segment', createEmptyInstance: create)
    ..pc<TrajectoryRequest_Point>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'points', $pb.PbFieldType.PM, subBuilder: TrajectoryRequest_Point.create)
    ..hasRequiredFields = false
  ;

  TrajectoryRequest_Segment._() : super();
  factory TrajectoryRequest_Segment({
    $core.Iterable<TrajectoryRequest_Point>? points,
  }) {
    final _result = create();
    if (points != null) {
      _result.points.addAll(points);
    }
    return _result;
  }
  factory TrajectoryRequest_Segment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest_Segment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_Segment clone() => TrajectoryRequest_Segment()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TrajectoryRequest_Segment copyWith(void Function(TrajectoryRequest_Segment) updates) => super.copyWith((message) => updates(message as TrajectoryRequest_Segment)) as TrajectoryRequest_Segment; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_Segment create() => TrajectoryRequest_Segment._();
  TrajectoryRequest_Segment createEmptyInstance() => create();
  static $pb.PbList<TrajectoryRequest_Segment> createRepeated() => $pb.PbList<TrajectoryRequest_Segment>();
  @$core.pragma('dart2js:noInline')
  static TrajectoryRequest_Segment getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TrajectoryRequest_Segment>(create);
  static TrajectoryRequest_Segment? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TrajectoryRequest_Point> get points => $_getList(0);
}

class TrajectoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryRequest', createEmptyInstance: create)
    ..pc<TrajectoryRequest_Segment>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'segments', $pb.PbFieldType.PM, subBuilder: TrajectoryRequest_Segment.create)
    ..hasRequiredFields = false
  ;

  TrajectoryRequest._() : super();
  factory TrajectoryRequest({
    $core.Iterable<TrajectoryRequest_Segment>? segments,
  }) {
    final _result = create();
    if (segments != null) {
      _result.segments.addAll(segments);
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
  $core.List<TrajectoryRequest_Segment> get segments => $_getList(0);
}

class TrajectoryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'TrajectoryResponse', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  TrajectoryResponse._() : super();
  factory TrajectoryResponse() => create();
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
}

