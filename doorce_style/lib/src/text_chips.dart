import 'package:doorce_style/src/style.dart';
import 'package:doorce_style/src/text.dart';
import 'package:doorce_style/src/text_add.dart';
import 'package:flutter/material.dart';

class DoorTextFormFieldWithChips<T extends Object> extends StatefulWidget {
  final List<T>? items;
  final bool enabled;
  final bool isRequired;
  final void Function(List<T>) onChipAddedOrRemoved;
  final bool isLocation;
  

  const DoorTextFormFieldWithChips({
    super.key,
    required this.items,
    required this.onChipAddedOrRemoved,
    this.enabled = true,
    this.isRequired = false,
    this.isLocation = false,
  });

  @override
  DoorTextFormFieldWithChipsState<T> createState() => DoorTextFormFieldWithChipsState<T>();
}

class DoorTextFormFieldWithChipsState<T extends Object> extends State<DoorTextFormFieldWithChips<T>> {
  late List<T> _itemList;

  @override
  void initState() {
    super.initState();
    _itemList = List.from(widget.items ?? []);
  }

  @override
  Widget build(BuildContext context) {
  return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Left column with text field
        Flexible(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoorTextFormFieldWithAddButton<T>(
                items: _itemList,
                onAdded: (newList) {
                  setState(() {
                    _itemList = newList;
                  });
                  widget.onChipAddedOrRemoved(_itemList);
                },
                enabled: widget.enabled,
                isRequired: widget.isRequired,
                isLocation: widget.isLocation,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        /// Display of existing chips
        Flexible(
          flex: 8,
          child: Column(
            children: [
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _itemList.map((item) {
                  return InputChip(
                    isEnabled: widget.enabled,
                    backgroundColor: DoorColor.lightEmph,
                    side: const BorderSide(color: DoorColor.darkEmph),
                    label: DoorText(item.toString(), DoorTextStyle.norm),
                    onDeleted: () {
                          setState(() {
                            _itemList.remove(item);
                          });
                          widget.onChipAddedOrRemoved(_itemList);
                        } 
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}