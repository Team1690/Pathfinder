// import "package:pathfinder/store/app/app_state.dart";
// import "package:redux_persist/redux_persist.dart";
// import "package:redux_persist_flutter/redux_persist_flutter.dart";

// void main() async {
//   final Persistor<AppState> persistor = Persistor<AppState>(
//     storage: FlutterStorage(key: "testing"),
//     serializer: JsonSerializer<AppState>(AppState.fromJson),
//     throttleDuration: null,
//   );
//   final AppState state = (await persistor.load()) ?? AppState.initial();
//   final dynamic jsony = state.toJson();
//   print(jsony);
//   print("***********************************");
//   final AppState jsonstate = AppState.fromJson(jsony);
//   print(jsonstate.toJson());
// }
import "package:flutter_test/flutter_test.dart";

void main() {
  test("Add two numbers", () {
    expect(
      5 + 5,
      equals(10),
    );
  });
}
