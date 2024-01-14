import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/home/home_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/home_scheduled/choose_flag_page.dart';
import 'package:movemedriver/view/home_scheduled/choose_vehicle_sheet.dart';
import 'package:provider/provider.dart';

class HomeScheduledPage extends StatefulWidget {
  @override
  _HomeScheduledPageState createState() => _HomeScheduledPageState();
}

class _HomeScheduledPageState extends BaseState<HomeScheduledPage> {
  HomeBloc bloc;
  GoogleMapController mapController;

  _HomeScheduledPageState() {
    eventBus.on<GpsChangedEvent>().listen((event) {
      if (mounted && context != null) {
        bloc.setMapMarkers(context);
        centerMap();
      }
    });
  }

  onBtnChangeStatusClick() async {
    if (!await bloc.getStatus()) {
      bloc.dialogService.showDialog('Atenção', 'Seu cadastro não está aprovado pela nossa equipe!');
      return;
    }

    if (AppState.user.status == 'available') {
      await bloc.goOffline();
      return;
    }

    if (bloc.selectedVehicle == null) {
      var a = await this.showVehiclesSheet();
      if (!a) return;
    }

    if (bloc.flag == '') {
      var a = await this.showFlagsSheet();
      if (!a) return;
    }
    if (bloc.selectedVehicle != null && bloc.flag != null)
      await bloc.goOnline();
    else
      bloc.dialogService.showDialog('Atenção', 'Não foram selecionados o veículo e/ou bandeira!');
  }

  Future<bool> showVehiclesSheet() async {
    await bloc.getVehiclesList();
    if (bloc.vehicles.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Acesse o menu de veículos na aba perfil, para cadastrar veículos!');
      return false;
    }

    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChooseVehicleSheet();
        });

    return true;
  }

  Future<bool> showFlagsSheet() async {
    if (AppState.user.driver.priceOne == null &&
        AppState.user.driver.priceTwo == null &&
        AppState.user.driver.minPriceOne == null &&
        AppState.user.driver.minPriceTwo == null) {
      bloc.dialogService.showDialog(
          'Atenção', 'Acesse o menu de configurações na aba perfil, para configurar as faixas de preço de operação!');
      return false;
    }

    await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ChooseFlagPage();
        });

    return true;
  }

  centerMap() {
    if (bloc.pos != null && mapController != null)
      mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(bloc.pos.latitude, bloc.pos.longitude), bearing: bloc.pos.heading, zoom: 16)));
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      bloc.setMapMarkers(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    mapController.dispose();
  }

  String getSpeed() {
    if (AppState.pos == null) return '0';
    return (AppState.pos.speed * (100 / 28)).round().toString();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<HomeBloc>(context);

    return Scaffold(
        appBar: PreferredSize(child: AppBar(elevation: 0.0), preferredSize: Size.fromHeight(0.0)),
        body: bloc.isLoading
            ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
            : Stack(
                children: <Widget>[
//                  Container(
//                      child: MapComponent(
//                          canAutoRefreshInitialPosition: true,
//                          points: bloc.points,
//                          padding: EdgeInsets.only(
//                              bottom: MediaQuery.of(context).size.height * 0.2,
//                              top: MediaQuery.of(context).size.height * 0.2),
//                          controller: mapController,
//                          centerMap: () => centerMap())),

                  Container(
                    child: Stack(
                      children: <Widget>[
                        GoogleMap(
                          mapType: MapType.normal,
                          markers: bloc.points,
                          compassEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          tiltGesturesEnabled: true,
                          trafficEnabled: true,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).size.height * 0.2,
                              top: MediaQuery.of(context).size.height * 0.2),
                          initialCameraPosition: AppState().initialPosition ??
                              CameraPosition(
                                target: LatLng(0, 0),
                                bearing: 0,
                                zoom: 17,
                              ),
                          rotateGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                          },
                        )
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                          margin:
                              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07, left: 10.0, right: 20.0),
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                              color:
                                  AppState.user.status == 'available' ? Colors.transparent : AppColors.colorBlueLight,
                              borderRadius: BorderRadius.circular(30.0)),
                          child: AppState.user.status == 'available'
                              ? SizedBox()
                              : FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () => showFlagsSheet(),
                                  child: Icon(MoveMeIcons.flag, color: Colors.white))),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: AppState.user.status == 'available'
                                      ? AppColors.colorGreenLight
                                      : AppColors.colorBlueLight,
                                  borderRadius: BorderRadius.circular(30.0)),
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.07, left: 5.0, right: 5.0),
                              child: FlatButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () async => await onBtnChangeStatusClick(),
                                  child: Text(AppState.user.status == 'available' ? 'Online' : 'Offline',
                                      style: AppTextStyle.textWhiteSmallBold)))),
                      Container(
                        margin:
                            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.07, left: 20.0, right: 10.0),
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.only(right: 3.0),
                        decoration: BoxDecoration(
                            color: AppState.user.status == 'available' ? Colors.transparent : AppColors.colorBlueLight,
                            borderRadius: BorderRadius.circular(30.0)),
                        child: AppState.user.status == 'available'
                            ? SizedBox()
                            : FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () => showVehiclesSheet(),
                                child: Icon(MoveMeIcons.car_compact, color: Colors.white, size: 20.0)),
                      ),
                    ],
                  ),

                  // indicador de velocidade
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12, left: 10.0),
                          height: MediaQuery.of(context).size.height * 0.12,
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                              color: AppColors.colorBlueLight,
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(color: Colors.black38, offset: Offset(1.0, 6.0), blurRadius: 6.0),
                              ]),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(getSpeed(), style: AppTextStyle.textBoldWhiteMedium),
                                Text('km/h', style: AppTextStyle.textWhiteExtraSmall),
                              ]))),

                  // botão centralizar
                  Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () => centerMap(),
                        child: Container(
                            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12, right: 10.0),
                            height: MediaQuery.of(context).size.height * 0.12,
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                                color: AppColors.colorBlueLight,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(color: Colors.black38, offset: Offset(1.0, 6.0), blurRadius: 6.0),
                                ]),
                            child: Icon(Icons.gps_fixed, color: Colors.white)),
                      )),
                ],
              ));
  }
}
