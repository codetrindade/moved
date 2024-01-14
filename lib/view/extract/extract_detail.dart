import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/model/extract.dart';
import 'package:movemedriver/util/util.dart';

import '../../theme.dart';

class ExtractDetail extends StatelessWidget {
  final Extract model;

  ExtractDetail(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Detalhes do Extrato', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(children: [
              Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Column(children: [
                    Text(model.day, style: AppTextStyle.textBlueDarkExtraSmallBold),
                    Text(Util.formatMoney(model.total), style: AppTextStyle.textGreenExtraBigBold)
                  ])),
              Container(
                  margin: EdgeInsets.only(top: 40, left: 5, right: 5),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 20),
                        child: Row(children: [
                          Text('GANHOS DAS VIAGENS', style: AppTextStyle.textBlueLightMediumBold)
                        ])),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('No Dinheiro', style: AppTextStyle.textBlackBig),
                          Text(Util.formatMoney(model.resume.money), style: AppTextStyle.textBlackBigBold)
                        ])),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('No Cartão', style: AppTextStyle.textBlackBig),
                          Text(Util.formatMoney(model.resume.card), style: AppTextStyle.textBlackBigBold)
                        ])),
                    Divider(thickness: 2, height: 40),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Pagamento Total', style: AppTextStyle.textBlackBigBold),
                          Text(Util.formatMoney(model.total), style: AppTextStyle.textBlackBigBold)
                        ])),
                    Divider(thickness: 2, height: 40),
                    Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Column(children: [
                            Text(model.resume.durationMinutes.toString() + ' min',
                                style: AppTextStyle.textBlackBigBold),
                            Text('Tempo Online', style: AppTextStyle.textGreyExtraSmall),
                          ]),
                          Column(children: [
                            Text(model.resume.routesQtt.toString(), style: AppTextStyle.textBlackBigBold),
                            Text('Concluídas', style: AppTextStyle.textGreyExtraSmall),
                          ]),
                          Column(children: [
                            Text(model.resume.km.toStringAsFixed(1), style: AppTextStyle.textBlackBigBold),
                            Text('km', style: AppTextStyle.textGreyExtraSmall),
                          ])
                        ]))
                  ]))
            ])));
  }
}
