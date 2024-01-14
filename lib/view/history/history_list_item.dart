import 'package:flutter/material.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/history/history_bloc.dart';
import 'package:movemedriver/model/route_history.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:provider/provider.dart';


class HistoryListItem extends StatelessWidget {
  final RouteHistory model;

  HistoryListItem({@required this.model});

  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<HistoryBloc>(context);

    return FlatButton(
      onPressed: () async => await bloc.getRouteHistoryById(model.id),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        margin: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.colorGradientPrimary, width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  margin: EdgeInsets.only(right: 15.0),
                  child: model.user.photo == null || model.user.photo.isEmpty
                      ? CircleAvatar(backgroundImage: AssetImage('assets/images/user.png'))
                      : ClipOval(
                          child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/user.png', image: model.user.photo, fit: BoxFit.fill)),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(model.user.name, style: AppTextStyle.textBlueLightSmallBold),
                    SizedBox(height: 5.0),
                    model.status != 'canceled' && model.ratingDriver != null && model.ratingDriver == -1
                        ? Row(
                            children: <Widget>[
                              Icon(MoveMeIcons.man_user, color: AppColors.colorPurpleLight, size: 15),
                              SizedBox(width: 10.0),
                              Text(model.ratingDriver.toStringAsFixed(1), style: AppTextStyle.textBlueDarkSmallBold),
                              SizedBox(width: 10.0),
                              Icon(MoveMeIcons.car_compact, color: AppColors.colorPurpleLight, size: 15),
                              SizedBox(width: 10.0),
                              Text(model.ratingVehicle.toStringAsFixed(1), style: AppTextStyle.textBlueDarkSmallBold),
                            ],
                          )
                        : SizedBox(),
                    if (model.ratingDriver == null || model.ratingDriver == -1)
                      Text('(Não avaliado)', style: AppTextStyle.textGreySmallBold)
                  ],
                )
              ],
            ),
            Container(height: 1.0, margin: EdgeInsets.symmetric(vertical: 10.0), color: AppColors.colorGradientPrimary),
            Text('Origem', style: AppTextStyle.textBlueLightSmallBold),
            Text(model.points.first.address, style: AppTextStyle.textBlueDarkSmall),
            SizedBox(height: 10.0),
            Text('Destino', style: AppTextStyle.textBlueLightSmallBold),
            Text(model.points.last.address, style: AppTextStyle.textBlueDarkSmall),
            Container(height: 1.0, margin: EdgeInsets.symmetric(vertical: 10.0), color: AppColors.colorGradientPrimary),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(Util.convertDateFromString(model.createdAt), style: AppTextStyle.textBlueDarkExtraSmallBold),
                model.status == 'canceled'
                    ? Expanded(
                        child: new Text('Cancelada',
                            style: AppTextStyle.textBlueDarkExtraSmallBold, textAlign: TextAlign.right))
                    : Text(Util.formatMoney(model.price), style: AppTextStyle.textBlueDarkExtraSmallBold),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
