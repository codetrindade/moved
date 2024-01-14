import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/model/plan.dart';
import 'package:movemedriver/theme.dart';

class PlanPaymentPage extends StatefulWidget {
  @override
  _PlanPaymentPageState createState() => _PlanPaymentPageState();
}

class _PlanPaymentPageState extends BaseState<PlanPaymentPage> {
  Plan model = new Plan();

  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04),
            margin: EdgeInsets.only(bottom: 1.0),
            decoration: BoxDecoration(
                color: AppColors.colorGreenLight,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0))),
            child: new Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.02),
                  child: new IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppColors.colorWhite,
                        size: 16.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04),
                        new Text('Pagamento',
                            style: AppTextStyle.textBoldWhiteMedium)
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          new Expanded(
            child: new Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: new ListView(
                padding: EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    margin: EdgeInsets.symmetric(vertical: 15.0),
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: appGradient
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Container(
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.colorBlueLight),
                              child: Column(
                                children: <Widget>[
                                  new Container(
                                      width: 20.0,
                                      height: 20.0,
                                      margin: EdgeInsets.only(
                                          bottom: 2.0,
                                          top: 10.0,
                                          left: 15.0,
                                          right: 15.0),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: new AssetImage(
                                                'assets/icons/car_compact_branco.png'),
                                          ))),
                                  new Container(
                                      width: 20.0,
                                      height: 20.0,
                                      margin: EdgeInsets.only(
                                          top: 2.0,
                                          bottom: 10.0,
                                          left: 15.0,
                                          right: 15.0),
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fitWidth,
                                            image: new AssetImage(
                                                'assets/icons/motorcycle.png'),
                                          ))),
                                ],
                              ),
                            ),
                            new SizedBox(width: 20.0),
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(model.name ?? 'teste',
                                    style:
                                    AppTextStyle.textBlueLightMediumBold),
                                new Text(model.rides ?? 'teste',
                                    style:
                                    AppTextStyle.textWhiteSmallBold)
                              ],
                            )
                          ],
                        ),
                        new Container(
                          color: AppColors.colorWhite,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          height: 1.0,
                        ),
                        new Text(model.detail ?? 'teste',
                            style: AppTextStyle.textWhiteSmall),
                        new Container(
                          color: AppColors.colorWhite,
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          height: 1.0,
                        ),
                        new SizedBox(height: 8.0),
                        new Text('Valor',
                            style: AppTextStyle.textBlueLightMediumBold),
                        new SizedBox(height: 5.0),
                        new Row(
                          children: <Widget>[
                            new Text('R\$ ',
                                style: AppTextStyle.textWhiteSmallBold),
                            new Text(model.price ?? '19,90',
                                style: AppTextStyle.textWhiteSmallBold),
                            new Text(' /MÊS',
                                style: AppTextStyle.textWhiteSmallBold),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: new Container(
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 1.0),
        child: new Column(
          children: <Widget>[
            new FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () {
//                  Navigator.push(context, new MaterialPageRoute(builder: (context) => new PlanPaymentPage()));
                },
                child: new Container(
                    height: AppSizes.buttonHeight,
                    decoration: BoxDecoration(
                        color: AppColors.colorGreenLight,
                        borderRadius: AppSizes.buttonCorner),
                    child: new Center(
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text('Pagar com PayPal',
                              style: AppTextStyle.textWhiteExtraSmallBold)
                        ],
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
