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
  static final _$greet = $grpc.ClientMethod<$0.Person, $0.GreetResponse>(
      '/PathFinder/Greet',
      ($0.Person value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.GreetResponse.fromBuffer(value));

  PathFinderClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.GreetResponse> greet($0.Person request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$greet, request, options: options);
  }
}

abstract class PathFinderServiceBase extends $grpc.Service {
  $core.String get $name => 'PathFinder';

  PathFinderServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Person, $0.GreetResponse>(
        'Greet',
        greet_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Person.fromBuffer(value),
        ($0.GreetResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.GreetResponse> greet_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Person> request) async {
    return greet(call, await request);
  }

  $async.Future<$0.GreetResponse> greet(
      $grpc.ServiceCall call, $0.Person request);
}
