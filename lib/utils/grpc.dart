import 'package:grpc/grpc.dart';

class GrpcClientSingleton {
  late ClientChannel client;

  static final GrpcClientSingleton _singleton = GrpcClientSingleton._internal();

  factory GrpcClientSingleton() => _singleton;

  GrpcClientSingleton._internal() {
    client = ClientChannel("localhost",
        port: 3000,
        options: ChannelOptions(
          credentials: ChannelCredentials.insecure(),
          idleTimeout: Duration(minutes: 1),
        ));
  }
}
