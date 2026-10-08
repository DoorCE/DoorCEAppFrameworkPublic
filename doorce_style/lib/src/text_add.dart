import 'package:doorce_style/src/button.dart';
import 'package:doorce_style/src/common.dart';
import 'package:doorce_style/src/text.dart';
import 'package:flutter/material.dart';

class DoorTextFormFieldWithAddButton<T extends Object> extends StatefulWidget {
  final List<T> items;
  final bool singleAdd;
  final bool enabled;
  final bool isRequired;
  final void Function(List<T>) onAdded;
  final bool isLocation;
  

  const DoorTextFormFieldWithAddButton({
    super.key,
    required this.items,
    required this.onAdded,
    this.singleAdd = false,
    this.enabled = true,
    this.isRequired = false,
    this.isLocation = false,
  });

  @override
  DoorTextFormFieldWithAddButtonState<T> createState() => DoorTextFormFieldWithAddButtonState<T>();
}

class DoorTextFormFieldWithAddButtonState<T extends Object> extends State<DoorTextFormFieldWithAddButton<T>> {
  final TextEditingController _controller = TextEditingController();
  late List<T> _itemList;

  @override
  void initState() {
    super.initState();
    _itemList = List.from(widget.items);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              DoorTextFormField<T>(
                hintText: T == DateTime ? "dd.mm.yyyy hh:mm" : null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: _controller,
                enabled: widget.enabled,
                isLocation: widget.isLocation,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    return "Unsaved changes. Please click the add button to save.";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),

        /// Add button
        Column(
          children: [
            const SizedBox(height: 4),
            DoorSimpleButtonIcon(
              enabled: widget.enabled,
              "Add",
              Icons.add_circle_outlined,
              () {
                final doc = _controller.text;
                if ((!widget.singleAdd || _itemList.isEmpty) && doc.isNotEmpty && !_itemList.contains(doc) && DoorCommon().isValidType(doc, widget.isLocation ? (double, double) : T)) {
                  setState(() {
                    _itemList.add(DoorCommon().parseValue(doc, widget.isLocation ? (double, double) : T));
                    _controller.clear();
                  });
                    widget.onAdded(_itemList);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}