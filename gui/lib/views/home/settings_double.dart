import "package:flutter/material.dart";
import "package:pathfinder/constants.dart";

class SettingsDouble extends StatefulWidget {
  const SettingsDouble({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = "Label",
    this.unitLabel = "m",
    this.allowZero = true,
    this.allowNegative = true,
    this.fractionDigits = 3,
  });

  final String label;
  final double value;
  final void Function(double) onChanged;
  final String unitLabel;
  final int fractionDigits;
  final bool allowZero;
  final bool allowNegative;

  @override
  State<SettingsDouble> createState() => _SettingsDoubleState();
}

class _SettingsDoubleState extends State<SettingsDouble> {
  late String strValue = widget.value.toStringAsFixed(widget.fractionDigits);
  late TextSelection textSelection = TextSelection.fromPosition(
    TextPosition(
      offset: widget.value.toStringAsFixed(widget.fractionDigits).length,
    ),
  );
  late TextEditingController controller = TextEditingController.fromValue(
    TextEditingValue(
      text: strValue,
      selection: textSelection,
    ),
  );
  @override
  Widget build(final BuildContext context) => TextField(
        controller: controller,
        onChanged: (final String newValue) {
          strValue = newValue;
          textSelection = controller.selection;
          final double? doubleValue = double.tryParse(strValue);
          if (doubleValue != null) widget.onChanged(doubleValue);
        },
        decoration: InputDecoration(
          prefixText: "${widget.label}   ",
          suffixText: widget.unitLabel,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
          ),
          fillColor: settingsColor,
          filled: true,
        ),
      );
}
