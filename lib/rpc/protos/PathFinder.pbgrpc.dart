///
//  Generated code. Do not modify.
//  source: protos/PathFinder.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'PathFinder.pb.dart' as $0;
export 'PathFinder.pb.dart';

class PathFinderClient extends $grpc.Client {
  static final _$calculateTrajectory =
      $grpc.ClientMethod<$0.TrajectoryRequest, $0.TrajectoryResponse>(
          '/PathFinder/CalculateTrajectory',
          ($0.TrajectoryRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.TrajectoryResponse.fromBuffer(value));

  PathFinderClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.TrajectoryResponse> calculateTrajectory(
      $0.TrajectoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$calculateTrajectory, request, options: options);
  }
}

abstract class PathFinderServiceBase extends $grpc.Service {
  $core.String get $name => 'PathFinder';

  PathFinderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.TrajectoryRequest, $0.TrajectoryResponse>(
        'CalculateTrajectory',
        calculateTrajectory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.TrajectoryRequest.fromBuffer(value),
        ($0.TrajectoryResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.TrajectoryRequest> request) async {
    return calculateTrajectory(call, await request);
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory(
      $grpc.ServiceCall call, $0.TrajectoryRequest request);
}
