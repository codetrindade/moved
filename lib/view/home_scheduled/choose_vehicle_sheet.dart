import 'package:flutter/material.dart';
import 'package:movemedriver/core/bloc/home/home_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class ChooseVehicleSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<HomeBloc>(context);
    return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        padding: EdgeInsets.only(top: 40, bottom: 40),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(children: [
              Text('Selecione o veículo que deseja utilizar',
                  style: AppTextStyle.textBlueLightMediumBold, textAlign: TextAlign.center),
              SizedBox(height: 15),
              Divider(),
              SizedBox(height: 15),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(children: [
                for (var v in bloc.vehicles)
                  InkWell(
                      onTap: () => bloc.chooseVehicle(v),
                      child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                            Container(
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.colorBlueLight)),
                                child: Center(
                                    child: Container(
                                        width: 60.0,
                                        height: 60.0,
                                        child: ClipOval(
                                            child: FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                placeholder: 'assets/gifs/loading.gif',
                                                image: v.documents.first.file))))),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                              Text(v.model, style: AppTextStyle.textBlueLightSmallBold, maxLines: 2),
                              Text(v.color, style: AppTextStyle.textBlueDarkExtraSmallBold)
                            ])),
                            SizedBox(width: 20),
                            if (bloc.selectedVehicle != null && v.id == bloc.selectedVehicle.id)
                              Icon(Icons.check_circle, color: AppColors.colorGreenLight)
                          ])))
              ]))),
              RoundedButton(
                  text: 'Ok',
                  callback: () {
                    if (bloc.selectedVehicle == null) {
                      bloc.dialogService.showDialog('Atenção', 'Escolha um veículo par continuar');
                      return;
                    }
                    Navigator.pop(context);
                  },
                  color: AppColors.colorBlueLight)
            ])));
  }
}
