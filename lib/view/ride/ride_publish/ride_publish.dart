import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/presenter/ride_publish_presenter.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/ride/ride_publish/ride_publish_view.dart';
import 'package:movemedriver/view/ride_list/ride_list_item.dart';

class RidePublish extends StatefulWidget {
  final List<Ride> model;

  RidePublish({@required this.model});

  @override
  _RidePublishState createState() => _RidePublishState(model: model);
}

class _RidePublishState extends BaseState<RidePublish> implements RidePublishView {
  List<Ride> model;
  RidePublishPresenter _presenter;

  _RidePublishState({this.model}) {
    _presenter = new RidePublishPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(children: <Widget>[
      new Container(decoration: new BoxDecoration(color: AppColors.colorWhite)),
      new Container(
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
            color: AppColors.colorGreenLight,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
        child: new Stack(
          children: <Widget>[
            new Align(
              alignment: Alignment.centerLeft,
              child: new Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: new IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: new Icon(Icons.arrow_back_ios, color: AppColors.colorWhite),
                ),
              ),
            ),
            new Center(
              child: new Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.03),
                child: new Text('Oferecer Carona', style: AppTextStyle.textBoldWhiteMedium),
              ),
            ),
          ],
        ),
      ),
      new Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.inputPaddingHorizontalDouble),
                child: new ListView(
                  padding: EdgeInsets.all(0),
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    new SizedBox(height: 20.0),
                    new RideListItem(model: model.first),
                    model.length == 2 ? new RideListItem(model: model.last) : new SizedBox(),
                  ],
                ),
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.inputPaddingHorizontalDouble, horizontal: AppSizes.inputPaddingHorizontalDouble),
              child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    _presenter.createRoute(model);
                  },
                  child: new Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(color: AppColors.colorPurpleDark, borderRadius: AppSizes.buttonCorner),
                      child: new Center(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[new Text('Publicar', style: AppTextStyle.textWhiteSmallBold)],
                        ),
                      ))),
            ),
          ],
        ),
      ),
    ]));
  }

  @override
  void onCreateRouteSuccess() {
    Util.showMessage(context, 'Sucesso', 'Carona criada com sucesso');
    Navigator.pop(context, true);
  }
}
