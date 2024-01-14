import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class AppBarCustom extends StatelessWidget {
  final String title;
  final Function callback;
  final List<Widget> actions;

  AppBarCustom({@required this.title, this.callback, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.colorGradientPrimary,
      title: Text(title, style: AppTextStyle.textBoldWhiteMedium),
      centerTitle: true,
      elevation: 0.0,
      actions: actions,
      leading: callback == null
          ? Container()
          : IconButton(
              icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0), onPressed: () => callback()),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
    );
  }
}
