import 'package:flutter/material.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/core/bloc/vehicle/share_vehicle_bloc.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/widgets/confirm_sheet.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VehicleSharePage extends StatefulWidget {
  final Vehicle vehicle;

  VehicleSharePage({@required this.vehicle});

  @override
  _VehicleSharePageState createState() => _VehicleSharePageState(model: this.vehicle);
}

class _VehicleSharePageState extends State<VehicleSharePage> {
  ShareVehicleBloc bloc;
  Vehicle model;

  void showQRSheet(String id) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text('Escaneie o código QR abaixo para compartilhar este veículo',
                          style: AppTextStyle.textBlueDarkMediumBold, textAlign: TextAlign.center),
                    ),
                    SizedBox(height: 30),
                    QrImage(
                        data: id,
                        version: QrVersions.auto,
                        foregroundColor: AppColors.colorBlueDarkOpacity,
                        size: MediaQuery.of(context).size.width * 0.7)
                  ]));
        });
  }

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

  _VehicleSharePageState({this.model});

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      bloc.model = this.model;
      await bloc.getDrivers();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<ShareVehicleBloc>(context);

    return bloc.isLoading
        ? LoadingCircle(showBackground: true)
        : Scaffold(
            appBar: PreferredSize(
                child: AppBarCustom(
                    title: 'Compartilhamento',
                    actions: [
                      IconButton(
                          icon: Icon(Icons.qr_code_scanner_outlined, color: Colors.white),
                          onPressed: () => showQRSheet(bloc.model.id))
                    ],
                    callback: () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                SizedBox(height: 20),
                for (var d in bloc.drivers)
                  InkWell(
                      onTap: () => {},
                      child: Container(
                          margin: EdgeInsets.only(bottom: 15),
                          child:
                              Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.colorBlueLight)),
                                child: Center(
                                    child: Container(
                                        width: 60.0,
                                        height: 60.0,
                                        child: ClipOval(
                                            child: FadeInImage.assetNetwork(
                                                fit: BoxFit.cover,
                                                placeholder: 'assets/images/user.png',
                                                image: d.photo))))),
                            SizedBox(width: 20.0),
                            Expanded(
                                child: Text(d.name,
                                    style: AppTextStyle.textBlueLightSmallBold, maxLines: 2)),
                            SizedBox(width: 20),
                            InkWell(
                                onTap: () => showConfirmSheet(
                                    'Tem certeza que deseja remover o compartilhamento com este motorista?',
                                    callback: () async => await bloc.removeDriver(d.id)),
                                child: Icon(Icons.delete, color: Colors.red))
                          ])))
              ]),
            )),
          );
  }
}
