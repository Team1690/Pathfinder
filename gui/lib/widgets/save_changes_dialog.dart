import "package:flutter/material.dart";

//TODO: nice
void showAlertDialog(
  final BuildContext context,
  final Function() onDiscard,
  final Function() onSave,
  final Function() onCancel,
  final String title,
  final String content,
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
    title: Text(title),
    content: Text(content),
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
