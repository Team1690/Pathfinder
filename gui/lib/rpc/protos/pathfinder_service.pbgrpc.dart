//
//  Generated code. Do not modify.
//  source: protos/pathfinder_service.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'pathfinder_service.pb.dart' as $0;

export 'pathfinder_service.pb.dart';

@$pb.GrpcServiceName('PathFinder')
class PathFinderClient extends $grpc.Client {
  static final _$calculateTrajectory = $grpc.ClientMethod<$0.TrajectoryRequest, $0.TrajectoryResponse>(
      '/PathFinder/CalculateTrajectory',
      ($0.TrajectoryRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.TrajectoryResponse.fromBuffer(value));
  static final _$calculateSplinePoints = $grpc.ClientMethod<$0.SplineRequest, $0.SplineResponse>(
      '/PathFinder/CalculateSplinePoints',
      ($0.SplineRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.SplineResponse.fromBuffer(value));
  static final _$optimizePath = $grpc.ClientMethod<$0.PathOptimizationRequest, $0.PathModel>(
      '/PathFinder/OptimizePath',
      ($0.PathOptimizationRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.PathModel.fromBuffer(value));

  PathFinderClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options,
        interceptors: interceptors);

  $grpc.ResponseFuture<$0.TrajectoryResponse> calculateTrajectory($0.TrajectoryRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$calculateTrajectory, request, options: options);
  }

  $grpc.ResponseFuture<$0.SplineResponse> calculateSplinePoints($0.SplineRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$calculateSplinePoints, request, options: options);
  }

  $grpc.ResponseStream<$0.PathModel> optimizePath($0.PathOptimizationRequest request, {$grpc.CallOptions? options}) {
    return $createStreamingCall(_$optimizePath, $async.Stream.fromIterable([request]), options: options);
  }
}

@$pb.GrpcServiceName('PathFinder')
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
    $addMethod($grpc.ServiceMethod<$0.PathOptimizationRequest, $0.PathModel>(
        'OptimizePath',
        optimizePath_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.PathOptimizationRequest.fromBuffer(value),
        ($0.PathModel value) => value.writeToBuffer()));
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory_Pre($grpc.ServiceCall call, $async.Future<$0.TrajectoryRequest> request) async {
    return calculateTrajectory(call, await request);
  }

  $async.Future<$0.SplineResponse> calculateSplinePoints_Pre($grpc.ServiceCall call, $async.Future<$0.SplineRequest> request) async {
    return calculateSplinePoints(call, await request);
  }

  $async.Stream<$0.PathModel> optimizePath_Pre($grpc.ServiceCall call, $async.Future<$0.PathOptimizationRequest> request) async* {
    yield* optimizePath(call, await request);
  }

  $async.Future<$0.TrajectoryResponse> calculateTrajectory($grpc.ServiceCall call, $0.TrajectoryRequest request);
  $async.Future<$0.SplineResponse> calculateSplinePoints($grpc.ServiceCall call, $0.SplineRequest request);
  $async.Stream<$0.PathModel> optimizePath($grpc.ServiceCall call, $0.PathOptimizationRequest request);
}
