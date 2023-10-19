import "dart:io";

import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:pathfinder/main.dart";

void sendToRobot(final BuildContext context) => showDialog(
      context: context,
      builder: (final BuildContext context) {
        String ip = "10.16.90.2";
        bool changeToCable = true;
        String filePath = store.state.tabState.ui.autoFileName;
        String errorMessage = "";
        bool overwriteFile = true;
        final TextEditingController ipController =
            TextEditingController(text: ip);
        final TextEditingController filePathController =
            TextEditingController(text: filePath);
        bool loading = false;
        return StatefulBuilder(
          builder: (
            final BuildContext context,
            final void Function(void Function()) setState,
          ) =>
              AlertDialog(
            title: const Text("Send Auto File To Robot"),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  if (loading) {
                    return;
                  }
                  setState(() {
                    loading = true;
                  });
                  if (!await File(filePath).exists()) {
                    setState(() {
                      errorMessage = "Please save an auto file";
                      loading = false;
                    });
                    return;
                  }
                  if (!overwriteFile && await File(filePath).exists()) {
                    setState(() {
                      errorMessage = "That file already exists";
                      loading = false;
                    });
                    return;
                  }
                  try {
                    Uri.parseIPv4Address(ip);
                    setState(() {
                      errorMessage = "";
                    });
                  } on FormatException {
                    setState(() {
                      errorMessage = "Invalid ip";
                      loading = false;
                    });
                    return;
                  }

                  if (!filePath.endsWith(".auto")) {
                    setState(() {
                      filePath = "$filePath.auto";
                    });
                  }
                  final Directory directoryOfFile =
                      Directory(dirname(filePath));
                  if (!(await directoryOfFile.exists())) {
                    await directoryOfFile.create(recursive: true);
                  }
                  final ProcessResult res = await Process.run(
                    "scp",
                    <String>[
                      "-o",
                      "ConnectTimeout=5",
                      "-o",
                      "StrictHostKeyChecking=no",
                      filePath,
                      "lvuser@$ip:~/Profiles/",
                    ],
                  );
                  setState(() {
                    if (res.exitCode != 0) {
                      errorMessage = res.stderr.toString();
                    }
                    loading = false;
                  });
                  return;
                },
                child: const Text("Send To robot"),
              ),
            ],
            content: Stack(
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: ipController,
                            onChanged: (final String newIp) {
                              setState(() {
                                ip = newIp;
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              changeToCable = !changeToCable;
                              ip = changeToCable ? "10.16.90.2" : "127.22.11.2";
                            });
                            ipController.text = ip;
                          },
                          icon: Icon(changeToCable ? Icons.cable : Icons.wifi),
                        ),
                      ],
                    ),
                    TextField(
                      controller: filePathController,
                      decoration:
                          const InputDecoration(hintText: "Output directory"),
                      onChanged: (final String text) {
                        filePath = text;
                      },
                    ),
                    if (errorMessage.isNotEmpty)
                      Row(
                        children: <Widget>[
                          Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                errorMessage = "";
                              });
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                    Row(
                      children: <Widget>[
                        const Text("Overwrite file:"),
                        Switch(
                          value: overwriteFile,
                          onChanged: (final bool value) {
                            setState(() {
                              overwriteFile = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                if (loading) const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
