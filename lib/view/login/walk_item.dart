import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';

class WalkItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/images/walk.png")),
          SizedBox(height: 20.0,),
          Text('Tudo em um!', style: AppTextStyle.textWhiteSmallBold),
          SizedBox(height: 15.0,),
          Text('Tudo que você precisa em um só app', style: AppTextStyle.textWhiteSmall),
        ],
      ),
    );
  }
}