import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/star_rating.dart';
import 'package:movemedriver/core/bloc/history/history_bloc.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/route/route_detail/client_detail_page.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

class HistoryListDetail extends StatefulWidget {
  @override
  _HistoryListDetailState createState() => _HistoryListDetailState();
}

class _HistoryListDetailState extends State<HistoryListDetail> {
  HistoryBloc bloc;

  String paymentDescription(String payment) {
    switch (payment) {
      case 'money':
        return 'Dinheiro';
      case 'credit':
        return 'Cartão de crédito';
      case 'debit':
        return 'Cartão de débito';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<HistoryBloc>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Detalhes da corrida', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: Container(
            color: Colors.white,
            child: ListView(children: [
              Container(
                  child: Image.asset('assets/images/map.png',
                      height: 200, width: double.infinity, fit: BoxFit.cover)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(Util.convertDateTimeFromString(bloc.model.createdAt),
                              style: AppTextStyle.textBlueLightSmall),
                          Text(Util.formatMoney(bloc.model.price),
                              style: AppTextStyle.textBlueLightMediumBold)
                        ])),
                    Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(
                              flex: 5,
                              child: Text(bloc.model.vehicle.model + ' ' + bloc.model.vehicle.licensePlate,
                                  style: AppTextStyle.textGreyExtraSmall)),
                          /*Expanded(
                              flex: 2,
                              child: Text('add extra', style: AppTextStyle.textBlueLightExtraSmallBold, textAlign: TextAlign.end))*/
                        ])),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Expanded(
                              flex: 5,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                for (var point in bloc.model.points)
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 20),
                                      child: Text(point.address,
                                          style: AppTextStyle.textBlueLightExtraSmallBold))
                              ])),
                          // Expanded(
                          //     flex: 3,
                          //     child: Column(children: [
                          //       FlatButton(
                          //         child: Text('Recibo'),
                          //         color: AppColors.colorGreyLight,
                          //         onPressed: () {
                          //         })]))
                        ]))
                  ])),
              Container(
                  color: AppColors.colorGrey,
                  child: Column(children: [
                    Container(
                        color: AppColors.colorWhite,
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(15),
                        child: Row(children: [
                          if (bloc.appDataUser?.photo != null)
                            ClipOval(
                                child: FadeInImage.assetNetwork(
                                    image: bloc.appDataUser.photo,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/images/user.png'))
                          else
                            ClipOval(child: Image(image: AssetImage('assets/images/user.png'), height: 40)),
                          SizedBox(width: 15),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Sua avaliação', style: AppTextStyle.textGreyDarkSmall),
                            SizedBox(height: 10),
                            if (bloc.model.ratingDriver != null)
                              StarRating(
                                  rating: bloc.model.ratingDriver, color: Colors.yellow, sizeIcon: 35.0)
                            else
                              Text('O cliente ainda não te avaliou'),
                          ])
                        ]))
                  ])),
              Container(
                  color: AppColors.colorGrey,
                  child: Column(children: [
                    Container(
                        color: AppColors.colorWhite,
                        margin: EdgeInsets.only(top: 3),
                        padding: EdgeInsets.all(15),
                        child: Row(children: [
                          ClipOval(
                              child: FadeInImage.assetNetwork(
                                  image: bloc.model.vehicle.photo.file,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/gifs/loading.gif')),
                          SizedBox(width: 15),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Avaliação do veículo', style: AppTextStyle.textGreyDarkSmall),
                            SizedBox(height: 10),
                            if (bloc.model.ratingVehicle != null)
                              StarRating(
                                  rating: bloc.model.ratingVehicle, color: Colors.yellow, sizeIcon: 35.0)
                            else
                              Text('O cliente ainda não avaliou o veículo'),
                          ])
                        ]))
                  ])),
              // Avaliação cliente
              Container(
                color: AppColors.colorGrey,
                child: Container(
                    color: AppColors.colorWhite,
                    margin: EdgeInsets.only(top: 3),
                    padding: EdgeInsets.all(15),
                    child: Row(children: [
                      (bloc.model.user.photo != null)
                          ? ClipOval(
                              child: FadeInImage.assetNetwork(
                                  image: bloc.model.user.photo,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  placeholder: 'assets/images/user.png'),
                            )
                          : ClipOval(
                              child: Image(image: AssetImage('assets/images/user.png'), height: 40)),
                      SizedBox(width: 15),
                      Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                            bloc.model.ratingUser != null
                                ? 'Avaliação dada ao passageiro'
                                : 'Avalie o passageiro',
                            style: AppTextStyle.textGreyDarkSmall),
                        SizedBox(height: 10),
                        Row(children: [
                          StarRating(
                              rating: bloc.model.ratingUser == null ? 0 : bloc.model.ratingUser,
                              color: Colors.yellow,
                              sizeIcon: 35.0),
                          Spacer(),
                          if (bloc.model.ratingUser == null)
                            FlatButton(
                                child: Text('Avaliar'),
                                color: AppColors.colorGrey,
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ClientPageDetail(
                                              name: bloc.model.user.name,
                                              photo: bloc.model.user.photo,
                                              routeId: bloc.model.id)));
                                  await bloc.getModel(bloc.model.id);
                                })
                        ])
                      ]))
                    ])),
              ),
              Container(
                color: AppColors.colorGrey,
                child: Container(
                    color: AppColors.colorWhite,
                    margin: EdgeInsets.only(top: 3, bottom: 3),
                    padding: EdgeInsets.all(15),
                    child: Row(children: [
                      Icon(Icons.credit_card, color: Colors.blue, size: 36.0),
                      SizedBox(width: 15),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Forma do pagamento', style: AppTextStyle.textGreyDarkSmall),
                        SizedBox(height: 10),
                        Row(children: [
                          Text(this.paymentDescription(bloc.model.payment),
                              style: AppTextStyle.textBlueLightMediumBold)
                        ])
                      ])
                    ])),
              )
            ])));
  }
}
