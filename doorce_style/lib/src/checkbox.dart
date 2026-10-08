import 'package:doorce_style/doorce_style.dart';
import 'package:flutter/material.dart';


class DoorCheckbox extends StatefulWidget {
  final bool? value;
  final void Function(bool) onChanged;
  final bool isEnabled;

  const DoorCheckbox({
    required this.value,
    required this.onChanged,
    this.isEnabled = true,
  });

  @override
  State<DoorCheckbox> createState() => _DoorCheckboxState();
}

class _DoorCheckboxState extends State<DoorCheckbox> {
  late bool? _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }
  
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      tristate: true,
      value: _currentValue,
      onChanged: widget.isEnabled
        ? (bool? value) {
            setState(() {
              _currentValue = value;
            });
            if (value != null) {
              widget.onChanged(value);
            }
          }
        : null,
      activeColor: DoorColor.darkEmph,
    );
  }
}