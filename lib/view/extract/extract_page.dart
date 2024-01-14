import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/bloc/extract_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:provider/provider.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

import 'extract_detail.dart';

class ExtractPage extends StatefulWidget {
  @override
  _ExtractPageState createState() => _ExtractPageState();
}

class _ExtractPageState extends State<ExtractPage> {
  ExtractBloc bloc;

  pickRange() async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: DateTime.parse(bloc.start),
        initialLastDate: DateTime.parse(bloc.end),
        firstDate: DateTime(2020),
        lastDate: DateTime(2999));

    if (picked.length == 2) {
      bloc.start = Util.convertDateTimeUSA(picked.first);
      bloc.end = Util.convertDateTimeUSA(picked.last);
      await bloc.getExtract();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      bloc.init();
      await bloc.getExtract();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ExtractBloc>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Extrato', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: bloc.isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
            : Container(
                child: bloc.model == null || bloc.model.days == null || bloc.model.days.isEmpty
                    ? Column(children: [
                        Container(
                            padding: EdgeInsets.only(top: 20, bottom: 30, left: 15, right: 15),
                            decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                border: Border(bottom: BorderSide(color: AppColors.colorGradientPrimary))),
                            child: Row(children: [
                              Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text('De ${Util.convertDate(bloc.start)} até ${Util.convertDate(bloc.end)}',
                                    style: AppTextStyle.textBlueDarkExtraSmallBold),
                                Text('-', style: AppTextStyle.textGreenExtraBigBold)
                              ])),
                              InkWell(
                                onTap: () async => await pickRange(),
                                child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: AppColors.colorWhite),
                                    child: Icon(Icons.date_range,
                                        size: 25.0, color: AppColors.colorGradientPrimary)),
                              )
                            ])),
                        Expanded(
                            child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text('Nenhum registro de extrato para exibir no momento',
                                        style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center))))
                      ])
                    : Container(
                        decoration: BoxDecoration(color: AppColors.colorTextGreyLight),
                        child: Column(children: [
                          FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => ExtractDetail(bloc.model)));
                              },
                              child: Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 30, left: 15, right: 15),
                                  decoration: BoxDecoration(
                                      color: AppColors.colorWhite,
                                      border:
                                          Border(bottom: BorderSide(color: AppColors.colorGradientPrimary))),
                                  child: Row(children: [
                                    Expanded(
                                        child:
                                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text(bloc.model.day, style: AppTextStyle.textBlueDarkExtraSmallBold),
                                      Text(Util.formatMoney(bloc.model.total),
                                          style: AppTextStyle.textGreenExtraBigBold)
                                    ])),
                                    InkWell(
                                      onTap: () async => await pickRange(),
                                      child: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(color: AppColors.colorWhite),
                                          child: Icon(Icons.date_range,
                                              size: 25.0, color: AppColors.colorGradientPrimary)),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Icon(Icons.navigate_next,
                                            size: 20.0, color: AppColors.colorGradientPrimary))
                                  ]))),
                          Flexible(
                              child: SingleChildScrollView(
                                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    for (var it in bloc.model.days)
                                      FlatButton(
                                          padding: EdgeInsets.all(0),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) => ExtractDetail(it)));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                              margin: EdgeInsets.only(bottom: 10.0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: AppColors.colorGradientPrimary,
                                                      width: 1.0,
                                                      style: BorderStyle.solid),
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    Expanded(
                                                        child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                          Text(it.day,
                                                              style: AppTextStyle.textBlueDarkExtraSmallBold),
                                                          Text(Util.formatMoney(it.total),
                                                              style: AppTextStyle.textGreenExtraSmallBold),
                                                        ])),
                                                    Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Icon(Icons.navigate_next,
                                                            size: 20.0,
                                                            color: AppColors.colorGradientPrimary))
                                                  ]))),
                                  ])))
                        ]))));
  }
}
