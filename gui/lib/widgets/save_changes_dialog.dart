import 'package:flutter/material.dart';

showAlertDialog(
  BuildContext context,
  Function() onDiscard,
  Function() onSave,
  Function() onCancel,
) {
  final wrapWithPop = (Function() fn) => () {
        Navigator.pop(context);
        fn();
      };

  // set up the button
  Widget discardButton = TextButton(
    child: Text("Discard"),
    onPressed: wrapWithPop(onDiscard),
  );
  Widget saveButton = TextButton(
    child: Text("Save"),
    onPressed: wrapWithPop(onSave),
  );
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: wrapWithPop(onCancel),
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirm new auto"),
    content: Text("You have made changes, do you wish to discard them?"),
    actions: [
      cancelButton,
      discardButton,
      saveButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
