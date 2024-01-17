class ChangeCurrentTab {
  const ChangeCurrentTab({
    required this.index,
  });
  final int index;
}

class AddTab {
  const AddTab();
}

class RemoveTab {
  const RemoveTab({required this.index});
  final int index;
}
