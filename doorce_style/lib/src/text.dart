import 'package:doorce_style/src/common.dart';
import 'package:doorce_style/src/style.dart';
import 'package:flutter/material.dart';

enum DoorTextStyle {
  main,
  emph,
  norm,
  reverse,
  title,
  subtitle,
  center,
  centerHighlight,
  error,
  titleBlack,
  label,
  breadcrumbActive,
  breadcrumb, 
  hyperlink
}

class DoorText extends StatelessWidget {
  final String _text;
  final DoorTextStyle _style;

  const DoorText(this._text, this._style, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (_style) {
      case DoorTextStyle.main:
        return Text(
          _text,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            shadows: [
              Shadow(
                color: Colors.grey,
                blurRadius: 2.0,
                offset: Offset(2.0, 2.0),
              )
            ],
            color: DoorColor.darkEmph,
            fontSize: 22,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 1.27,
          ),
        );

      case DoorTextStyle.emph:
        return Text(
          _text,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: DoorColor.greyBlur,
            fontSize: 14,
            fontStyle: FontStyle.italic,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );

      case DoorTextStyle.norm:
        return Text(
          _text,
          maxLines: 50,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: DoorColor.greyBlur,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );

      case DoorTextStyle.hyperlink:
        return Text(
          _text,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            color: DoorColor.darkEmph,
            decoration: TextDecoration.underline,
            decorationColor: DoorColor.darkEmph,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );

      case DoorTextStyle.reverse:
        return Text(
          _text,
          maxLines: 50,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            color: DoorColor.reverse,
            fontSize: 14,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );

      case DoorTextStyle.title:
        return Text(
          _text,
          textAlign: TextAlign.center,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 32,
            color: DoorColor.reverse,
          ),
        );

      case DoorTextStyle.subtitle:
        return Text(
          _text,
          textAlign: TextAlign.start,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 26,
            color: DoorColor.reverse,
          ),
        );

      case DoorTextStyle.center:
        return Text(
          _text,
          textAlign: TextAlign.center,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 1.27,
            color: DoorColor.greyBlur,
          ),
        );

      case DoorTextStyle.centerHighlight:
        return Text(
          _text,
          textAlign: TextAlign.center,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w700,
            height: 1.27,
            color: DoorColor.black,
          ),
        );

      case DoorTextStyle.error:
        return Text(
          _text,
          textAlign: TextAlign.start,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 12,
            color: DoorColor.red,
          ),
        );

      case DoorTextStyle.titleBlack:
        return Text(
          _text,
          textAlign: TextAlign.center,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: DoorColor.greyBlur,
          ),
        );
      case DoorTextStyle.label:
        return Text(
          _text,
          softWrap: true,
          //overflow: TextOverflow.fade,
          style: const TextStyle(
            color: DoorColor.greyBlur,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );
      case DoorTextStyle.breadcrumb:
        return Text(
          _text,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: DoorColor.greyBlur,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );
      case DoorTextStyle.breadcrumbActive:
        return Text(
          _text,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: DoorColor.cyan,
            fontSize: 16,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            height: 1.43,
            letterSpacing: 0.25,
          ),
        );
    }
  }
}

class DoorTextFormField<T extends Object> extends StatelessWidget {
  final TextEditingController? controller;
  final Function(T)? onChanged;
  final FormFieldValidator<String>? validator;
  final T? initialValue;
  final String? hintText;
  final int rows;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final bool isLocation;

  const DoorTextFormField({this.controller, this.onChanged, this.validator,
   this.initialValue, this.hintText, this.rows=1, this.enabled=true, this.autovalidateMode=AutovalidateMode.disabled, this.isLocation=false, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: autovalidateMode,
      initialValue: initialValue?.toString(),
      enabled: enabled,
      maxLines: rows,
      controller: controller,
      onChanged: (value) {
        if (onChanged != null && DoorCommon().isValidType(value, isLocation ? (double, double) : T)) {
          onChanged!(DoorCommon().parseValue(value, isLocation ? (double, double) : T));
        }
      },
      decoration: InputDecoration(
        filled: enabled,
        fillColor: DoorColor.reverse,
        hintText: hintText ?? "Text",
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: DoorColor.darkEmph, width: 2),
        ),
        ),
      validator: (value) {
        if (value == null || value.isEmpty || DoorCommon().isValidType(value, isLocation ? (double, double) : T) ) {
          if (null == validator) return null;
          return validator!(value);
        } else {
          // TODO - fix DateTime error message (this is temp fix)
          return "Invalid type. Expected ${T == DateTime ? 'DateTime' : T.toString()}.";
        }
      },
    );
  }
}