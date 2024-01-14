import 'package:flutter/material.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/theme.dart';

class VehicleListItem extends StatelessWidget {
  final Vehicle model;
  final Function callback;

  VehicleListItem({@required this.model, @required this.callback});

  getStatus(String status) {
    switch (status) {
      case 'incomplete':
        return 'Necessita correção';
        break;
      case 'pending':
        return 'Em análise';
        break;
      case 'approved':
        return 'Aprovado';
        break;
      case 'disapproved':
        return 'Desaprovado';
        break;
    }
  }

  getStatusColor(String status) {
    switch (status) {
      case 'incomplete':
        return Colors.redAccent;
        break;
      case 'pending':
        return Colors.amber;
        break;
      case 'approved':
        return AppColors.colorGreen;
        break;
      case 'disapproved':
        return AppColors.colorPurpleLight;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var frontalPhoto =
        model.documents.firstWhere((element) => element.type == 'photo_front', orElse: () => null);
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () => callback(),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            margin: EdgeInsets.symmetric(vertical: 15.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(
                    color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.colorBlueLight)),
                    child: Center(
                        child: Container(
                            width: 60.0,
                            height: 60.0,
                            child: ClipOval(
                                child: frontalPhoto == null
                                    ? Image.asset('assets/images/logo_new.png',
                                        width: 60, height: 60, fit: BoxFit.fitWidth)
                                    : FadeInImage.assetNetwork(
                                        image: frontalPhoto.file,
                                        fit: BoxFit.cover,
                                        placeholder: 'assets/gifs/loading.gif'))))),
                SizedBox(width: 20.0),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(model.model, style: AppTextStyle.textBlueLightSmallBold, maxLines: 2),
                  Text(model.color, style: AppTextStyle.textBlueDarkExtraSmallBold)
                ]))
              ]),
              Container(
                  color: AppColors.colorGreenLight,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  height: 1.0),
              Row(children: <Widget>[
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  Text('Ano', style: AppTextStyle.textBlueLightSmallBold),
                  Text(model.year.toString(), style: AppTextStyle.textBlueDarkExtraSmall),
                ])
              ]),
              SizedBox(height: 8.0),
              Row(children: <Widget>[
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text('Placa', style: AppTextStyle.textBlueLightSmallBold),
                  Text(model.licensePlate, style: AppTextStyle.textBlueDarkExtraSmall),
                ])),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
                  Icon(Icons.brightness_1, color: getStatusColor(model.adminStatus), size: 15.0),
                  Text(getStatus(model.adminStatus), style: AppTextStyle.textBlueDarkExtraSmall),
                ])
              ])
            ])));
  }
}
