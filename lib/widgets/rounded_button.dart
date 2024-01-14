import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function callback;
  final Color color;
  final TextStyle textStyle;

  RoundedButton(
      {this.text = 'Salvar',
      @required this.callback,
      this.color = AppColors.colorGreenLight,
      this.textStyle = AppTextStyle.textWhiteSmallBold});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: this.callback,
        child: Container(
            height: AppSizes.buttonHeight,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(color: this.color, borderRadius: AppSizes.buttonCorner),
            child: Center(child: Text(this.text, style: this.textStyle))));
  }
}
