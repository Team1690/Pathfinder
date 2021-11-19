///
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
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
@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest$json = const {
  '1': 'TrajectoryRequest',
  '2': const [
    const {'1': 'segments', '3': 1, '4': 3, '5': 11, '6': '.TrajectoryRequest.Segment', '10': 'segments'},
  ],
  '3': const [TrajectoryRequest_Point$json, TrajectoryRequest_Segment$json],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_Point$json = const {
  '1': 'Point',
  '2': const [
    const {'1': 'position', '3': 1, '4': 1, '5': 11, '6': '.Vector', '10': 'position'},
    const {'1': 'controlIn', '3': 2, '4': 1, '5': 11, '6': '.Vector', '10': 'controlIn'},
    const {'1': 'controlOut', '3': 3, '4': 1, '5': 11, '6': '.Vector', '10': 'controlOut'},
    const {'1': 'useHeading', '3': 4, '4': 1, '5': 8, '10': 'useHeading'},
    const {'1': 'heading', '3': 5, '4': 1, '5': 2, '10': 'heading'},
  ],
};

@$core.Deprecated('Use trajectoryRequestDescriptor instead')
const TrajectoryRequest_Segment$json = const {
  '1': 'Segment',
  '2': const [
    const {'1': 'points', '3': 1, '4': 3, '5': 11, '6': '.TrajectoryRequest.Point', '10': 'points'},
  ],
};

/// Descriptor for `TrajectoryRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryRequestDescriptor = $convert.base64Decode('ChFUcmFqZWN0b3J5UmVxdWVzdBI2CghzZWdtZW50cxgBIAMoCzIaLlRyYWplY3RvcnlSZXF1ZXN0LlNlZ21lbnRSCHNlZ21lbnRzGrYBCgVQb2ludBIjCghwb3NpdGlvbhgBIAEoCzIHLlZlY3RvclIIcG9zaXRpb24SJQoJY29udHJvbEluGAIgASgLMgcuVmVjdG9yUgljb250cm9sSW4SJwoKY29udHJvbE91dBgDIAEoCzIHLlZlY3RvclIKY29udHJvbE91dBIeCgp1c2VIZWFkaW5nGAQgASgIUgp1c2VIZWFkaW5nEhgKB2hlYWRpbmcYBSABKAJSB2hlYWRpbmcaOwoHU2VnbWVudBIwCgZwb2ludHMYASADKAsyGC5UcmFqZWN0b3J5UmVxdWVzdC5Qb2ludFIGcG9pbnRz');
@$core.Deprecated('Use trajectoryResponseDescriptor instead')
const TrajectoryResponse$json = const {
  '1': 'TrajectoryResponse',
};

/// Descriptor for `TrajectoryResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List trajectoryResponseDescriptor = $convert.base64Decode('ChJUcmFqZWN0b3J5UmVzcG9uc2U=');
