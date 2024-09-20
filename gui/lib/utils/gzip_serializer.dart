import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:redux_persist/redux_persist.dart";

class GzipSerializer<T> implements StateSerializer<T> {
  GzipSerializer(this.decoder);

  /// Turns the dynamic [json] (can be null) to [T]
  final T? Function(dynamic json) decoder;

  @override
  T? decode(final Uint8List? data) => decoder(
        data != null
            ? json.decode(String.fromCharCodes(gzip.decode(data)))
            : null,
      );

  @override
  Uint8List? encode(final T state) {
    if (state == null) {
      return null;
    }

    return Uint8List.fromList(
      gzip.encode(stringToUint8List(json.encode(state))!),
    );
  }
}
