//
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use splineTypesDescriptor instead')
const SplineTypes$json = {
  '1': 'SplineTypes',
  '2': [
    {'1': 'None', '2': 0},
    {'1': 'Hermite', '2': 1},
    {'1': 'Bezier', '2': 2},
    {'1': 'Polynomial', '2': 3},
  ],
};

/// Descriptor for `SplineTypes`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List splineTypesDescriptor = $convert.base64Decode(
    'CgtTcGxpbmVUeXBlcxIICgROb25lEAASCwoHSGVybWl0ZRABEgoKBkJlemllchACEg4KClBvbH'
    'lub21pYWwQAw==');

@$core.Deprecated('Use robotActionDescriptor instead')
const RobotAction$json = {
  '1': 'RobotAction',
  '2': [
    {'1': 'actionType', '3': 1, '4': 1, '5': 9, '10': 'actionType'},
    {'1': 'time', '3': 2, '4': 1, '5': 2, '10': 'time'},
  ],
};

/// Descriptor for `RobotAction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List robotActionDescriptor = $convert.base64Decode(
    'CgtSb2JvdEFjdGlvbhIeCgphY3Rpb25UeXBlGAEgASgJUgphY3Rpb25UeXBlEhIKBHRpbWUYAi'
    'ABKAJSBHRpbWU=');

@$core.Deprecated('Use vectorDescriptor instead')
const Vector$json = {
  '1': 'Vector',
  '2': [
    {'1': 'x', '3': 1, '4': 1, '5': 2, '10': 'x'},
    {'1': 'y', '3': 2, '4': 1, '5': 2, '10': 'y'},
  ],
};

/// Descriptor for `Vector`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vectorDescriptor = $convert.base64Decode(
    'CgZWZWN0b3ISDAoBeBgBIAEoAlIBeBIMCgF5GAIgASgCUgF5');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    {'1': 'controlIn', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'controlIn'},
    {'1': 'controlOut', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'controlOut'},
    {'1': 'useHeading', '3': 4, '4': 1, '5': 8, '10': 'useHeading'},
    {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
    {'1': 'action', '3': 6, '4': 1, '5': 11, '6': '.RobotAction', '10': 'action'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor = $convert.base64Decode(
    'CgVQb2ludBIjCghwb3NpdGlvbhgBIAEoCzIHLlZlY3RvclIIcG9zaXRpb24SJQoJY29udHJvbE'
    'luGAIgASgLMgcuVmVjdG9yUgljb250cm9sSW4SJwoKY29udHJvbE91dBgDIAEoCzIHLlZlY3Rv'
    'clIKY29udHJvbE91dBIeCgp1c2VIZWFkaW5nGAQgASgIUgp1c2VIZWFkaW5nEhgKB2hlYWRpbm'
    'cYBSABKAJSB2hlYWRpbmcSJAoGYWN0aW9uGAYgASgLMgwuUm9ib3RBY3Rpb25SBmFjdGlvbg==');

@$core.Deprecated('Use segmentDescriptor instead')
const Segment$json = {
  '1': 'Segment',
  '2': [
    {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.Point', '10': 'points'},
    {'1': 'maxVelocity', '3': 2, '4': 1, '5': 2, '10': 'maxVelocity'},
    {'1': 'splineType', '3': 3, '4': 1, '5': 14, '6': '.SplineTypes', '10': 'splineType'},
    {'1': 'splineParameters', '3': 4, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
  ],
};

/// Descriptor for `Segment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List segmentDescriptor = $convert.base64Decode(
    'CgdTZWdtZW50Eh4KBnBvaW50cxgBIAMoCzIGLlBvaW50UgZwb2ludHMSIAoLbWF4VmVsb2NpdH'
    'kYAiABKAJSC21heFZlbG9jaXR5EiwKCnNwbGluZVR5cGUYAyABKA4yDC5TcGxpbmVUeXBlc1IK'
    'c3BsaW5lVHlwZRI9ChBzcGxpbmVQYXJhbWV0ZXJzGAQgASgLMhEuU3BsaW5lUGFyYW1ldGVyc1'
    'IQc3BsaW5lUGFyYW1ldGVycw==');

@$core.Deprecated('Use sectionDescriptor instead')
const Section$json = {
  '1': 'Section',
  '2': [
    {'1': 'segments', '3': 1, '4': 3, '5': 11, '6': '.Segment', '10': 'segments'},
  ],
};

/// Descriptor for `Section`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List sectionDescriptor = $convert.base64Decode(
    'CgdTZWN0aW9uEiQKCHNlZ21lbnRzGAEgAygLMgguU2VnbWVudFIIc2VnbWVudHM=');

@$core.Deprecated('Use splineParametersDescriptor instead')
const SplineParameters$json = {
  '1': 'SplineParameters',
  '2': [
    {'1': 'params', '3': 1, '4': 3, '5': 2, '10': 'params'},
  ],
};

/// Descriptor for `SplineParameters`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineParametersDescriptor = $convert.base64Decode(
    'ChBTcGxpbmVQYXJhbWV0ZXJzEhYKBnBhcmFtcxgBIAMoAlIGcGFyYW1z');

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest$json = {
  '1': 'SplineRequest',
  '2': [
    {'1': 'segments', '3': 1, '4': 3, '5': 11, '6': '.Segment', '10': 'segments'},
    {'1': 'splineParameters', '3': 2, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
    {'1': 'evaluatedPointsInterval', '3': 3, '4': 1, '5': 2, '10': 'evaluatedPointsInterval'},
    {'1': 'optimizationParams', '3': 4, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams', '10': 'optimizationParams'},
  ],
  '3': [SplineRequest_OptimizationParams$json],
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams$json = {
  '1': 'OptimizationParams',
  '2': [
    {'1': 'hermite', '3': 5, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Hermite', '10': 'hermite'},
    {'1': 'bezier', '3': 6, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Bezier', '10': 'bezier'},
    {'1': 'polynomial', '3': 7, '4': 1, '5': 11, '6': '.SplineRequest.OptimizationParams.Polynomial', '10': 'polynomial'},
  ],
  '3': [SplineRequest_OptimizationParams_Hermite$json, SplineRequest_OptimizationParams_Bezier$json, SplineRequest_OptimizationParams_Polynomial$json],
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Hermite$json = {
  '1': 'Hermite',
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Bezier$json = {
  '1': 'Bezier',
};

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest_OptimizationParams_Polynomial$json = {
  '1': 'Polynomial',
};

/// Descriptor for `SplineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineRequestDescriptor = $convert.base64Decode(
    'Cg1TcGxpbmVSZXF1ZXN0EiQKCHNlZ21lbnRzGAEgAygLMgguU2VnbWVudFIIc2VnbWVudHMSPQ'
    'oQc3BsaW5lUGFyYW1ldGVycxgCIAEoCzIRLlNwbGluZVBhcmFtZXRlcnNSEHNwbGluZVBhcmFt'
    'ZXRlcnMSOAoXZXZhbHVhdGVkUG9pbnRzSW50ZXJ2YWwYAyABKAJSF2V2YWx1YXRlZFBvaW50c0'
    'ludGVydmFsElEKEm9wdGltaXphdGlvblBhcmFtcxgEIAEoCzIhLlNwbGluZVJlcXVlc3QuT3B0'
    'aW1pemF0aW9uUGFyYW1zUhJvcHRpbWl6YXRpb25QYXJhbXMajAIKEk9wdGltaXphdGlvblBhcm'
    'FtcxJDCgdoZXJtaXRlGAUgASgLMikuU3BsaW5lUmVxdWVzdC5PcHRpbWl6YXRpb25QYXJhbXMu'
    'SGVybWl0ZVIHaGVybWl0ZRJACgZiZXppZXIYBiABKAsyKC5TcGxpbmVSZXF1ZXN0Lk9wdGltaX'
    'phdGlvblBhcmFtcy5CZXppZXJSBmJlemllchJMCgpwb2x5bm9taWFsGAcgASgLMiwuU3BsaW5l'
    'UmVxdWVzdC5PcHRpbWl6YXRpb25QYXJhbXMuUG9seW5vbWlhbFIKcG9seW5vbWlhbBoJCgdIZX'
    'JtaXRlGggKBkJlemllchoMCgpQb2x5bm9taWFs');

@$core.Deprecated('Use splineResponseDescriptor instead')
const SplineResponse$json = {
  '1': 'SplineResponse',
  '2': [
    {'1': 'splineParameters', '3': 1, '4': 1, '5': 11, '6': '.SplineParameters', '10': 'splineParameters'},
    {'1': 'splineType', '3': 2, '4': 1, '5': 14, '6': '.SplineTypes', '10': 'splineType'},
    {'1': 'evaluatedPoints', '3': 3, '4': 3, '5': 11, '6': '.SplineResponse.Point', '10': 'evaluatedPoints'},
  ],
  '3': [SplineResponse_Point$json],
};

@$core.Deprecated('Use splineResponseDescriptor instead')
const SplineResponse_Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'point'},
    {'1': 'segmentIndex', '3': 2, '4': 1, '5': 5, '10': 'segmentIndex'},
  ],
};

/// Descriptor for `SplineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineResponseDescriptor = $convert.base64Decode(
    'Cg5TcGxpbmVSZXNwb25zZRI9ChBzcGxpbmVQYXJhbWV0ZXJzGAEgASgLMhEuU3BsaW5lUGFyYW'
    '1ldGVyc1IQc3BsaW5lUGFyYW1ldGVycxIsCgpzcGxpbmVUeXBlGAIgASgOMgwuU3BsaW5lVHlw'
    'ZXNSCnNwbGluZVR5cGUSPwoPZXZhbHVhdGVkUG9pbnRzGAMgAygLMhUuU3BsaW5lUmVzcG9uc2'
    'UuUG9pbnRSD2V2YWx1YXRlZFBvaW50cxpKCgVQb2ludBIdCgVwb2ludBgBIAEoCzIHLlZlY3Rv'
    'clIFcG9pbnQSIgoMc2VnbWVudEluZGV4GAIgASgFUgxzZWdtZW50SW5kZXg=');

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest$json = {
  '1': 'TrajectoryRequest',
  '2': [
    {'1': 'sections', '3': 1, '4': 3, '5': 11, '6': '.Section', '10': 'sections'},
    {'1': 'driveTrain', '3': 4, '4': 1, '5': 14, '6': '.TrajectoryRequest.DriveTrain', '10': 'driveTrain'},
    {'1': 'swerveRobotParams', '3': 5, '4': 1, '5': 11, '6': '.TrajectoryRequest.SwerveRobotParams', '10': 'swerveRobotParams'},
    {'1': 'tankRobotParams', '3': 6, '4': 1, '5': 11, '6': '.TrajectoryRequest.TankRobotParams', '10': 'tankRobotParams'},
    {'1': 'trajectoryFileName', '3': 7, '4': 1, '5': 9, '10': 'trajectoryFileName'},
  ],
  '3': [TrajectoryRequest_SwerveRobotParams$json, TrajectoryRequest_TankRobotParams$json],
  '4': [TrajectoryRequest_DriveTrain$json],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_SwerveRobotParams$json = {
  '1': 'SwerveRobotParams',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 2, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 2, '10': 'height'},
    {'1': 'maxVelocity', '3': 3, '4': 1, '5': 2, '10': 'maxVelocity'},
    {'1': 'maxAcceleration', '3': 4, '4': 1, '5': 2, '10': 'maxAcceleration'},
    {'1': 'skidAcceleration', '3': 5, '4': 1, '5': 2, '10': 'skidAcceleration'},
    {'1': 'maxJerk', '3': 6, '4': 1, '5': 2, '10': 'maxJerk'},
    {'1': 'cycleTime', '3': 7, '4': 1, '5': 2, '10': 'cycleTime'},
    {'1': 'angularAccelerationPercentage', '3': 8, '4': 1, '5': 2, '10': 'angularAccelerationPercentage'},
  ],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_TankRobotParams$json = {
  '1': 'TankRobotParams',
  '2': [
    {'1': 'width', '3': 1, '4': 1, '5': 2, '10': 'width'},
    {'1': 'height', '3': 2, '4': 1, '5': 2, '10': 'height'},
    {'1': 'maxVelocity', '3': 3, '4': 1, '5': 2, '10': 'maxVelocity'},
    {'1': 'maxAcceleration', '3': 4, '4': 1, '5': 2, '10': 'maxAcceleration'},
    {'1': 'maxJerk', '3': 5, '4': 1, '5': 2, '10': 'maxJerk'},
    {'1': 'cycleTime', '3': 6, '4': 1, '5': 2, '10': 'cycleTime'},
  ],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_DriveTrain$json = {
  '1': 'DriveTrain',
  '2': [
    {'1': 'Swerve', '2': 0},
    {'1': 'Tank', '2': 1},
  ],
};

/// Descriptor for `TrajectoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryRequestDescriptor = $convert.base64Decode(
    'ChFUcmFqZWN0b3J5UmVxdWVzdBIkCghzZWN0aW9ucxgBIAMoCzIILlNlY3Rpb25SCHNlY3Rpb2'
    '5zEj0KCmRyaXZlVHJhaW4YBCABKA4yHS5UcmFqZWN0b3J5UmVxdWVzdC5Ecml2ZVRyYWluUgpk'
    'cml2ZVRyYWluElIKEXN3ZXJ2ZVJvYm90UGFyYW1zGAUgASgLMiQuVHJhamVjdG9yeVJlcXVlc3'
    'QuU3dlcnZlUm9ib3RQYXJhbXNSEXN3ZXJ2ZVJvYm90UGFyYW1zEkwKD3RhbmtSb2JvdFBhcmFt'
    'cxgGIAEoCzIiLlRyYWplY3RvcnlSZXF1ZXN0LlRhbmtSb2JvdFBhcmFtc1IPdGFua1JvYm90UG'
    'FyYW1zEi4KEnRyYWplY3RvcnlGaWxlTmFtZRgHIAEoCVISdHJhamVjdG9yeUZpbGVOYW1lGrcC'
    'ChFTd2VydmVSb2JvdFBhcmFtcxIUCgV3aWR0aBgBIAEoAlIFd2lkdGgSFgoGaGVpZ2h0GAIgAS'
    'gCUgZoZWlnaHQSIAoLbWF4VmVsb2NpdHkYAyABKAJSC21heFZlbG9jaXR5EigKD21heEFjY2Vs'
    'ZXJhdGlvbhgEIAEoAlIPbWF4QWNjZWxlcmF0aW9uEioKEHNraWRBY2NlbGVyYXRpb24YBSABKA'
    'JSEHNraWRBY2NlbGVyYXRpb24SGAoHbWF4SmVyaxgGIAEoAlIHbWF4SmVyaxIcCgljeWNsZVRp'
    'bWUYByABKAJSCWN5Y2xlVGltZRJECh1hbmd1bGFyQWNjZWxlcmF0aW9uUGVyY2VudGFnZRgIIA'
    'EoAlIdYW5ndWxhckFjY2VsZXJhdGlvblBlcmNlbnRhZ2UawwEKD1RhbmtSb2JvdFBhcmFtcxIU'
    'CgV3aWR0aBgBIAEoAlIFd2lkdGgSFgoGaGVpZ2h0GAIgASgCUgZoZWlnaHQSIAoLbWF4VmVsb2'
    'NpdHkYAyABKAJSC21heFZlbG9jaXR5EigKD21heEFjY2VsZXJhdGlvbhgEIAEoAlIPbWF4QWNj'
    'ZWxlcmF0aW9uEhgKB21heEplcmsYBSABKAJSB21heEplcmsSHAoJY3ljbGVUaW1lGAYgASgCUg'
    'ljeWNsZVRpbWUiIgoKRHJpdmVUcmFpbhIKCgZTd2VydmUQABIICgRUYW5rEAE=');

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse$json = {
  '1': 'TrajectoryResponse',
  '2': [
    {'1': 'swervePoints', '3': 1, '4': 3, '5': 11, '6': '.TrajectoryResponse.SwervePoint', '10': 'swervePoints'},
    {'1': 'tankPoints', '3': 2, '4': 3, '5': 11, '6': '.TrajectoryResponse.TankPoint', '10': 'tankPoints'},
  ],
  '3': [TrajectoryResponse_SwervePoint$json, TrajectoryResponse_TankPoint$json],
};

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse_SwervePoint$json = {
  '1': 'SwervePoint',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 2, '10': 'time'},
    {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    {'1': 'velocity', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'velocity'},
    {'1': 'heading', '3': 4, '4': 1, '5': 2, '10': 'heading'},
    {'1': 'angularVelocity', '3': 5, '4': 1, '5': 2, '10': 'angularVelocity'},
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
  ],
};

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse_TankPoint$json = {
  '1': 'TankPoint',
  '2': [
    {'1': 'time', '3': 1, '4': 1, '5': 2, '10': 'time'},
    {'1': 'position', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    {'1': 'rightVelocity', '3': 3, '4': 1, '5': 2, '10': 'rightVelocity'},
    {'1': 'leftVelocity', '3': 4, '4': 1, '5': 2, '10': 'leftVelocity'},
    {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
    {'1': 'action', '3': 6, '4': 1, '5': 9, '10': 'action'},
  ],
};

/// Descriptor for `TrajectoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryResponseDescriptor = $convert.base64Decode(
    'ChJUcmFqZWN0b3J5UmVzcG9uc2USQwoMc3dlcnZlUG9pbnRzGAEgAygLMh8uVHJhamVjdG9yeV'
    'Jlc3BvbnNlLlN3ZXJ2ZVBvaW50Ugxzd2VydmVQb2ludHMSPQoKdGFua1BvaW50cxgCIAMoCzId'
    'LlRyYWplY3RvcnlSZXNwb25zZS5UYW5rUG9pbnRSCnRhbmtQb2ludHMaxwEKC1N3ZXJ2ZVBvaW'
    '50EhIKBHRpbWUYASABKAJSBHRpbWUSIwoIcG9zaXRpb24YAiABKAsyBy5WZWN0b3JSCHBvc2l0'
    'aW9uEiMKCHZlbG9jaXR5GAMgASgLMgcuVmVjdG9yUgh2ZWxvY2l0eRIYCgdoZWFkaW5nGAQgAS'
    'gCUgdoZWFkaW5nEigKD2FuZ3VsYXJWZWxvY2l0eRgFIAEoAlIPYW5ndWxhclZlbG9jaXR5EhYK'
    'BmFjdGlvbhgGIAEoCVIGYWN0aW9uGsABCglUYW5rUG9pbnQSEgoEdGltZRgBIAEoAlIEdGltZR'
    'IjCghwb3NpdGlvbhgCIAEoCzIHLlZlY3RvclIIcG9zaXRpb24SJAoNcmlnaHRWZWxvY2l0eRgD'
    'IAEoAlINcmlnaHRWZWxvY2l0eRIiCgxsZWZ0VmVsb2NpdHkYBCABKAJSDGxlZnRWZWxvY2l0eR'
    'IYCgdoZWFkaW5nGAUgASgCUgdoZWFkaW5nEhYKBmFjdGlvbhgGIAEoCVIGYWN0aW9u');

