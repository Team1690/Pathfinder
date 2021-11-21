import 'package:flutter/material.dart';
import 'package:pathfinder/card.dart';
import 'package:pathfinder/editor_screen.dart';
import 'package:pathfinder/path_editor/path_editor.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/tab.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        title: 'Orbit Pathfinder',
        home: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: secondary,
                  child: Row(
                    children: [
                      BroswerTab(
                        name: 'TEST',
                        activated: false,
                      ),
                      BroswerTab(
                        name: 'TEST',
                        activated: true,
                      ),
                    ],
                  ),
                ),
                Expanded(child: EditorScreen()),
                // PathEditor(),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(defaultPadding),
                //     child: Row(
                //       children: [
                //         optimizeAndGenerateCard(),
                //         const SizedBox(width: defaultPadding),
                //         pointPropertiesCard(),
                //         const SizedBox(width: defaultPadding),
                //         Expanded(
                //           flex: 2,
                //           child: PropertiesCard(
                //             body: Container(),
                //           ),
                //         ),
                //         const SizedBox(width: defaultPadding),
                //         fileManagementCard(),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

  Widget pointPropertiesCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    // Text("Position: "),
                    // TextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget optimizeAndGenerateCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 2 * defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Generate")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Optimize")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget fileManagementCard() {
    return Expanded(
      flex: 2,
      child: PropertiesCard(
        body: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: 2 * defaultPadding),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Import")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Export")),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Center(child: Text("Upload")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
