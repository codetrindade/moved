import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class ExtractList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.colorGradientPrimary, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
            Text('10/12 - 17/12', style: AppTextStyle.textBlueDarkExtraSmallBold),
            Text('R\$ 14,50', style: AppTextStyle.textGreenExtraSmallBold),
          ])
        ]));
  }
}
