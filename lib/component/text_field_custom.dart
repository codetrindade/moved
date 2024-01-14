import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movemedriver/theme.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focus;
  final FocusNode nextFocus;
  final String label;
  final TextInputType keyBoardType;
  final bool obscureText;
  final TextAlign textAlign;
  final bool enabled;
  final TextInputAction action;
  final int maxLength;
  final TextCapitalization capitalization;
  final Widget suffix;
  final Widget suffixWidget;
  final VoidCallback onSubmitted;
  final bool isDecorationDefault;
  final ValueChanged<String> onChanged;

  TextFieldCustom(
      {@required this.controller,
      @required this.label,
      this.focus,
      this.nextFocus,
      this.suffixWidget,
      this.action = TextInputAction.next,
      this.keyBoardType = TextInputType.text,
      this.textAlign = TextAlign.left,
      this.obscureText = false,
      this.maxLength,
      this.suffix,
      this.onChanged,
      this.onSubmitted,
      this.capitalization = TextCapitalization.sentences,
      this.enabled = true,
      this.isDecorationDefault = true});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        focusNode: focus,
        enableSuggestions: false,
        onSubmitted: (String a) {
          if (onSubmitted != null) onSubmitted();
          if (nextFocus != null) FocusScope.of(context).requestFocus(nextFocus);
        },
        style: this.isDecorationDefault
            ? AppTextStyle.textBlueLightExtraSmall
            : TextStyle(fontSize: AppSizes.fontMedium),
        keyboardType: keyBoardType,
        textInputAction: action,
        textAlign: textAlign,
        enabled: enabled,
        onChanged: onChanged,
        inputFormatters: maxLength == null ? [] : [LengthLimitingTextInputFormatter(maxLength)],
        obscureText: obscureText,
        textCapitalization: capitalization,
        decoration: InputDecoration(
          contentPadding: AppSizes.inputPadding,
          labelText: label,
          suffixIcon: suffix,
          suffix: suffixWidget,
          labelStyle: AppTextStyle.textBlueLightExtraSmall,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.colorBlueLight, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(25))),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.colorBlueLight, width: 0.0),
              borderRadius: BorderRadius.all(Radius.circular(18))),
        ));
  }
}
