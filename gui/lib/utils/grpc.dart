import "package:grpc/grpc.dart";

class GrpcClientSingleton {
  factory GrpcClientSingleton() => _singleton;

  GrpcClientSingleton._internal() {
    client = ClientChannel(
      "localhost",
      port: 3000,
      options: const ChannelOptions(
        credentials: ChannelCredentials.insecure(),
        idleTimeout: Duration(minutes: 1),
      ),
    );
  }
  late ClientChannel client;

  static final GrpcClientSingleton _singleton = GrpcClientSingleton._internal();
}
