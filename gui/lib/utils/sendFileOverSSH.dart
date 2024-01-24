import "dart:io";

import "package:flutter/material.dart";
import "package:orbit_standard_library/orbit_standard_library.dart";
import "package:pathfinder/main.dart";

void sendToRobot(final BuildContext context) => showDialog(
      context: context,
      builder: (final BuildContext context) {
        String ip = "10.16.90.2";
        String filePath =
            "./out/${store.state.tabState[store.state.currentTabIndex].ui.trajectoryFileName}.csv";
        String errorMessage = "";
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
            title: const Text("Send Trajectory File To Robot"),
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
                      errorMessage = "Please save a trajectory file";
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

                  if (!filePath.endsWith(".csv")) {
                    setState(() {
                      filePath = "$filePath.csv";
                    });
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
                    IPTextbox(
                      controller: ipController,
                      onChanged: () {
                        ip = ipController.text;
                      },
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
                  ],
                ),
                if (loading) const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
