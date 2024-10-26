import 'dart:io';

const String _guiExecutableName = "pathfinder_gui.exe";
const String _algorithmExecutableName = "pathfinder_algorithm.exe";

void main(List<String> args) async {
  Process algorithmProcess = await startAlgorithm();
  if (!(await isProcessRunning(_guiExecutableName))) {
    final String? fileName = args.isNotEmpty ? args[0] : null;
    await startGUI(fileName);
  }
  //TODO: if multiple instances of the algorithm process are running close them
  while (true) {
    if (!(await isProcessRunning(_guiExecutableName)) &&
        (await isProcessRunning(_algorithmExecutableName))) {
      Process.killPid(algorithmProcess.pid);
      break;
    }
    if ((await isProcessRunning(_guiExecutableName)) &&
        !(await isProcessRunning(_algorithmExecutableName))) {
      algorithmProcess = await startAlgorithm();
    }
    sleep(Duration(milliseconds: 500));
  }
}

Future<Process> startGUI([String? filePath]) async =>
    Process.start(_guiExecutableName, [if (filePath != null) filePath]);
Future<Process> startAlgorithm() async =>
    Process.start(_algorithmExecutableName, <String>[]);

Future<bool> isProcessRunning(String processName) async {
  // Run the tasklist command (only works on windows, you need ps for command for linux/macos)
  ProcessResult result = await Process.run('tasklist', []);

  // Check if the process name is in the output
  String output = result.stdout as String;
  return output.contains(processName);
}
