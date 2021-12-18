///
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use splineTypesDescriptor instead')
const SplineTypes$json = const {
  '1': 'SplineTypes',
  '2': const [
    const {'1': 'None', '2': 0},
    const {'1': 'Hermite', '2': 1},
    const {'1': 'Bezier', '2': 2},
    const {'1': 'Polynomial', '2': 3},
  ],
};

/// Descriptor for `SplineTypes`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List splineTypesDescriptor = $convert.base64Decode('CgtTcGxpbmVUeXBlcxIICgROb25lEAASCwoHSGVybWl0ZRABEgoKBkJlemllchACEg4KClBvbHlub21pYWwQAw==');
@$core.Deprecated('Use vectorDescriptor instead')
const Vector$json = const {
  '1': 'Vector',
  '2': const [
    const {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    const {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `Vector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vectorDescriptor = $convert.base64Decode('CgZWZWN0b3ISDAoBeBgBIAEoAlIBeBIMCgF5GAIgASgCUgF5');
@$core.Deprecated('Use pointDescriptor instead')
const Point$json = const {
  '1': 'Point',
  '2': const [
    const {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    const {'1': 'controlIn', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'controlIn'},
    const {'1': 'controlOut', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'controlOut'},
    const {'1': 'useHeading', '3': 4, '4': 1, '5': 8, '10': 'useHeading'},
    const {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor = $convert.base64Decode('CgVQb2ludBIjCghwb3NpdGlvbhgBIAEoCzIHLlZlY3RvclIIcG9zaXRpb24SJQoJY29udHJvbEluGAIgASgLMgcuVmVjdG9yUgljb250cm9sSW4SJwoKY29udHJvbE91dBgDIAEoCzIHLlZlY3RvclIKY29udHJvbE91dBIeCgp1c2VIZWFkaW5nGAQgASgIUgp1c2VIZWFkaW5nEhgKB2hlYWRpbmcYBSABKAJSB2hlYWRpbmc=');
@$core.Deprecated('Use segmentDescriptor instead')
const Segment$json = const {
  '1': 'Segment',
  '2': const [
    const {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.Point', '10': 'points'},
    const {'1': 'maxVelocity', '3': 2, '4': 1, '5': 2, '10': 'maxVelocity'},
    const {'1': 'splineType', '3': 3, '4': 1, '5': 14, '6': '.SplineTypes', '10': 'splineType'},
    const {'1': 'splineParameters', '3': 4, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
  ],
};

/// Descriptor for `Segment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List segmentDescriptor = $convert.base64Decode('CgdTZWdtZW50Eh4KBnBvaW50cxgBIAMoCzIGLlBvaW50UgZwb2ludHMSIAoLbWF4VmVsb2NpdHkYAiABKAJSC21heFZlbG9jaXR5EiwKCnNwbGluZVR5cGUYAyABKA4yDC5TcGxpbmVUeXBlc1IKc3BsaW5lVHlwZRI9ChBzcGxpbmVQYXJhbWV0ZXJzGAQgASgLMhEuU3BsaW5lUGFyYW1ldGVyc1IQc3BsaW5lUGFyYW1ldGVycw==');
@$core.Deprecated('Use sectionDescriptor instead')
const Section$json = const {
  '1': 'Section',
  '2': const [
    const {'1': 'segments', '3': 1, '4': 3, '5': 11, '6': '.Segment', '10': 'segments'},
  ],
};

/// Descriptor for `Section`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectionDescriptor = $convert.base64Decode('CgdTZWN0aW9uEiQKCHNlZ21lbnRzGAEgAygLMgguU2VnbWVudFIIc2VnbWVudHM=');
@$core.Deprecated('Use splineParametersDescriptor instead')
const SplineParameters$json = const {
  '1': 'SplineParameters',
  '2': const [
    const {'1': 'params', '3': 1, '4': 3, '5': 2, '10': 'params'},
  ],
};

/// Descriptor for `SplineParameters`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineParametersDescriptor = $convert.base64Decode('ChBTcGxpbmVQYXJhbWV0ZXJzEhYKBnBhcmFtcxgBIAMoAlIGcGFyYW1z');
@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest$json = const {
  '1': 'SplineRequest',
  '2': const [
    const {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.Point', '10': 'points'},
    const {'1': 'splineType', '3': 2, '4': 1, '5': 14, '6': '.SplineTypes', '10': 'splineType'},
    const {'1': 'evaluatedPointsInterval', '3': 3, '4': 1, '5': 2, '10': 'evaluatedPointsInterval'},
    const {'1': 'splineParameters', '3': 4, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
    const {'1': 'optimizationParams', '3': 5, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams', '10': 'optimizationParams'},
  ],
  '3': const [SplineRequest_OptimizationParams$json],
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams$json = const {
  '1': 'OptimizationParams',
  '2': const [
    const {'1': 'hermite', '3': 5, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Hermite', '10': 'hermite'},
    const {'1': 'bezier', '3': 6, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Bezier', '10': 'bezier'},
    const {'1': 'polynomial', '3': 7, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Polynomial', '10': 'polynomial'},
  ],
  '3': const [SplineRequest_OptimizationParams_Hermite$json, SplineRequest_OptimizationParams_Bezier$json, SplineRequest_OptimizationParams_Polynomial$json],
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Hermite$json = const {
  '1': 'Hermite',
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Bezier$json = const {
  '1': 'Bezier',
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Polynomial$json = const {
  '1': 'Polynomial',
};

/// Descriptor for `SplineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineRequestDescriptor = $convert.base64Decode('Cg1TcGxpbmVSZXF1ZXN0Eh4KBnBvaW50cxgBIAMoCzIGLlBvaW50UgZwb2ludHMSLAoKc3BsaW5lVHlwZRgCIAEoDjIMLlNwbGluZVR5cGVzUgpzcGxpbmVUeXBlEjgKF2V2YWx1YXRlZFBvaW50c0ludGVydmFsGAMgASgCUhdldmFsdWF0ZWRQb2ludHNJbnRlcnZhbBI9ChBzcGxpbmVQYXJhbWV0ZXJzGAQgASgLMhEuU3BsaW5lUGFyYW1ldGVyc1IQc3BsaW5lUGFyYW1ldGVycxJRChJvcHRpbWl6YXRpb25QYXJhbXMYBSABKAsyIS5TcGxpbmVSZXF1ZXN0Lk9wdGltaXphdGlvblBhcmFtc1ISb3B0aW1pemF0aW9uUGFyYW1zGowCChJPcHRpbWl6YXRpb25QYXJhbXMSQwoHaGVybWl0ZRgFIAEoCzIpLlNwbGluZVJlcXVlc3QuT3B0aW1pemF0aW9uUGFyYW1zLkhlcm1pdGVSB2hlcm1pdGUSQAoGYmV6aWVyGAYgASgLMiguU3BsaW5lUmVxdWVzdC5PcHRpbWl6YXRpb25QYXJhbXMuQmV6aWVyUgZiZXppZXISTAoKcG9seW5vbWlhbBgHIAEoCzIsLlNwbGluZVJlcXVlc3QuT3B0aW1pemF0aW9uUGFyYW1zLlBvbHlub21pYWxSCnBvbHlub21pYWwaCQoHSGVybWl0ZRoICgZCZXppZXIaDAoKUG9seW5vbWlhbA==');
@$core.Deprecated('Use splineResponseDescriptor instead')
const SplineResponse$json = const {
  '1': 'SplineResponse',
  '2': const [
    const {'1': 'splineParameters', '3': 1, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
    const {'1': 'splineType', '3': 2, '4': 1, '5': 14, '6': '.SplineTypes', '10': 'splineType'},
    const {'1': 'evaluatedPoints', '3': 3, '4': 3, '5': 11, '6': '.SplineResponse.Point', '10': 'evaluatedPoints'},
  ],
  '3': const [SplineResponse_Point$json],
};

@$core.Deprecated('Use splineResponseDescriptor instead')
const SplineResponse_Point$json = const {
  '1': 'Point',
  '2': const [
    const {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'point'},
  ],
};

/// Descriptor for `SplineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineResponseDescriptor = $convert.base64Decode('Cg5TcGxpbmVSZXNwb25zZRI9ChBzcGxpbmVQYXJhbWV0ZXJzGAEgASgLMhEuU3BsaW5lUGFyYW1ldGVyc1IQc3BsaW5lUGFyYW1ldGVycxIsCgpzcGxpbmVUeXBlGAIgASgOMgwuU3BsaW5lVHlwZXNSCnNwbGluZVR5cGUSPwoPZXZhbHVhdGVkUG9pbnRzGAMgAygLMhUuU3BsaW5lUmVzcG9uc2UuUG9pbnRSD2V2YWx1YXRlZFBvaW50cxomCgVQb2ludBIdCgVwb2ludBgBIAEoCzIHLlZlY3RvclIFcG9pbnQ=');
@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest$json = const {
  '1': 'TrajectoryRequest',
  '2': const [
    const {'1': 'sections', '3': 1, '4': 3, '5': 11, '6': '.Section', '10': 'sections'},
    const {'1': 'driveTrain', '3': 4, '4': 1, '5': 14, '6': '.TrajectoryRequest.DriveTrain', '10': 'driveTrain'},
    const {'1': 'swerveRobotParams', '3': 5, '4': 1, '5': 11, '6': '.TrajectoryRequest.SwerveRobotParams', '10': 'swerveRobotParams'},
    const {'1': 'tankRobotParams', '3': 6, '4': 1, '5': 11, '6': '.TrajectoryRequest.TankRobotParams', '10': 'tankRobotParams'},
  ],
  '3': const [TrajectoryRequest_SwerveRobotParams$json, TrajectoryRequest_TankRobotParams$json],
  '4': const [TrajectoryRequest_DriveTrain$json],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_SwerveRobotParams$json = const {
  '1': 'SwerveRobotParams',
  '2': const [
    const {'1': 'width', '3': 1, '4': 1, '5': 2, '10': 'width'},
    const {'1': 'height', '3': 2, '4': 1, '5': 2, '10': 'height'},
    const {'1': 'maxVelocity', '3': 3, '4': 1, '5': 2, '10': 'maxVelocity'},
    const {'1': 'maxAcceleration', '3': 4, '4': 1, '5': 2, '10': 'maxAcceleration'},
    const {'1': 'skidAcceleration', '3': 5, '4': 1, '5': 2, '10': 'skidAcceleration'},
    const {'1': 'maxJerk', '3': 6, '4': 1, '5': 2, '10': 'maxJerk'},
    const {'1': 'maxAngularVelocity', '3': 7, '4': 1, '5': 2, '10': 'maxAngularVelocity'},
    const {'1': 'maxAngularAcceleration', '3': 8, '4': 1, '5': 2, '10': 'maxAngularAcceleration'},
    const {'1': 'cycleTime', '3': 9, '4': 1, '5': 2, '10': 'cycleTime'},
  ],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_TankRobotParams$json = const {
  '1': 'TankRobotParams',
  '2': const [
    const {'1': 'width', '3': 1, '4': 1, '5': 2, '10': 'width'},
    const {'1': 'height', '3': 2, '4': 1, '5': 2, '10': 'height'},
    const {'1': 'maxVelocity', '3': 3, '4': 1, '5': 2, '10': 'maxVelocity'},
    const {'1': 'maxAcceleration', '3': 4, '4': 1, '5': 2, '10': 'maxAcceleration'},
    const {'1': 'maxJerk', '3': 5, '4': 1, '5': 2, '10': 'maxJerk'},
    const {'1': 'cycleTime', '3': 6, '4': 1, '5': 2, '10': 'cycleTime'},
  ],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_DriveTrain$json = const {
  '1': 'DriveTrain',
  '2': const [
    const {'1': 'Swerve', '2': 0},
    const {'1': 'Tank', '2': 1},
  ],
};

/// Descriptor for `TrajectoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryRequestDescriptor = $convert.base64Decode('ChFUcmFqZWN0b3J5UmVxdWVzdBIkCghzZWN0aW9ucxgBIAMoCzIILlNlY3Rpb25SCHNlY3Rpb25zEj0KCmRyaXZlVHJhaW4YBCABKA4yHS5UcmFqZWN0b3J5UmVxdWVzdC5Ecml2ZVRyYWluUgpkcml2ZVRyYWluElIKEXN3ZXJ2ZVJvYm90UGFyYW1zGAUgASgLMiQuVHJhamVjdG9yeVJlcXVlc3QuU3dlcnZlUm9ib3RQYXJhbXNSEXN3ZXJ2ZVJvYm90UGFyYW1zEkwKD3RhbmtSb2JvdFBhcmFtcxgGIAEoCzIiLlRyYWplY3RvcnlSZXF1ZXN0LlRhbmtSb2JvdFBhcmFtc1IPdGFua1JvYm90UGFyYW1zGtkCChFTd2VydmVSb2JvdFBhcmFtcxIUCgV3aWR0aBgBIAEoAlIFd2lkdGgSFgoGaGVpZ2h0GAIgASgCUgZoZWlnaHQSIAoLbWF4VmVsb2NpdHkYAyABKAJSC21heFZlbG9jaXR5EigKD21heEFjY2VsZXJhdGlvbhgEIAEoAlIPbWF4QWNjZWxlcmF0aW9uEioKEHNraWRBY2NlbGVyYXRpb24YBSABKAJSEHNraWRBY2NlbGVyYXRpb24SGAoHbWF4SmVyaxgGIAEoAlIHbWF4SmVyaxIuChJtYXhBbmd1bGFyVmVsb2NpdHkYByABKAJSEm1heEFuZ3VsYXJWZWxvY2l0eRI2ChZtYXhBbmd1bGFyQWNjZWxlcmF0aW9uGAggASgCUhZtYXhBbmd1bGFyQWNjZWxlcmF0aW9uEhwKCWN5Y2xlVGltZRgJIAEoAlIJY3ljbGVUaW1lGsMBCg9UYW5rUm9ib3RQYXJhbXMSFAoFd2lkdGgYASABKAJSBXdpZHRoEhYKBmhlaWdodBgCIAEoAlIGaGVpZ2h0EiAKC21heFZlbG9jaXR5GAMgASgCUgttYXhWZWxvY2l0eRIoCg9tYXhBY2NlbGVyYXRpb24YBCABKAJSD21heEFjY2VsZXJhdGlvbhIYCgdtYXhKZXJrGAUgASgCUgdtYXhKZXJrEhwKCWN5Y2xlVGltZRgGIAEoAlIJY3ljbGVUaW1lIiIKCkRyaXZlVHJhaW4SCgoGU3dlcnZlEAASCAoEVGFuaxAB');
@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse$json = const {
  '1': 'TrajectoryResponse',
  '2': const [
    const {'1': 'swervePoints', '3': 1, '4': 3, '5': 11, '6': '.TrajectoryResponse.SwervePoint', '10': 'swervePoints'},
    const {'1': 'tankPoints', '3': 2, '4': 3, '5': 11, '6': '.TrajectoryResponse.TankPoint', '10': 'tankPoints'},
  ],
  '3': const [TrajectoryResponse_SwervePoint$json, TrajectoryResponse_TankPoint$json],
};

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse_SwervePoint$json = const {
  '1': 'SwervePoint',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 2, '10': 'time'},
    const {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    const {'1': 'velocity', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'velocity'},
    const {'1': 'heading', '3': 4, '4': 1, '5': 2, '10': 'heading'},
    const {'1': 'angularVelocity', '3': 5, '4': 1, '5': 2, '10': 'angularVelocity'},
  ],
};

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse_TankPoint$json = const {
  '1': 'TankPoint',
  '2': const [
    const {'1': 'time', '3': 1, '4': 1, '5': 2, '10': 'time'},
    const {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    const {'1': 'rightVelocity', '3': 3, '4': 1, '5': 2, '10': 'rightVelocity'},
    const {'1': 'leftVelocity', '3': 4, '4': 1, '5': 2, '10': 'leftVelocity'},
    const {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
  ],
};

/// Descriptor for `TrajectoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryResponseDescriptor = $convert.base64Decode('ChJUcmFqZWN0b3J5UmVzcG9uc2USQwoMc3dlcnZlUG9pbnRzGAEgAygLMh8uVHJhamVjdG9yeVJlc3BvbnNlLlN3ZXJ2ZVBvaW50Ugxzd2VydmVQb2ludHMSPQoKdGFua1BvaW50cxgCIAMoCzIdLlRyYWplY3RvcnlSZXNwb25zZS5UYW5rUG9pbnRSCnRhbmtQb2ludHMarwEKC1N3ZXJ2ZVBvaW50EhIKBHRpbWUYASABKAJSBHRpbWUSIwoIcG9zaXRpb24YAiABKAsyBy5WZWN0b3JSCHBvc2l0aW9uEiMKCHZlbG9jaXR5GAMgASgLMgcuVmVjdG9yUgh2ZWxvY2l0eRIYCgdoZWFkaW5nGAQgASgCUgdoZWFkaW5nEigKD2FuZ3VsYXJWZWxvY2l0eRgFIAEoAlIPYW5ndWxhclZlbG9jaXR5GqgBCglUYW5rUG9pbnQSEgoEdGltZRgBIAEoAlIEdGltZRIjCghwb3NpdGlvbhgCIAEoCzIHLlZlY3RvclIIcG9zaXRpb24SJAoNcmlnaHRWZWxvY2l0eRgDIAEoAlINcmlnaHRWZWxvY2l0eRIiCgxsZWZ0VmVsb2NpdHkYBCABKAJSDGxlZnRWZWxvY2l0eRIYCgdoZWFkaW5nGAUgASgCUgdoZWFkaW5n');
