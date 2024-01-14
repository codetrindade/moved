import 'package:flutter/material.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/theme.dart';

class RideListItem extends StatelessWidget {
  final Ride model;

  RideListItem({@required this.model});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      margin: EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.colorGreenLight,
              width: 1.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                child: new Text(model.back ? 'Volta' : 'Ida',
                    style: AppTextStyle.textBlueLightSmallBold),
              ),
              new Column(
                children: <Widget>[
                  new Icon(Icons.arrow_forward,
                      size: 16.0,
                      color: model.back
                          ? AppColors.colorGreyLight
                          : AppColors.colorBlueLight),
                  new Icon(Icons.arrow_back,
                      size: 16.0,
                      color: model.back
                          ? AppColors.colorBlueLight
                          : AppColors.colorGreyLight),
                ],
              )
            ],
          ),
          new Text(model.date + ' ' + model.time,
              style: AppTextStyle.textBlueDarkSmall),
          new SizedBox(width: 20.0),
          new Container(
            height: 1.0,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            color: AppColors.colorGreenLight,
          ),
          new Text('Origem', style: AppTextStyle.textBlueLightSmallBold),
          new Text(model.points.first.address,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: AppTextStyle.textBlueDarkSmall),
          new SizedBox(height: 10.0),
          new Text('Destino', style: AppTextStyle.textBlueLightSmallBold),
          new Text(model.points.last.address,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              style: AppTextStyle.textBlueDarkSmall),
          new Container(
            height: 1.0,
            margin: EdgeInsets.symmetric(vertical: 10.0),
            color: AppColors.colorGreenLight,
          ),
          new SizedBox(height: 2.0),
          new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text('Número de Reservas',
                        style: AppTextStyle.textBlueLightSmallBold),
                    new Text(model.reservations.toString() + ' Passageiros',
                        style: AppTextStyle.textBlueDarkSmall),
                  ],
                ),
              ),
              model.pending != null && model.pending
                  ? new Icon(Icons.notification_important, color: AppColors.colorGreen)
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
