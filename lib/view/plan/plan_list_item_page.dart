import 'package:flutter/material.dart';
import 'package:movemedriver/model/plan.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/plan/plan_detail_page.dart';

class PlanListItem extends StatelessWidget {

  Plan model = new Plan();

//  PlanListItem({this.model});

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      onPressed: () {
        Navigator.push(context, new MaterialPageRoute(
            builder: (context) => new PlanDetailPage()));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
        margin: EdgeInsets.symmetric(vertical: 15.0),
        decoration: new BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          color: AppColors.colorGreenLight,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Container(
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.colorBlueLight
                  ),
                  child: Column(
                    children: <Widget>[
                      new Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(bottom: 2.0, top: 10.0, left: 15.0, right: 15.0),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: new AssetImage('assets/icons/car_compact_branco.png'),
                              )
                          )
                      ),
                      new Container(
                          width: 20.0,
                          height: 20.0,
                          margin: EdgeInsets.only(top: 2.0, bottom: 10.0, left: 15.0, right: 15.0),
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: new AssetImage('assets/icons/motorcycle.png'),
                              )
                          )
                      ),
                    ],
                  ),
                ),
                new SizedBox(width: 20.0),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(model.name ?? 'teste', style: AppTextStyle.textBlueLightSmallBold),
                    new Text(model.rides ?? 'teste', style: AppTextStyle.textWhiteExtraSmallBold)
                  ],
                )
              ],
            ),
            new Container(
              color: AppColors.colorWhite,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 1.0,
            ),
            new Text(model.detail ?? 'teste', style: AppTextStyle.textWhiteSmall),
            new Container(
              color: AppColors.colorWhite,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              height: 1.0,
            ),
            new SizedBox(height: 8.0),
            new Row(

              children: <Widget>[
                new Text('R\$ ', style: AppTextStyle.textBlueLightExtraSmallBold),
                new Text(model.price ?? '19,90', style: AppTextStyle.textBlueLightSmallBold),
                new Text(' /MÊS', style: AppTextStyle.textBlueLightExtraSmallBold),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
