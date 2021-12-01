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
  static final _$calculateSplinePoints =
      $grpc.ClientMethod<$0.SplineRequest, $0.SplineResponse>(
          '/PathFinder/CalculateSplinePoints',
          ($0.SplineRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.SplineResponse.fromBuffer(value));

  PathFinderClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.TrajectoryResponse> calculateTrajectory(
      $0.TrajectoryRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$calculateTrajectory, request, options: options);
  }

  $grpc.ResponseFuture<$0.SplineResponse> calculateSplinePoints(
      $0.SplineRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$calculateSplinePoints, request, options: options);
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
    $addMethod($grpc.ServiceMethod<$0.SplineRequest, $0.SplineResponse>(
        'CalculateSplinePoints',
        calculateSplinePoints_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SplineRequest.fromBuffer(value),
        ($0.SplineResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.TrajectoryRequest> request) async {
    return calculateTrajectory(call, await request);
  }

  $async.Future<$0.SplineResponse> calculateSplinePoints_Pre(
      $grpc.ServiceCall call, $async.Future<$0.SplineRequest> request) async {
    return calculateSplinePoints(call, await request);
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory(
      $grpc.ServiceCall call, $0.TrajectoryRequest request);
  $async.Future<$0.SplineResponse> calculateSplinePoints(
      $grpc.ServiceCall call, $0.SplineRequest request);
}
