//
//  Generated code. Do not modify.
//  source: protos/pathfinder_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// utils
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

class SplinePoint extends $pb.GeneratedMessage {
  factory SplinePoint({
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
  SplinePoint._() : super();
  factory SplinePoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplinePoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplinePoint', createEmptyInstance: create)
    ..aOM<Vector>(1, _omitFieldNames ? '' : 'point', subBuilder: Vector.create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'segmentIndex', $pb.PbFieldType.O3, protoName: 'segmentIndex')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SplinePoint clone() => SplinePoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SplinePoint copyWith(void Function(SplinePoint) updates) => super.copyWith((message) => updates(message as SplinePoint)) as SplinePoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SplinePoint create() => SplinePoint._();
  SplinePoint createEmptyInstance() => create();
  static $pb.PbList<SplinePoint> createRepeated() => $pb.PbList<SplinePoint>();
  @$core.pragma('dart2js:noInline')
  static SplinePoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SplinePoint>(create);
  static SplinePoint? _defaultInstance;

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

class SwerveRobotParams extends $pb.GeneratedMessage {
  factory SwerveRobotParams({
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
  SwerveRobotParams._() : super();
  factory SwerveRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwerveRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SwerveRobotParams', createEmptyInstance: create)
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
  SwerveRobotParams clone() => SwerveRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwerveRobotParams copyWith(void Function(SwerveRobotParams) updates) => super.copyWith((message) => updates(message as SwerveRobotParams)) as SwerveRobotParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SwerveRobotParams create() => SwerveRobotParams._();
  SwerveRobotParams createEmptyInstance() => create();
  static $pb.PbList<SwerveRobotParams> createRepeated() => $pb.PbList<SwerveRobotParams>();
  @$core.pragma('dart2js:noInline')
  static SwerveRobotParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwerveRobotParams>(create);
  static SwerveRobotParams? _defaultInstance;

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

class TankRobotParams extends $pb.GeneratedMessage {
  factory TankRobotParams({
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
  TankRobotParams._() : super();
  factory TankRobotParams.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TankRobotParams.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TankRobotParams', createEmptyInstance: create)
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
  TankRobotParams clone() => TankRobotParams()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TankRobotParams copyWith(void Function(TankRobotParams) updates) => super.copyWith((message) => updates(message as TankRobotParams)) as TankRobotParams;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TankRobotParams create() => TankRobotParams._();
  TankRobotParams createEmptyInstance() => create();
  static $pb.PbList<TankRobotParams> createRepeated() => $pb.PbList<TankRobotParams>();
  @$core.pragma('dart2js:noInline')
  static TankRobotParams getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TankRobotParams>(create);
  static TankRobotParams? _defaultInstance;

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

class SwervePoints_SwervePoint extends $pb.GeneratedMessage {
  factory SwervePoints_SwervePoint({
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
  SwervePoints_SwervePoint._() : super();
  factory SwervePoints_SwervePoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwervePoints_SwervePoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SwervePoints.SwervePoint', createEmptyInstance: create)
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
  SwervePoints_SwervePoint clone() => SwervePoints_SwervePoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwervePoints_SwervePoint copyWith(void Function(SwervePoints_SwervePoint) updates) => super.copyWith((message) => updates(message as SwervePoints_SwervePoint)) as SwervePoints_SwervePoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SwervePoints_SwervePoint create() => SwervePoints_SwervePoint._();
  SwervePoints_SwervePoint createEmptyInstance() => create();
  static $pb.PbList<SwervePoints_SwervePoint> createRepeated() => $pb.PbList<SwervePoints_SwervePoint>();
  @$core.pragma('dart2js:noInline')
  static SwervePoints_SwervePoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwervePoints_SwervePoint>(create);
  static SwervePoints_SwervePoint? _defaultInstance;

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

class SwervePoints extends $pb.GeneratedMessage {
  factory SwervePoints({
    $core.Iterable<SwervePoints_SwervePoint>? swervePoints,
  }) {
    final $result = create();
    if (swervePoints != null) {
      $result.swervePoints.addAll(swervePoints);
    }
    return $result;
  }
  SwervePoints._() : super();
  factory SwervePoints.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SwervePoints.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SwervePoints', createEmptyInstance: create)
    ..pc<SwervePoints_SwervePoint>(1, _omitFieldNames ? '' : 'swervePoints', $pb.PbFieldType.PM, protoName: 'swervePoints', subBuilder: SwervePoints_SwervePoint.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  SwervePoints clone() => SwervePoints()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  SwervePoints copyWith(void Function(SwervePoints) updates) => super.copyWith((message) => updates(message as SwervePoints)) as SwervePoints;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SwervePoints create() => SwervePoints._();
  SwervePoints createEmptyInstance() => create();
  static $pb.PbList<SwervePoints> createRepeated() => $pb.PbList<SwervePoints>();
  @$core.pragma('dart2js:noInline')
  static SwervePoints getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SwervePoints>(create);
  static SwervePoints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<SwervePoints_SwervePoint> get swervePoints => $_getList(0);
}

class TankPoints_TankPoint extends $pb.GeneratedMessage {
  factory TankPoints_TankPoint({
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
  TankPoints_TankPoint._() : super();
  factory TankPoints_TankPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TankPoints_TankPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TankPoints.TankPoint', createEmptyInstance: create)
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
  TankPoints_TankPoint clone() => TankPoints_TankPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TankPoints_TankPoint copyWith(void Function(TankPoints_TankPoint) updates) => super.copyWith((message) => updates(message as TankPoints_TankPoint)) as TankPoints_TankPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TankPoints_TankPoint create() => TankPoints_TankPoint._();
  TankPoints_TankPoint createEmptyInstance() => create();
  static $pb.PbList<TankPoints_TankPoint> createRepeated() => $pb.PbList<TankPoints_TankPoint>();
  @$core.pragma('dart2js:noInline')
  static TankPoints_TankPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TankPoints_TankPoint>(create);
  static TankPoints_TankPoint? _defaultInstance;

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

class TankPoints extends $pb.GeneratedMessage {
  factory TankPoints({
    $core.Iterable<TankPoints_TankPoint>? tankPoints,
  }) {
    final $result = create();
    if (tankPoints != null) {
      $result.tankPoints.addAll(tankPoints);
    }
    return $result;
  }
  TankPoints._() : super();
  factory TankPoints.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TankPoints.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TankPoints', createEmptyInstance: create)
    ..pc<TankPoints_TankPoint>(1, _omitFieldNames ? '' : 'tankPoints', $pb.PbFieldType.PM, protoName: 'tankPoints', subBuilder: TankPoints_TankPoint.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TankPoints clone() => TankPoints()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TankPoints copyWith(void Function(TankPoints) updates) => super.copyWith((message) => updates(message as TankPoints)) as TankPoints;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TankPoints create() => TankPoints._();
  TankPoints createEmptyInstance() => create();
  static $pb.PbList<TankPoints> createRepeated() => $pb.PbList<TankPoints>();
  @$core.pragma('dart2js:noInline')
  static TankPoints getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TankPoints>(create);
  static TankPoints? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<TankPoints_TankPoint> get tankPoints => $_getList(0);
}

/// path definitions
class PathPoint extends $pb.GeneratedMessage {
  factory PathPoint({
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
  PathPoint._() : super();
  factory PathPoint.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PathPoint.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PathPoint', createEmptyInstance: create)
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
  PathPoint clone() => PathPoint()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PathPoint copyWith(void Function(PathPoint) updates) => super.copyWith((message) => updates(message as PathPoint)) as PathPoint;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PathPoint create() => PathPoint._();
  PathPoint createEmptyInstance() => create();
  static $pb.PbList<PathPoint> createRepeated() => $pb.PbList<PathPoint>();
  @$core.pragma('dart2js:noInline')
  static PathPoint getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PathPoint>(create);
  static PathPoint? _defaultInstance;

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
    $core.Iterable<PathPoint>? points,
    $core.double? maxVelocity,
  }) {
    final $result = create();
    if (points != null) {
      $result.points.addAll(points);
    }
    if (maxVelocity != null) {
      $result.maxVelocity = maxVelocity;
    }
    return $result;
  }
  Segment._() : super();
  factory Segment.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Segment.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Segment', createEmptyInstance: create)
    ..pc<PathPoint>(1, _omitFieldNames ? '' : 'points', $pb.PbFieldType.PM, subBuilder: PathPoint.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'maxVelocity', $pb.PbFieldType.OF, protoName: 'maxVelocity')
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
  $core.List<PathPoint> get points => $_getList(0);

  @$pb.TagNumber(2)
  $core.double get maxVelocity => $_getN(1);
  @$pb.TagNumber(2)
  set maxVelocity($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMaxVelocity() => $_has(1);
  @$pb.TagNumber(2)
  void clearMaxVelocity() => clearField(2);
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

enum TrajectoryRequest_RobotParams {
  swerveParams, 
  tankParams, 
  notSet
}

/// trajectory
class TrajectoryRequest extends $pb.GeneratedMessage {
  factory TrajectoryRequest({
    $core.Iterable<Section>? sections,
    SwerveRobotParams? swerveParams,
    TankRobotParams? tankParams,
    $core.String? fileName,
  }) {
    final $result = create();
    if (sections != null) {
      $result.sections.addAll(sections);
    }
    if (swerveParams != null) {
      $result.swerveParams = swerveParams;
    }
    if (tankParams != null) {
      $result.tankParams = tankParams;
    }
    if (fileName != null) {
      $result.fileName = fileName;
    }
    return $result;
  }
  TrajectoryRequest._() : super();
  factory TrajectoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TrajectoryRequest_RobotParams> _TrajectoryRequest_RobotParamsByTag = {
    2 : TrajectoryRequest_RobotParams.swerveParams,
    3 : TrajectoryRequest_RobotParams.tankParams,
    0 : TrajectoryRequest_RobotParams.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryRequest', createEmptyInstance: create)
    ..oo(0, [2, 3])
    ..pc<Section>(1, _omitFieldNames ? '' : 'sections', $pb.PbFieldType.PM, subBuilder: Section.create)
    ..aOM<SwerveRobotParams>(2, _omitFieldNames ? '' : 'swerveParams', protoName: 'swerveParams', subBuilder: SwerveRobotParams.create)
    ..aOM<TankRobotParams>(3, _omitFieldNames ? '' : 'tankParams', protoName: 'tankParams', subBuilder: TankRobotParams.create)
    ..aOS(4, _omitFieldNames ? '' : 'fileName', protoName: 'fileName')
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

  TrajectoryRequest_RobotParams whichRobotParams() => _TrajectoryRequest_RobotParamsByTag[$_whichOneof(0)]!;
  void clearRobotParams() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.List<Section> get sections => $_getList(0);

  @$pb.TagNumber(2)
  SwerveRobotParams get swerveParams => $_getN(1);
  @$pb.TagNumber(2)
  set swerveParams(SwerveRobotParams v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasSwerveParams() => $_has(1);
  @$pb.TagNumber(2)
  void clearSwerveParams() => clearField(2);
  @$pb.TagNumber(2)
  SwerveRobotParams ensureSwerveParams() => $_ensure(1);

  @$pb.TagNumber(3)
  TankRobotParams get tankParams => $_getN(2);
  @$pb.TagNumber(3)
  set tankParams(TankRobotParams v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTankParams() => $_has(2);
  @$pb.TagNumber(3)
  void clearTankParams() => clearField(3);
  @$pb.TagNumber(3)
  TankRobotParams ensureTankParams() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.String get fileName => $_getSZ(3);
  @$pb.TagNumber(4)
  set fileName($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasFileName() => $_has(3);
  @$pb.TagNumber(4)
  void clearFileName() => clearField(4);
}

enum TrajectoryResponse_Points {
  swervePoints, 
  tankPoints, 
  notSet
}

class TrajectoryResponse extends $pb.GeneratedMessage {
  factory TrajectoryResponse({
    SwervePoints? swervePoints,
    TankPoints? tankPoints,
  }) {
    final $result = create();
    if (swervePoints != null) {
      $result.swervePoints = swervePoints;
    }
    if (tankPoints != null) {
      $result.tankPoints = tankPoints;
    }
    return $result;
  }
  TrajectoryResponse._() : super();
  factory TrajectoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TrajectoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, TrajectoryResponse_Points> _TrajectoryResponse_PointsByTag = {
    1 : TrajectoryResponse_Points.swervePoints,
    2 : TrajectoryResponse_Points.tankPoints,
    0 : TrajectoryResponse_Points.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TrajectoryResponse', createEmptyInstance: create)
    ..oo(0, [1, 2])
    ..aOM<SwervePoints>(1, _omitFieldNames ? '' : 'swervePoints', protoName: 'swervePoints', subBuilder: SwervePoints.create)
    ..aOM<TankPoints>(2, _omitFieldNames ? '' : 'tankPoints', protoName: 'tankPoints', subBuilder: TankPoints.create)
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

  TrajectoryResponse_Points whichPoints() => _TrajectoryResponse_PointsByTag[$_whichOneof(0)]!;
  void clearPoints() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  SwervePoints get swervePoints => $_getN(0);
  @$pb.TagNumber(1)
  set swervePoints(SwervePoints v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSwervePoints() => $_has(0);
  @$pb.TagNumber(1)
  void clearSwervePoints() => clearField(1);
  @$pb.TagNumber(1)
  SwervePoints ensureSwervePoints() => $_ensure(0);

  @$pb.TagNumber(2)
  TankPoints get tankPoints => $_getN(1);
  @$pb.TagNumber(2)
  set tankPoints(TankPoints v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTankPoints() => $_has(1);
  @$pb.TagNumber(2)
  void clearTankPoints() => clearField(2);
  @$pb.TagNumber(2)
  TankPoints ensureTankPoints() => $_ensure(1);
}

/// spline
class SplineRequest extends $pb.GeneratedMessage {
  factory SplineRequest({
    $core.Iterable<Segment>? segments,
    $core.double? pointInterval,
  }) {
    final $result = create();
    if (segments != null) {
      $result.segments.addAll(segments);
    }
    if (pointInterval != null) {
      $result.pointInterval = pointInterval;
    }
    return $result;
  }
  SplineRequest._() : super();
  factory SplineRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineRequest', createEmptyInstance: create)
    ..pc<Segment>(1, _omitFieldNames ? '' : 'segments', $pb.PbFieldType.PM, subBuilder: Segment.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'pointInterval', $pb.PbFieldType.OF, protoName: 'pointInterval')
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
  $core.double get pointInterval => $_getN(1);
  @$pb.TagNumber(2)
  set pointInterval($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPointInterval() => $_has(1);
  @$pb.TagNumber(2)
  void clearPointInterval() => clearField(2);
}

class SplineResponse extends $pb.GeneratedMessage {
  factory SplineResponse({
    $core.Iterable<SplinePoint>? splinePoints,
  }) {
    final $result = create();
    if (splinePoints != null) {
      $result.splinePoints.addAll(splinePoints);
    }
    return $result;
  }
  SplineResponse._() : super();
  factory SplineResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SplineResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'SplineResponse', createEmptyInstance: create)
    ..pc<SplinePoint>(1, _omitFieldNames ? '' : 'splinePoints', $pb.PbFieldType.PM, protoName: 'splinePoints', subBuilder: SplinePoint.create)
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
  $core.List<SplinePoint> get splinePoints => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
