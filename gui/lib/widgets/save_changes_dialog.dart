import "package:flutter/material.dart";

void showAlertDialog(
  final BuildContext context,
  final Function() onDiscard,
  final Function() onSave,
  final Function() onCancel,
) {
  final void Function() Function(Function() fn) wrapWithPop =
      (final void Function() fn) => () {
            Navigator.pop(context);
            fn();
          };

  // set up the button
  final Widget discardButton = TextButton(
    child: const Text("Discard"),
    onPressed: wrapWithPop(onDiscard),
  );
  final Widget saveButton = TextButton(
    child: const Text("Save"),
    onPressed: wrapWithPop(onSave),
  );
  final Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: wrapWithPop(onCancel),
  );

  // set up the AlertDialog
  final AlertDialog alert = AlertDialog(
    title: const Text("Confirm new auto"),
    content: const Text("You have made changes, do you wish to discard them?"),
    actions: <Widget>[
      cancelButton,
      discardButton,
      saveButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (final BuildContext context) => alert,
  );
}
