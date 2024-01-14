import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/bloc/vehicle/vehicle_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/vehicle/share/vehicle_share_page.dart';
import 'package:movemedriver/widgets/confirm_sheet.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:movemedriver/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class VehicleDetail extends StatefulWidget {
  @override
  _VehicleDetailState createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  VehicleBloc bloc;

  void showConfirmSheet(String message, {Function callback}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                Navigator.pop(context);
                callback();
              },
              text: message);
        });
  }

  openEditSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: Text('Ações', textAlign: TextAlign.center, style: AppTextStyle.textBlueLightMediumBold)),
                RoundedButton(
                    text: 'Compartilhamento',
                    callback: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => VehicleSharePage(vehicle: bloc.vehicle)));
                    }),
                RoundedButton(
                    text: 'Alterar Dados',
                    callback: () {
                      Navigator.pop(context);
                      this.showConfirmSheet(
                          'Alterar este veículo, fará com que ele fique indisponível para utilização no app até '
                          'que o mesmo seja reavaliado pela nosa equipe, deseja continuar?',
                          callback: () async => await bloc.modify());
                    }),
                RoundedButton(
                    text: 'Remover',
                    callback: () {
                      Navigator.pop(context);
                      this.showConfirmSheet('Tem certeza que deseja remover este veículo?',
                          callback: () async => await bloc.remove());
                    },
                    color: Colors.redAccent),
                SizedBox(height: 20),
              ]));
        });
  }

  String getTitle(String type) {
    switch (type) {
      case 'photo_front':
        return 'Foto frontal';
      case 'photo_panel':
        return 'Foto do painel';
      case 'photo_side':
        return 'Foto da lateral';
      case 'photo_bag_open':
        return 'Foto do porta-malas';
      case 'photo_document':
        return 'Foto do documento';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    bloc.onDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<VehicleBloc>(context);

    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            appBar: PreferredSize(
                child: AppBarCustom(
                    title: 'Detalhes do Veículo',
                    actions: [IconButton(icon: Icon(Icons.edit), onPressed: () => openEditSheet())],
                    callback: () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(height: 20),
                Text('MODELO', style: AppTextStyle.textBlueDarkSmallBold),
                Text(bloc.vehicle.model, style: AppTextStyle.textGreySmall),
                SizedBox(height: 5),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('PLACA', style: AppTextStyle.textBlueDarkSmallBold),
                    Text(bloc.vehicle.licensePlate, style: AppTextStyle.textGreySmall),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('ANO', style: AppTextStyle.textBlueDarkSmallBold),
                    Text(bloc.vehicle.year.toString(), style: AppTextStyle.textGreySmall),
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('COR', style: AppTextStyle.textBlueDarkSmallBold),
                    Text(bloc.vehicle.color, style: AppTextStyle.textGreySmall),
                  ]),
                ]),
                Container(
                    height: 1,
                    color: AppColors.colorGreyLight,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 15)),
                for (var it in bloc.vehicle.documents)
                  Center(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Text(getTitle(it.type), style: AppTextStyle.textBlueLightMediumBold),
                      SizedBox(height: 15),
                      Image.network(it.file, width: MediaQuery.of(context).size.width * 0.8),
                      SizedBox(height: 35),
                    ]),
                  )
              ])),
            ));
  }
}
