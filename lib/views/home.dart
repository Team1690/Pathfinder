import 'package:flutter/material.dart';
import 'package:pathfinder/widgets/card.dart';
import 'package:pathfinder/widgets/editor_screen.dart';
import 'package:pathfinder/constants.dart';
import 'package:pathfinder/widgets/tab.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(final BuildContext context) {
    return Scaffold(
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
    );
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
