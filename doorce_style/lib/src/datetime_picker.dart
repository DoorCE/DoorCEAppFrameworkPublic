import 'package:doorce_style/doorce_style.dart';
import 'package:flutter/material.dart';

enum DoorDateTimeMode {
  date,
  time,
  dateTime,
}

class DoorDateTimePicker extends StatelessWidget {
  final DoorDateTimeMode mode;
  final DateTime? initialValue;
  final ValueChanged<DateTime?> onChanged;
  final bool isEnabled;

  const DoorDateTimePicker({
    required this.mode,
    required this.initialValue,
    required this.onChanged,
    this.isEnabled = true,
  });

  Future<void> _pick(BuildContext context) async {
    if (!isEnabled) return;

    switch (mode) {
      case DoorDateTimeMode.date:
        final date = await showDatePicker(
          context: context,
          initialDate: initialValue ?? DateTime.now(),
          firstDate: DateTime(1000),
          lastDate: DateTime(2100),
        );
        if (date != null) onChanged(date);
        break;

      case DoorDateTimeMode.time:
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialValue ?? DateTime.now()),
        );
        if (time != null) {
          final now = initialValue ?? DateTime.now();
          onChanged(DateTime(
            now.year,
            now.month,
            now.day,
            time.hour,
            time.minute,
          ));
        }
        break;

      case DoorDateTimeMode.dateTime:
        final date = await showDatePicker(
          context: context,
          initialDate: initialValue ?? DateTime.now(),
          firstDate: DateTime(1000),
          lastDate: DateTime(2100),
        );
        if (date == null) return;

        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialValue ?? DateTime.now()),
        );
        if (time == null) return;

        onChanged(DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        ));
        break;
    }
  }

  String _format(BuildContext context) {
    if (initialValue == null) return "";

    String two(int n) => n.toString().padLeft(2, '0');
    final d = initialValue!;
    final day = two(d.day);
    final month = two(d.month);
    final year = d.year.toString();
    final hour = two(d.hour);
    final minute = two(d.minute);

    switch (mode) {
      case DoorDateTimeMode.date:
        return "$day.$month.$year";
      case DoorDateTimeMode.time:
        return "$hour:$minute";
      case DoorDateTimeMode.dateTime:
        return "$day.$month.$year $hour:$minute";
    }
  }

  String _hint() {
    switch (mode) {
      case DoorDateTimeMode.date:
        return "dd.mm.yyyy";
      case DoorDateTimeMode.time:
        return "hh:mm";
      case DoorDateTimeMode.dateTime:
        return "dd.mm.yyyy hh:mm";
    }
  }

  Icon _icon() {
    switch (mode) {
      case DoorDateTimeMode.date:
        return const Icon(Icons.calendar_today);
      case DoorDateTimeMode.time:
        return const Icon(Icons.access_time);
      case DoorDateTimeMode.dateTime:
        return const Icon(Icons.event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(initialValue),
      readOnly: true,
      enabled: isEnabled,
      initialValue: _format(context),
      onTap: () => _pick(context),
      decoration: InputDecoration(
        hintText: _hint(),
        border: const OutlineInputBorder(),
        suffixIcon: _icon(),
        filled: isEnabled,
        fillColor: DoorColor.reverse,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: DoorColor.darkEmph, width: 2),
        ),
      ),
    );
  }
}