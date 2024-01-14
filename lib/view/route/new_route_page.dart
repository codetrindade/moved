import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/base/base_view.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/bloc/route/route_bloc.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/chat.dart';
import 'package:movemedriver/model/response.dart';
import 'package:movemedriver/model/routeobj.dart';
import 'package:movemedriver/presenter/new_route_presenter.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class NewRoutePage extends StatefulWidget {
  @override
  _NewRoutePageState createState() => _NewRoutePageState();
}

class _NewRoutePageState extends BaseState<NewRoutePage> implements NewRoutePageView {
  RouteBloc bloc;
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  StreamController<double> gpsStreamController = StreamController<double>();
  GoogleMapController mapController;
  PanelController _controller;
  BitmapDescriptor imgDestination;
  BitmapDescriptor imgCar;
  NewRoutePresenter _presenter;
  RouteObj model;
  DateTime arrivalTime = DateTime.now();
  double distanceETA = 0;
  double lastDistancePin1;
  double lastDistancePin2;
  double durationEstimate = 0;
  double progressBarPercentage = 0.0;
  double seconds = 0.0;
  bool _isLoading = true;
  bool routeActive = false;
  bool recalculating = false;
  bool arriveUser = false;
  bool stopEta = false;
  bool arrived = false;

  _NewRoutePageState() {
    _presenter = NewRoutePresenter(this);
    model = RouteObj();
    if (AppState().activeRoute.data.status == 'accepted' ||
        AppState().activeRoute.data.status == 'in_progress') {
      this.routeActive = true;
    }
    AppState().gpsStreamController.add(gpsStreamController);
    _controller = PanelController();
  }

  setBitmaps() async {
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/destination.png')
        .then((value) {
      imgDestination = value;
    });

    imgCar = BitmapDescriptor.fromBytes(await new Util().getBytesFromCanvas(
        MediaQuery.of(context).devicePixelRatio.round() * 50,
        MediaQuery.of(context).devicePixelRatio.round() * 50,
        'assets/images/navigation.png'));
  }

  setCameraPos() {
    var center = Util.computeCentroid(model.listPoints);
    var distance = Util.distanceToCenter(center, model.listPoints);
    var zoom = Util.calculateZoomByWidthAndDistance(MediaQuery.of(context).size.width, distance);
    model.initialPosition = CameraPosition(target: center, zoom: zoom);
    setPoints();
    if (_isLoading) {
      timerToCancel();
      _isLoading = false;
    }
    setState(() {});
  }

  timerToCancel() {
    Timer.periodic(Duration(milliseconds: 10), (Timer t) {
      try {
        seconds = seconds + 0.01;
        progressBarPercentage = 1 / 30 * seconds;
        if (routeActive)
          t.cancel();
        else if (seconds >= 30) {
          t.cancel();
          cancelRoute();
        }
        setState(() {});
      } catch (ex) {
        t.cancel();
      }
    });
  }

  setPoints() {
    model.points.clear();
    if (model.listPoints.isNotEmpty) {
      model.points.add(Marker(
          markerId: MarkerId('Destination'),
          position: LatLng(model.listPoints.last.latitude, model.listPoints.last.longitude),
          icon: imgDestination));
    }
    model.points.add(Marker(
        markerId: MarkerId('Driver'),
        anchor: Offset(0.5, 0.5),
        position: model.listPoints.isNotEmpty && !arriveUser && !arrived
            ? LatLng(model.listPoints.first.latitude, model.listPoints.first.longitude)
            : LatLng(AppState.pos.latitude, AppState.pos.longitude),
        icon: imgCar));
  }

  cancelRoute() {
    bloc.setLoading(true);
    _presenter.cancelRoute(AppState().activeRoute.data.id);
  }

  checkEnd() {
    bloc.setLoading(true);
    if (AppState().activeRoute.data.leftPoints <= 1)
      _presenter.finishRoute(AppState().activeRoute.data.id);
    else
      _presenter.checkPoint(AppState().activeRoute.data.id, AppState().activeRoute.data.nextPointId);
  }

  updateMyPos() {
    if (recalculating || arrived || model.listPoints.isEmpty) return;
    LatLng posPin1 = model.listPoints[0];
    double myLat = AppState.pos.latitude;
    double myLong = AppState.pos.longitude;

    double distancePin1 = Util.haversine(myLat, myLong, posPin1.latitude, posPin1.longitude) * 1000.0;

    double distanceToEnd =
        Util.haversine(myLat, myLong, model.listPoints.last.latitude, model.listPoints.last.longitude) *
            1000.0;

    if (lastDistancePin1 == null) {
      lastDistancePin1 = distancePin1;
      return;
    }

    if (distanceToEnd <= 50.0) {
      if (!arriveUser)
        onArriveUser();
      else if (AppState().activeRoute.data.status == 'in_progress') onArrival();
    }

    if (model.listPoints.length == 1) return;

    LatLng posPin2 = model.listPoints[1];
    double distancePin2 = Util.haversine(myLat, myLong, posPin2.latitude, posPin2.longitude) * 1000.0;

    if (lastDistancePin2 == null) lastDistancePin2 = distancePin2;

    if (distancePin2 < distancePin1) {
      print('REMOVE FIRST POINT');
      if (model.listPoints.length > 1) model.listPoints.removeAt(0);
      lastDistancePin1 = distancePin2;
      lastDistancePin2 = null;
      return;
    }

    if (lastDistancePin1 > distancePin1) {
      lastDistancePin1 = distancePin1;
      lastDistancePin2 = distancePin2;
      return;
    }

    if (distancePin1 >= 40.0 && distancePin2 > lastDistancePin2) {
      print('RECALCULATING');
      //Util.showRecalculating(context);
      stopEta = true;
      setState(() {
        polyLines.clear();
        model.listPoints.clear();
        recalculating = true;
        lastDistancePin1 = null;
        lastDistancePin2 = null;
      });
      _presenter.recalculate(AppState().activeRoute.data.id);
      return;
    } else {
      lastDistancePin1 = distancePin1;
      lastDistancePin2 = distancePin2;
    }
  }

  disposeStream() {
    AppState().gpsStreamController.remove(gpsStreamController);
    gpsStreamController.close();
  }

  onArriveUser() {
    if (arriveUser) return;
    arriveUser = true;
    stopEta = true;
    _presenter.notifyUser(AppState().activeRoute.data.id);
  }

  onArrival() {
    gpsStreamController.close();
    Util.showMessage(context, 'Concluído', 'Você chegou ao seu destino');
  }

  drawLine() {
    Polyline polyline = Polyline(
        polylineId: PolylineId('linha1'),
        consumeTapEvents: false,
        color: AppColors.colorBlueDarkOpacity,
        width: MediaQuery.of(context).devicePixelRatio.round() * 3,
        points: model.listPoints);

    polyLines[PolylineId('linha1')] = polyline;
  }

  openMapAvailable() async {
    var lat = model.listPoints.last.latitude;
    var lng = model.listPoints.last.longitude;
    await openMapsSheet(lat, lng);
  }

  startPeriodicETA() {
    Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (!mounted)
        t.cancel();
      else
        calculateETA();
    });
  }

  calculateETA() {
    if (stopEta) {
      arrivalTime = new DateTime.now();
      distanceETA = 0;
      durationEstimate = 0;
      AppState().activeRoute.data.travelledDistance = 0;
      return;
    }
    var a = AppState().activeRoute.data.distance - (AppState().activeRoute.data.travelledDistance / 1000);
    distanceETA = a > 0 ? a : 0;
    durationEstimate = AppState().activeRoute.data.durationEstimate *
        distanceETA /
        (AppState().activeRoute.data.distance > 0 ? AppState().activeRoute.data.distance : 1);
    arrivalTime = new DateTime.now().add(Duration(minutes: durationEstimate.round()));
  }

  Future<void> updateCamera() async {
    mapController.animateCamera(CameraUpdate.newCameraPosition(model.initialPosition));
  }

  resetParameters(ResponseData response) {
    AppState().activeRoute.data.durationEstimate = response.durationEstimate;
    AppState().activeRoute.data.distance = response.distance;
    AppState().activeRoute.data.polyline = response.polyline;
    AppState().activeRoute.data.address = response.address;
    if (response.address != null && response.address.isNotEmpty)
      AppState().activeRoute.data.address = response.address;
    AppState().activeRoute.data.nextPointId = response.nextPointId;
    AppState().setActiveRoute(AppState().activeRoute);
    stopEta = false;
    model.listPoints = Util.decodePolyline(response.polyline);
    drawLine();
    recalculating = false;
    setPoints();
    calculateETA();
    setState(() {});
    bloc.setLoading(false);
  }

  openChat() {
    eventBus.fire(CreateOrOpenNewChatEvent('route', AppState().activeRoute.data.id));
  }

  callUser(String phone) {
    launch('tel://$phone');
  }

  openMapsSheet(double lat, double lng) async {
    try {
      final availableMaps = await MapLauncher.installedMaps;

      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: SingleChildScrollView(
                  child: Container(
                      child: Wrap(children: <Widget>[
            for (var map in availableMaps)
              ListTile(
                  onTap: () => map.showMarker(coords: Coords(lat, lng), title: ''),
                  title: Text(map.mapName),
                  leading: SvgPicture.asset(map.icon, height: 30.0, width: 30.0))
          ]))));
        },
      );
    } catch (e) {
      print(e);
    }
  }

  centerMap() {
    if (mapController != null)
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(AppState.pos.latitude, AppState.pos.longitude),
          bearing: AppState.pos.heading,
          zoom: 16)));
  }

  @override
  initState() {
    super.initState();
    Future.microtask(() {
      setBitmaps();
      model.listPoints = Util.decodePolyline(AppState().activeRoute.data.polyline);
      drawLine();
      setPoints();
      setCameraPos();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RouteBloc>(context);
    return WillPopScope(
        onWillPop: () {
          return;
        },
        child: _isLoading || bloc.isLoading
            ? Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
            : Scaffold(
                appBar: PreferredSize(
                    child: AppBar(
                      elevation: 0.0,
                    ),
                    preferredSize: Size.fromHeight(0.0)),
                body: GestureDetector(
                    onTap: () {
                      if (routeActive) return;
                      bloc.setLoading(true);
                      routeActive = true;
                      _presenter.acceptRoute(AppState().activeRoute.data.id);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height * (routeActive ? 1 : 0.75),
                            child: GoogleMap(
                              /*mapType: MapType.normal,*/
                              markers: model.points,
                              compassEnabled: false,
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              tiltGesturesEnabled: true,
                              trafficEnabled: true,
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
                              initialCameraPosition: model.initialPosition,
                              polylines: polyLines != null ? Set<Polyline>.of(polyLines.values) : null,
                              rotateGesturesEnabled: true,
                              zoomGesturesEnabled: true,
                              onMapCreated: (GoogleMapController controller) {
                                mapController = controller;
                              },
                            )),

                        // painel inferior
                        routeActive
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: SlidingUpPanel(
                                    controller: _controller,
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(30.0),
                                    minHeight: MediaQuery.of(context).size.height * 0.15,
                                    maxHeight: MediaQuery.of(context).size.height * 0.55,
                                    panel: Container(
                                        height: MediaQuery.of(context).size.height * 0.25,
                                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                        decoration: BoxDecoration(
                                            gradient: appGradient,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0))),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(durationEstimate.round().toString() + ' min',
                                                    style: AppTextStyle.textWhiteSmallBold),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Text('•', style: AppTextStyle.textWhiteSmallBold),
                                                ),
                                                Text(Util.timeHourFormatter.format(arrivalTime),
                                                    style: AppTextStyle.textWhiteBigBold),
                                                Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                  child: Text('•', style: AppTextStyle.textWhiteSmallBold),
                                                ),
                                                Text(distanceETA.toStringAsFixed(1) + ' km',
                                                    style: AppTextStyle.textWhiteSmallBold),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Flexible(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                    child: Text(
                                                        AppState().activeRoute.data.status == 'in_progress'
                                                            ? 'Levando: '
                                                            : 'Buscando: ',
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 1,
                                                        style: AppTextStyle.textWhiteSmallBold),
                                                  ),
                                                  Text(AppState().activeRoute.data.user.name,
                                                      maxLines: 1, style: AppTextStyle.textWhiteSmall),
                                                ],
                                              ),
                                            ),
                                            Container(
                                                color: Colors.white,
                                                height: 2.0,
                                                margin: EdgeInsets.only(top: 15.0, bottom: 15.0)),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 60.0,
                                                  margin: EdgeInsets.only(right: 15.0),
                                                  child: AppState().activeRoute.data.user.photo == null ||
                                                          AppState().activeRoute.data.user.photo.isEmpty
                                                      ? ClipOval(
                                                          child: Image.asset('assets/images/user.png',
                                                              fit: BoxFit.cover))
                                                      : ClipOval(
                                                          child: FadeInImage.assetNetwork(
                                                              placeholder: 'assets/images/user.png',
                                                              image: AppState().activeRoute.data.user.photo,
                                                              fit: BoxFit.fill)),
                                                ),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(AppState().activeRoute.data.user.name,
                                                        style: AppTextStyle.textWhiteSmallBold),
                                                    SizedBox(height: 5.0),
                                                    Row(
                                                      children: <Widget>[
                                                        Icon(Icons.star, color: Colors.white, size: 20.0),
                                                        SizedBox(width: 5.0),
                                                        Text('0.0', style: AppTextStyle.textBoldWhiteMedium),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                            Container(
                                                color: Colors.white,
                                                height: 2.0,
                                                margin: EdgeInsets.only(top: 15.0, bottom: 15.0)),
                                            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <
                                                Widget>[
                                              SizedBox(width: 20.0),
                                              GestureDetector(
                                                  onTap: () => openChat(),
                                                  child: Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(color: AppColors.colorWhite)),
                                                      child: Icon(MoveMeIcons.speech_bubble,
                                                          color: Colors.white))),
                                              if (AppState().activeRoute.data.user.displayMyPhone)
                                                GestureDetector(
                                                    onTap: () =>
                                                        callUser(AppState().activeRoute.data.user.phone),
                                                    child: Container(
                                                        padding: EdgeInsets.all(10.0),
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            border: Border.all(color: AppColors.colorWhite)),
                                                        child: Icon(MoveMeIcons.phone_call,
                                                            color: Colors.white))),
                                              GestureDetector(
                                                  onTap: () => openMapAvailable(),
                                                  child: Container(
                                                      padding: EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(color: AppColors.colorWhite)),
                                                      child: Icon(Icons.map, color: Colors.white))),
                                              SizedBox(width: 20.0)
                                            ]),
                                            Container(
                                                color: Colors.white,
                                                height: 2.0,
                                                margin: EdgeInsets.only(top: 15.0, bottom: 15.0)),
                                            AppState().activeRoute.data.status == 'in_progress'
                                                ? FlatButton(
                                                    padding: EdgeInsets.all(0),
                                                    onPressed: () => checkEnd(),
                                                    child: Container(
                                                        height: AppSizes.buttonHeight,
                                                        decoration: BoxDecoration(
                                                            color: AppState().activeRoute.data.leftPoints <= 1
                                                                ? AppColors.colorPurpleLight
                                                                : AppColors.colorGreen,
                                                            borderRadius: AppSizes.buttonCorner),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text(
                                                                  AppState().activeRoute.data.leftPoints <= 1
                                                                      ? 'Finalizar Corrida'
                                                                      : 'Próxima Parada',
                                                                  style: AppTextStyle.textWhiteSmallBold)
                                                            ],
                                                          ),
                                                        )))
                                                : (FlatButton(
                                                    onPressed: () {
                                                      bloc.setLoading(true);
                                                      disposeStream();
                                                      _presenter.startRoute(AppState().activeRoute.data.id);
                                                    },
                                                    padding: EdgeInsets.all(0),
                                                    child: Container(
                                                        height: AppSizes.buttonHeight,
                                                        decoration: BoxDecoration(
                                                            color: AppColors.colorGreen,
                                                            borderRadius: AppSizes.buttonCorner),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text('Iniciar Corrida',
                                                                  style: AppTextStyle.textWhiteSmallBold)
                                                            ],
                                                          ),
                                                        ))))
                                          ],
                                        )),
                                    collapsed: GestureDetector(
                                      onTap: () {
                                        _controller.open();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                        decoration: BoxDecoration(
                                            gradient: appGradient,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30.0),
                                                topRight: Radius.circular(30.0))),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                                height: 4.0,
                                                width: MediaQuery.of(context).size.width * 0.2,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(30.0))),
                                            SizedBox(height: 15.0),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(durationEstimate.round().toString() + ' min',
                                                    style: AppTextStyle.textWhiteSmallBold),
                                                Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                    child: Text('•', style: AppTextStyle.textWhiteSmallBold)),
                                                Text(Util.timeHourFormatter.format(arrivalTime),
                                                    style: AppTextStyle.textWhiteBigBold),
                                                Container(
                                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                                    child: Text('•', style: AppTextStyle.textWhiteSmallBold)),
                                                Text(distanceETA.toStringAsFixed(1) + ' km',
                                                    style: AppTextStyle.textWhiteSmallBold),
                                              ],
                                            ),
                                            SizedBox(height: 15.0),
                                            Flexible(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Flexible(
                                                      child: Text(
                                                          AppState().activeRoute.data.status == 'in_progress'
                                                              ? 'Levando: '
                                                              : 'Buscando: ',
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: AppTextStyle.textWhiteSmallBold)),
                                                  Text(AppState().activeRoute.data.user.name,
                                                      maxLines: 1, style: AppTextStyle.textWhiteSmall),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )))
                            : Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    height: MediaQuery.of(context).size.height * 0.46,
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width * 0.1,
                                        right: MediaQuery.of(context).size.width * 0.1,
                                        bottom: 15.0),
                                    decoration: BoxDecoration(
                                        gradient: appGradient,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0))),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(height: MediaQuery.of(context).size.height * 0.09),
                                          Row(
                                            children: <Widget>[
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('Distância:',
                                                        style: AppTextStyle.textBlueLightSmallBold),
                                                    Text(
                                                        AppState()
                                                                .activeRoute
                                                                .data
                                                                .distance
                                                                .toStringAsFixed(0) +
                                                            ' km',
                                                        style: AppTextStyle.textWhiteSmallBold),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text('Pagamento:',
                                                        style: AppTextStyle.textBlueLightSmallBold),
                                                    Text(AppState().activeRoute.data.payment,
                                                        style: AppTextStyle.textWhiteSmallBold),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                              color: Colors.white,
                                              height: 2.0,
                                              margin: EdgeInsets.symmetric(vertical: 10.0)),
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Container(
                                                  height: 60.0,
                                                  margin: EdgeInsets.only(right: 15.0),
                                                  child: AppState().activeRoute.data.user.photo == null ||
                                                          AppState().activeRoute.data.user.photo.isEmpty
                                                      ? ClipOval(
                                                          child: Image.asset('assets/images/user.png',
                                                              fit: BoxFit.cover))
                                                      : ClipOval(
                                                          child: FadeInImage.assetNetwork(
                                                              placeholder: 'assets/images/user.png',
                                                              image: AppState().activeRoute.data.user.photo,
                                                              fit: BoxFit.fill),
                                                        ),
                                                ),
                                                Expanded(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: <Widget>[
                                                      Text(AppState().activeRoute.data.user.name,
                                                          style: AppTextStyle.textWhiteSmallBold),
                                                      SizedBox(height: 10.0),
                                                      Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: <Widget>[
                                                            Icon(Icons.star, color: Colors.white, size: 20.0),
                                                            SizedBox(width: 5.0),
                                                            Text(AppState().activeRoute.data.user.rating,
                                                                style: AppTextStyle.textBoldWhiteMedium)
                                                          ])
                                                    ]))
                                              ]),
                                          Container(
                                              color: Colors.white,
                                              height: 2.0,
                                              margin: EdgeInsets.symmetric(vertical: 10.0)),
                                          Center(
                                              child: Text('Toque na tela para confirmar',
                                                  style: AppTextStyle.textWhiteSmallBold)),
                                          Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.8 *
                                                progressBarPercentage,
                                            margin: EdgeInsets.symmetric(vertical: 10.0),
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(30.0)),
                                          )
                                        ]))),

                        if (!routeActive)
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.42,
                                      left: 30.0,
                                      right: 30.0),
                                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: AppColors.colorGreenLight,
                                          style: BorderStyle.solid,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(30.0)),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    Text('R\$ ' + AppState().activeRoute.data.price,
                                        style: AppTextStyle.textBlueDarkSmallBold)
                                  ]))),

                        // painel superior de endereços
                        if (routeActive)
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  margin: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.colorGradientPrimary,
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          child: Text(AppState().activeRoute.data.address,
                                              style: AppTextStyle.textWhiteSmallBold, maxLines: 3)),
                                      Container(
                                          width: 2.0,
                                          height: MediaQuery.of(context).size.height * 0.1,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(left: 5.0)),
                                      InkWell(
                                          child: Icon(Icons.navigation, color: Colors.white, size: 30.0),
                                          onTap: openMapAvailable),
                                    ],
                                  )))
                        else
                          Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  margin: EdgeInsets.only(top: 20.0),
                                  child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                        for (var address in AppState().activeRoute.data.destinies)
                                          Container(
                                              padding:
                                                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                                              margin: EdgeInsets.only(
                                                  right: address == AppState().activeRoute.data.destinies.last
                                                      ? 0
                                                      : 10),
                                              width: MediaQuery.of(context).size.width * 0.9,
                                              height: 110,
                                              decoration: BoxDecoration(
                                                  color: AppColors.colorGradientPrimary,
                                                  borderRadius: BorderRadius.circular(20.0)),
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                            address ==
                                                                    AppState()
                                                                        .activeRoute
                                                                        .data
                                                                        .destinies
                                                                        .first
                                                                ? 'Buscar Cliente em'
                                                                : (address ==
                                                                        AppState()
                                                                            .activeRoute
                                                                            .data
                                                                            .destinies
                                                                            .last
                                                                    ? 'Destino Final'
                                                                    : 'Parada'),
                                                            style: AppTextStyle.textWhiteSmallBold),
                                                        Text(address,
                                                            style: AppTextStyle.textWhiteSmall, maxLines: 2),
                                                      ],
                                                    ),
                                                  ),
                                                  if (address != AppState().activeRoute.data.destinies.last)
                                                    Icon(Icons.double_arrow_rounded, color: Colors.white)
                                                ],
                                              ))
                                      ])))),

                        // contador de km/h
                        if (routeActive)
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                  margin: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).size.height * 0.6, left: 10.0),
                                  height: MediaQuery.of(context).size.height * 0.12,
                                  padding: EdgeInsets.all(15.0),
                                  decoration: BoxDecoration(
                                      color: AppColors.colorGradientPrimary,
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black38, offset: Offset(1.0, 6.0), blurRadius: 6.0)
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text((AppState.pos.speed * (100 / 28)).round().toString(),
                                          style: AppTextStyle.textBoldWhiteMedium),
                                      Text('km/h', style: AppTextStyle.textWhiteExtraSmall),
                                    ],
                                  ))),

                        // center map
                        if (routeActive)
                          Align(
                              alignment: Alignment.bottomRight,
                              child: InkWell(
                                onTap: () => centerMap(),
                                child: Container(
                                    margin: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height * 0.6, right: 10.0),
                                    height: MediaQuery.of(context).size.height * 0.12,
                                    padding: EdgeInsets.all(15.0),
                                    decoration: BoxDecoration(
                                        color: AppColors.colorGradientPrimary,
                                        shape: BoxShape.circle,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.black38,
                                              offset: Offset(1.0, 6.0),
                                              blurRadius: 6.0)
                                        ]),
                                    child: Icon(Icons.gps_fixed, color: Colors.white)),
                              ))
                      ],
                    ))));
  }

  @override
  void dispose() {
    mapController.dispose();
    disposeStream();
    bloc.isLoading = false;
    super.dispose();
  }

  @override
  void onAcceptRouteSuccess(ResponseData response) async {
    AppState().activeRoute.data.durationEstimate = response.durationEstimate;
    AppState().activeRoute.data.distance = response.distance;
    AppState().activeRoute.data.polyline = response.polyline;
    model.listPoints = Util.decodePolyline(response.polyline);
    drawLine();
    calculateETA();
    startPeriodicETA();
    AppState().activeRoute.data.status = 'accepted';
    AppState().setActiveRoute(AppState().activeRoute);
    model.initialPosition = CameraPosition(
        target: LatLng(model.listPoints[0].latitude, model.listPoints[0].longitude),
        bearing: AppState.pos.heading,
        zoom: 18);
    updateCamera();
    setState(() {});
    bloc.setLoading(false);
    gpsStreamController.stream
        .listen((data) {
          AppState().activeRoute.data.travelledDistance += data;
          setState(() {
            model.initialPosition = CameraPosition(
                target: model.listPoints.isNotEmpty
                    ? LatLng(model.listPoints.first.latitude, model.listPoints.first.longitude)
                    : LatLng(AppState.pos.latitude, AppState.pos.longitude),
                bearing: AppState.pos.heading,
                zoom: 18);
            updateCamera();
            setPoints();
            updateMyPos();
          });
        })
        .asFuture()
        .catchError((_) {
          disposeStream();
        });
  }

  @override
  void onCancelSuccess() {
    AppState().activeRoute.data.status = 'refused';
    Navigator.pop(context);
  }

  @override
  void onAcceptRouteError(String message) {
    _isLoading = false;
    bloc.setLoading(false);
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onRecalculateSuccess(ResponseData response) {
    resetParameters(response);
  }

  @override
  void onCheckPointSuccess(ResponseData response) {
    AppState().activeRoute.data.leftPoints = response.leftPoints;
    resetParameters(response);
  }

  @override
  void onStartRouteSuccess(ResponseData response) {
    AppState().activeRoute.data.status = 'in_progress';
    AppState().activeRoute.data.leftPoints = response.leftPoints;
    AppState().activeRoute.data.address = response.address;
    resetParameters(response);

    gpsStreamController = StreamController<double>();
    AppState().gpsStreamController.add(gpsStreamController);
    gpsStreamController.stream
        .listen((data) {
          AppState().activeRoute.data.travelledDistance += data;
          setState(() {
            model.initialPosition = CameraPosition(
                target: model.listPoints.isNotEmpty
                    ? LatLng(model.listPoints.first.latitude, model.listPoints.first.longitude)
                    : LatLng(AppState.pos.latitude, AppState.pos.longitude),
                bearing: AppState.pos.heading,
                zoom: 18);
            updateCamera();
            setPoints();
            updateMyPos();
          });
        })
        .asFuture()
        .catchError((_) {
          disposeStream();
        });
    bloc.setLoading(false);
  }

  @override
  void onFinishedRouteSuccess() {
    bloc.setLoading(false);
    Navigator.pop(context);
    AppState().activeRoute.data.status = 'finished';
    AppState().setActiveRoute(AppState().activeRoute);

    eventBus.fire(RouteFinishedEvent(id: AppState().activeRoute.data.id));
  }

  @override
  void onCancelRouteError() {
    Navigator.pop(context);
  }

  @override
  void onGetChatSuccess(Chat data) {
    bloc.setLoading(false);
  }
}

abstract class NewRoutePageView extends BaseView {
  void onCancelSuccess();

  void onAcceptRouteSuccess(ResponseData response);

  void onStartRouteSuccess(ResponseData response);

  void onAcceptRouteError(String message);

  void onFinishedRouteSuccess();

  void onRecalculateSuccess(ResponseData response);

  void onCheckPointSuccess(ResponseData response);

  void onCancelRouteError();

  void onGetChatSuccess(Chat data);
}
