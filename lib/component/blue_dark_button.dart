import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class BlueDarkButton extends StatelessWidget {
  final String text;
  final Function callback;

  BlueDarkButton({this.text = 'Salvar', @required this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: callback,
        child: Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: AppColors.colorGreenLight, borderRadius: BorderRadius.circular(60)),
            child: Center(child: Text(text, style: AppTextStyle.textWhiteSmallBold))));
  }
}
