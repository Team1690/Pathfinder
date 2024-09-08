//
//  Generated code. Do not modify.
//  source: protos/pathfinder_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

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

@$core.Deprecated('Use splinePointDescriptor instead')
const SplinePoint$json = {
  '1': 'SplinePoint',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'point'},
    {'1': 'segmentIndex', '3': 2, '4': 1, '5': 5, '10': 'segmentIndex'},
  ],
};

/// Descriptor for `SplinePoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splinePointDescriptor = $convert.base64Decode(
    'CgtTcGxpbmVQb2ludBIdCgVwb2ludBgBIAEoCzIHLlZlY3RvclIFcG9pbnQSIgoMc2VnbWVudE'
    'luZGV4GAIgASgFUgxzZWdtZW50SW5kZXg=');

@$core.Deprecated('Use swerveRobotParamsDescriptor instead')
const SwerveRobotParams$json = {
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

/// Descriptor for `SwerveRobotParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swerveRobotParamsDescriptor = $convert.base64Decode(
    'ChFTd2VydmVSb2JvdFBhcmFtcxIUCgV3aWR0aBgBIAEoAlIFd2lkdGgSFgoGaGVpZ2h0GAIgAS'
    'gCUgZoZWlnaHQSIAoLbWF4VmVsb2NpdHkYAyABKAJSC21heFZlbG9jaXR5EigKD21heEFjY2Vs'
    'ZXJhdGlvbhgEIAEoAlIPbWF4QWNjZWxlcmF0aW9uEioKEHNraWRBY2NlbGVyYXRpb24YBSABKA'
    'JSEHNraWRBY2NlbGVyYXRpb24SGAoHbWF4SmVyaxgGIAEoAlIHbWF4SmVyaxIcCgljeWNsZVRp'
    'bWUYByABKAJSCWN5Y2xlVGltZRJECh1hbmd1bGFyQWNjZWxlcmF0aW9uUGVyY2VudGFnZRgIIA'
    'EoAlIdYW5ndWxhckFjY2VsZXJhdGlvblBlcmNlbnRhZ2U=');

@$core.Deprecated('Use tankRobotParamsDescriptor instead')
const TankRobotParams$json = {
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

/// Descriptor for `TankRobotParams`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tankRobotParamsDescriptor = $convert.base64Decode(
    'Cg9UYW5rUm9ib3RQYXJhbXMSFAoFd2lkdGgYASABKAJSBXdpZHRoEhYKBmhlaWdodBgCIAEoAl'
    'IGaGVpZ2h0EiAKC21heFZlbG9jaXR5GAMgASgCUgttYXhWZWxvY2l0eRIoCg9tYXhBY2NlbGVy'
    'YXRpb24YBCABKAJSD21heEFjY2VsZXJhdGlvbhIYCgdtYXhKZXJrGAUgASgCUgdtYXhKZXJrEh'
    'wKCWN5Y2xlVGltZRgGIAEoAlIJY3ljbGVUaW1l');

@$core.Deprecated('Use swervePointsDescriptor instead')
const SwervePoints$json = {
  '1': 'SwervePoints',
  '2': [
    {'1': 'swervePoints', '3': 1, '4': 3, '5': 11, '6': '.SwervePoints.SwervePoint', '10': 'swervePoints'},
  ],
  '3': [SwervePoints_SwervePoint$json],
};

@$core.Deprecated('Use swervePointsDescriptor instead')
const SwervePoints_SwervePoint$json = {
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

/// Descriptor for `SwervePoints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List swervePointsDescriptor = $convert.base64Decode(
    'CgxTd2VydmVQb2ludHMSPQoMc3dlcnZlUG9pbnRzGAEgAygLMhkuU3dlcnZlUG9pbnRzLlN3ZX'
    'J2ZVBvaW50Ugxzd2VydmVQb2ludHMaxwEKC1N3ZXJ2ZVBvaW50EhIKBHRpbWUYASABKAJSBHRp'
    'bWUSIwoIcG9zaXRpb24YAiABKAsyBy5WZWN0b3JSCHBvc2l0aW9uEiMKCHZlbG9jaXR5GAMgAS'
    'gLMgcuVmVjdG9yUgh2ZWxvY2l0eRIYCgdoZWFkaW5nGAQgASgCUgdoZWFkaW5nEigKD2FuZ3Vs'
    'YXJWZWxvY2l0eRgFIAEoAlIPYW5ndWxhclZlbG9jaXR5EhYKBmFjdGlvbhgGIAEoCVIGYWN0aW'
    '9u');

@$core.Deprecated('Use tankPointsDescriptor instead')
const TankPoints$json = {
  '1': 'TankPoints',
  '2': [
    {'1': 'tankPoints', '3': 1, '4': 3, '5': 11, '6': '.TankPoints.TankPoint', '10': 'tankPoints'},
  ],
  '3': [TankPoints_TankPoint$json],
};

@$core.Deprecated('Use tankPointsDescriptor instead')
const TankPoints_TankPoint$json = {
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

/// Descriptor for `TankPoints`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List tankPointsDescriptor = $convert.base64Decode(
    'CgpUYW5rUG9pbnRzEjUKCnRhbmtQb2ludHMYASADKAsyFS5UYW5rUG9pbnRzLlRhbmtQb2ludF'
    'IKdGFua1BvaW50cxrAAQoJVGFua1BvaW50EhIKBHRpbWUYASABKAJSBHRpbWUSIwoIcG9zaXRp'
    'b24YAiABKAsyBy5WZWN0b3JSCHBvc2l0aW9uEiQKDXJpZ2h0VmVsb2NpdHkYAyABKAJSDXJpZ2'
    'h0VmVsb2NpdHkSIgoMbGVmdFZlbG9jaXR5GAQgASgCUgxsZWZ0VmVsb2NpdHkSGAoHaGVhZGlu'
    'ZxgFIAEoAlIHaGVhZGluZxIWCgZhY3Rpb24YBiABKAlSBmFjdGlvbg==');

@$core.Deprecated('Use pathPointDescriptor instead')
const PathPoint$json = {
  '1': 'PathPoint',
  '2': [
    {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    {'1': 'controlIn', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'controlIn'},
    {'1': 'controlOut', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'controlOut'},
    {'1': 'useHeading', '3': 4, '4': 1, '5': 8, '10': 'useHeading'},
    {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
    {'1': 'action', '3': 6, '4': 1, '5': 11, '6': '.RobotAction', '10': 'action'},
  ],
};

/// Descriptor for `PathPoint`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathPointDescriptor = $convert.base64Decode(
    'CglQYXRoUG9pbnQSIwoIcG9zaXRpb24YASABKAsyBy5WZWN0b3JSCHBvc2l0aW9uEiUKCWNvbn'
    'Ryb2xJbhgCIAEoCzIHLlZlY3RvclIJY29udHJvbEluEicKCmNvbnRyb2xPdXQYAyABKAsyBy5W'
    'ZWN0b3JSCmNvbnRyb2xPdXQSHgoKdXNlSGVhZGluZxgEIAEoCFIKdXNlSGVhZGluZxIYCgdoZW'
    'FkaW5nGAUgASgCUgdoZWFkaW5nEiQKBmFjdGlvbhgGIAEoCzIMLlJvYm90QWN0aW9uUgZhY3Rp'
    'b24=');

@$core.Deprecated('Use segmentDescriptor instead')
const Segment$json = {
  '1': 'Segment',
  '2': [
    {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.PathPoint', '10': 'points'},
    {'1': 'maxVelocity', '3': 2, '4': 1, '5': 2, '10': 'maxVelocity'},
  ],
};

/// Descriptor for `Segment`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List segmentDescriptor = $convert.base64Decode(
    'CgdTZWdtZW50EiIKBnBvaW50cxgBIAMoCzIKLlBhdGhQb2ludFIGcG9pbnRzEiAKC21heFZlbG'
    '9jaXR5GAIgASgCUgttYXhWZWxvY2l0eQ==');

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

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest$json = {
  '1': 'TrajectoryRequest',
  '2': [
    {'1': 'sections', '3': 1, '4': 3, '5': 11, '6': '.Section', '10': 'sections'},
    {'1': 'swerveParams', '3': 2, '4': 1, '5': 11, '6': '.SwerveRobotParams', '9': 0, '10': 'swerveParams'},
    {'1': 'tankParams', '3': 3, '4': 1, '5': 11, '6': '.TankRobotParams', '9': 0, '10': 'tankParams'},
    {'1': 'fileName', '3': 4, '4': 1, '5': 9, '10': 'fileName'},
  ],
  '8': [
    {'1': 'robotParams'},
  ],
};

/// Descriptor for `TrajectoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryRequestDescriptor = $convert.base64Decode(
    'ChFUcmFqZWN0b3J5UmVxdWVzdBIkCghzZWN0aW9ucxgBIAMoCzIILlNlY3Rpb25SCHNlY3Rpb2'
    '5zEjgKDHN3ZXJ2ZVBhcmFtcxgCIAEoCzISLlN3ZXJ2ZVJvYm90UGFyYW1zSABSDHN3ZXJ2ZVBh'
    'cmFtcxIyCgp0YW5rUGFyYW1zGAMgASgLMhAuVGFua1JvYm90UGFyYW1zSABSCnRhbmtQYXJhbX'
    'MSGgoIZmlsZU5hbWUYBCABKAlSCGZpbGVOYW1lQg0KC3JvYm90UGFyYW1z');

@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse$json = {
  '1': 'TrajectoryResponse',
  '2': [
    {'1': 'swervePoints', '3': 1, '4': 1, '5': 11, '6': '.SwervePoints', '9': 0, '10': 'swervePoints'},
    {'1': 'tankPoints', '3': 2, '4': 1, '5': 11, '6': '.TankPoints', '9': 0, '10': 'tankPoints'},
  ],
  '8': [
    {'1': 'points'},
  ],
};

/// Descriptor for `TrajectoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryResponseDescriptor = $convert.base64Decode(
    'ChJUcmFqZWN0b3J5UmVzcG9uc2USMwoMc3dlcnZlUG9pbnRzGAEgASgLMg0uU3dlcnZlUG9pbn'
    'RzSABSDHN3ZXJ2ZVBvaW50cxItCgp0YW5rUG9pbnRzGAIgASgLMgsuVGFua1BvaW50c0gAUgp0'
    'YW5rUG9pbnRzQggKBnBvaW50cw==');

@$core.Deprecated('Use splineRequestDescriptor instead')
const SplineRequest$json = {
  '1': 'SplineRequest',
  '2': [
    {'1': 'segments', '3': 1, '4': 3, '5': 11, '6': '.Segment', '10': 'segments'},
    {'1': 'pointInterval', '3': 2, '4': 1, '5': 2, '10': 'pointInterval'},
  ],
};

/// Descriptor for `SplineRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineRequestDescriptor = $convert.base64Decode(
    'Cg1TcGxpbmVSZXF1ZXN0EiQKCHNlZ21lbnRzGAEgAygLMgguU2VnbWVudFIIc2VnbWVudHMSJA'
    'oNcG9pbnRJbnRlcnZhbBgCIAEoAlINcG9pbnRJbnRlcnZhbA==');

@$core.Deprecated('Use splineResponseDescriptor instead')
const SplineResponse$json = {
  '1': 'SplineResponse',
  '2': [
    {'1': 'splinePoints', '3': 1, '4': 3, '5': 11, '6': '.SplinePoint', '10': 'splinePoints'},
  ],
};

/// Descriptor for `SplineResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List splineResponseDescriptor = $convert.base64Decode(
    'Cg5TcGxpbmVSZXNwb25zZRIwCgxzcGxpbmVQb2ludHMYASADKAsyDC5TcGxpbmVQb2ludFIMc3'
    'BsaW5lUG9pbnRz');

