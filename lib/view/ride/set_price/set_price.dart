import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/model/points.dart';
import 'package:movemedriver/model/price_ride.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/ride/ride_back.dart';
import 'package:movemedriver/view/ride/ride_publish/ride_publish.dart';
import 'package:provider/provider.dart';

class SetPrice extends StatefulWidget {
  // final Ride model;
  // final Ride modelBack;
  //
  // SetPrice({@required this.model, this.modelBack});

  // @override
  // _SetPriceState createState() =>
  //     _SetPriceState(model: model, modelBack: modelBack);

  @override
  _SetPriceState createState() => _SetPriceState();
}

// class _SetPriceState extends BaseState<SetPrice> implements SetPriceView {
//   Ride model;
//   Ride modelBack;
//   SetPricePresenter _presenter;
//   bool _isLoading = true;
//   List<PriceRide> prices = [];

class _SetPriceState extends BaseState<SetPrice> {
  RideBloc bloc;

  _SetPriceState();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (bloc.modelBack == null)
        bloc.getPricePreview(bloc.model);
      else
        setModelBackRoutes();
    });
  }

  setModelBackRoutes() {
    List<Points> oldPoints = bloc.model.points.map((p) => new Points.fromJson(p.toJson())).toList();
    bloc.modelBack.points = [];
    oldPoints.sort((a, b) => b.order.compareTo(a.order));
    oldPoints.forEach((op) {
      op.order = oldPoints.length - 1 - op.order;
      bloc.modelBack.points.add(op);
    });
    bloc.getPricePreview(bloc.modelBack);
  }

  changeMoney(bool add, PriceRide p) {
    if (p.price == 0 && !add) return;
    p.price = add ? p.price += 1 : p.price -= 1;
    setState(() {});
  }

  createPaths() {
    List<Widget> result = [];

    var mainPrice = bloc.prices.firstWhere((p) => p.main);

    result.add(new Row(
      children: <Widget>[
        Expanded(
          child: new Column(
            children: <Widget>[
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.asset("assets/images/start.png", height: 30.0, width: 25.0),
                  new SizedBox(
                    width: 5.0,
                  ),
                  new Expanded(
                      child: new Text(
                    mainPrice.originAddress,
                    maxLines: 3,
                    style: AppTextStyle.textWhiteSmall,
                    overflow: TextOverflow.ellipsis,
                  ))
                ],
              ),
              new SizedBox(height: 8.0),
              new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Image.asset("assets/images/destination.png", height: 30.0, width: 25.0),
                  new SizedBox(
                    width: 5.0,
                  ),
                  new Expanded(
                      child: new Text(mainPrice.destinationAddress,
                          maxLines: 3, style: AppTextStyle.textWhiteSmall, overflow: TextOverflow.ellipsis))
                ],
              )
            ],
          ),
        ),
        new SizedBox(
          width: 10.0,
        ),
        new GestureDetector(
            onTap: () => changeMoney(false, mainPrice), child: new Icon(Icons.remove, color: Colors.white)),
        new Container(
          padding: EdgeInsets.only(left: 2.0, right: 5.0, top: 5.0, bottom: 5.0),
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(color: Colors.white, width: 1.0, style: BorderStyle.solid)),
          child: new Text(NumberFormat.currency(locale: 'pt-Br', symbol: '', decimalDigits: 0).format(mainPrice.price),
              style: AppTextStyle.textWhiteSmallBold),
        ),
        new GestureDetector(onTap: () => changeMoney(true, mainPrice), child: new Icon(Icons.add, color: Colors.white)),
      ],
    ));

    result.add(new Container(
      color: Colors.white,
      height: 1.0,
      margin: EdgeInsets.symmetric(vertical: 15.0),
    ));

    bloc.prices.forEach((p) {
      if (p.main) return;
      result.add(new Row(
        children: <Widget>[
          Expanded(
            child: new Column(
              children: <Widget>[
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("assets/images/start.png", height: 30.0, width: 25.0),
                    new SizedBox(
                      width: 5.0,
                    ),
                    new Expanded(
                        child: new Text(
                      p.originAddress,
                      maxLines: 3,
                      style: AppTextStyle.textWhiteSmall,
                      overflow: TextOverflow.ellipsis,
                    ))
                  ],
                ),
                new SizedBox(height: 8.0),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Image.asset("assets/images/destination.png", height: 30.0, width: 25.0),
                    new SizedBox(
                      width: 5.0,
                    ),
                    new Expanded(
                        child: new Text(p.destinationAddress,
                            maxLines: 3, style: AppTextStyle.textWhiteSmall, overflow: TextOverflow.ellipsis))
                  ],
                )
              ],
            ),
          ),
          new SizedBox(
            width: 10.0,
          ),
          new GestureDetector(onTap: () => changeMoney(false, p), child: new Icon(Icons.remove, color: Colors.white)),
          new Container(
            padding: EdgeInsets.only(left: 2.0, right: 5.0, top: 5.0, bottom: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: Colors.white, width: 1.0, style: BorderStyle.solid)),
            child: new Text(NumberFormat.currency(locale: 'pt-Br', symbol: '', decimalDigits: 0).format(p.price),
                style: AppTextStyle.textWhiteSmallBold),
          ),
          new GestureDetector(onTap: () => changeMoney(true, p), child: new Icon(Icons.add, color: Colors.white)),
        ],
      ));

      result.add(new Container(
        color: Colors.white,
        height: 1.0,
        margin: EdgeInsets.symmetric(vertical: 15.0),
      ));
    });

    return result;
  }

  openRideBackPage() {
    if (bloc.modelBack == null) {
      bloc.model.prices = bloc.prices;
      Navigator.push(context, new MaterialPageRoute(builder: (context) => new RideBack()));
    } else {
      bloc.modelBack.prices = bloc.prices;
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new RidePublish(model: [bloc.model, bloc.modelBack])));
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RideBloc>(context);
    return bloc.isLoading
        ? new Container(
            color: Colors.white,
            child: new Center(
                child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
        : new Scaffold(
            appBar: new AppBar(
              backgroundColor: AppColors.colorGreenLight,
              elevation: 0.0,
              centerTitle: true,
              leading: new IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              title: new Text('Oferecer Carona', style: AppTextStyle.textWhiteSmallBold),
            ),
            body: Container(
              decoration: new BoxDecoration(gradient: appGradient),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: <Widget>[
                  new Expanded(
                    child: new Column(
                      children: <Widget>[
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10.0),
                                child: new Text(
                                  'Valor recomendado por trajeto. Este(s) valor(es) está(ão) de acordo para você?',
                                  style: AppTextStyle.textWhiteSmallBold,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                        new Container(
                          decoration: BoxDecoration(color: AppColors.colorWhite),
                          margin: EdgeInsets.symmetric(vertical: 5.0),
                          height: 1.0,
                        ),
                        new SizedBox(height: 15.0),
                        new Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Text('Trajetos', style: AppTextStyle.textBlueLightSmallBold),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              child: new Text('Preço', style: AppTextStyle.textBlueLightSmallBold),
                            )
                          ],
                        ),
                        new SizedBox(height: 15.0),
                        new Expanded(
                            child: Scrollbar(
                                child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                                    child: new ListView(children: createPaths()))))
                      ],
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    alignment: Alignment.bottomCenter,
                    child: new FlatButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () => openRideBackPage(),
                        child: new Container(
                            height: AppSizes.buttonHeight,
                            decoration:
                                BoxDecoration(color: AppColors.colorPurpleDark, borderRadius: AppSizes.buttonCorner),
                            child: new Center(
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[new Text('Continuar', style: AppTextStyle.textWhiteSmallBold)],
                              ),
                            ))),
                  ),
                ],
              ),
            ),
          );
  }

// @override
// void onGetPricePreviewSuccess(List<PriceRide> result) {
//   prices = result;
//   result.asMap().forEach((index, r) {
//     r.originAddress = modelBack == null
//         ? model.points.firstWhere((p) => p.order == r.origin).address
//         : modelBack.points.firstWhere((p) => p.order == r.origin).address;
//     r.destinationAddress = modelBack == null
//         ? model.points.firstWhere((p) => p.order == r.destination).address
//         : modelBack.points.firstWhere((p) => p.order == r.destination).address;
//   });
//   _isLoading = false;
//   setState(() {});
// }
}
