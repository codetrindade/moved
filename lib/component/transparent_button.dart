import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class TransparentButton extends StatelessWidget {
  final String text;
  final TextStyle style;
  final Function callback;
  final Widget iconLeft;
  final bool arrow;
  final bool ok;
  final bool warning;
  final bool pending;
  final double height;
  final double border;

  TransparentButton(
      {@required this.text,
      this.style = AppTextStyle.textGreySmall,
      this.callback,
      this.iconLeft,
      this.height = 50,
      this.border = 30,
      this.arrow = true,
      this.warning = false,
      this.pending = false,
      this.ok = false});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: FlatButton(
            padding: EdgeInsets.all(0),
            onPressed: callback,
            child: Container(
                height: height,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.colorBlueLight),
                    borderRadius: BorderRadius.circular(border)),
                child: Row(children: <Widget>[
                  if (iconLeft != null) iconLeft,
                  SizedBox(width: 20.0),
                  Expanded(child: Text(text, style: style)),
                  SizedBox(width: 20.0),
                  if (arrow) Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorBlueLight),
                  if (warning) Icon(Icons.info_rounded, size: 25, color: Colors.red),
                  if (pending) Icon(Icons.access_time_rounded, size: 25, color: Colors.yellow),
                  if (ok) Icon(Icons.check_circle, size: 25, color: AppColors.colorGreenLight)
                ]))));
  }
}
