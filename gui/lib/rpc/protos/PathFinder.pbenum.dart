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

class SplineTypes extends $pb.ProtobufEnum {
  static const SplineTypes None = SplineTypes._(0, _omitEnumNames ? '' : 'None');
  static const SplineTypes Hermite = SplineTypes._(1, _omitEnumNames ? '' : 'Hermite');
  static const SplineTypes Bezier = SplineTypes._(2, _omitEnumNames ? '' : 'Bezier');
  static const SplineTypes Polynomial = SplineTypes._(3, _omitEnumNames ? '' : 'Polynomial');

  static const $core.List<SplineTypes> values = <SplineTypes> [
    None,
    Hermite,
    Bezier,
    Polynomial,
  ];

  static final $core.Map<$core.int, SplineTypes> _byValue = $pb.ProtobufEnum.initByValue(values);
  static SplineTypes? valueOf($core.int value) => _byValue[value];

  const SplineTypes._($core.int v, $core.String n) : super(v, n);
}

class TrajectoryRequest_DriveTrain extends $pb.ProtobufEnum {
  static const TrajectoryRequest_DriveTrain Swerve = TrajectoryRequest_DriveTrain._(0, _omitEnumNames ? '' : 'Swerve');
  static const TrajectoryRequest_DriveTrain Tank = TrajectoryRequest_DriveTrain._(1, _omitEnumNames ? '' : 'Tank');

  static const $core.List<TrajectoryRequest_DriveTrain> values = <TrajectoryRequest_DriveTrain> [
    Swerve,
    Tank,
  ];

  static final $core.Map<$core.int, TrajectoryRequest_DriveTrain> _byValue = $pb.ProtobufEnum.initByValue(values);
  static TrajectoryRequest_DriveTrain? valueOf($core.int value) => _byValue[value];

  const TrajectoryRequest_DriveTrain._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
