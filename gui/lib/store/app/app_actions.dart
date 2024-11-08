class TabChangingAction {
  const TabChangingAction();
}

class ChangeCurrentTab extends TabChangingAction {
  const ChangeCurrentTab({
    required this.index,
  });
  final int index;
}

class AddTab extends TabChangingAction {
  const AddTab();
}

class OpenFile {
  OpenFile({
    required this.fileContent,
    required this.fileName,
  });
  final String fileContent;
  final String fileName;
}

class SaveFile {
  SaveFile({
    required this.fileName,
  });
  final String fileName;
}

class NewAuto {
  NewAuto();
}

class RemoveTab extends TabChangingAction {
  const RemoveTab({required this.index});
  final int index;
}
