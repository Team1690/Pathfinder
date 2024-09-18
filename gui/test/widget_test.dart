import "dart:io";

import "package:pathfinder/store/app/app_state.dart";
import "package:redux_persist/redux_persist.dart";

void main() async {
  final persistor = Persistor(
    storage: FileStorage(File("ddd.json")),
    serializer: JsonSerializer(AppState.fromJson),
  );
  final state = (await persistor.load()) ?? AppState.initial();
  final dynamic jsony = state.toJson();
  print(jsony);
  print("***********************************");
  final jsonstate = AppState.fromJson(jsony);
  print(jsonstate.toJson());
}
