import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/theme.dart';

class MapComponent extends StatefulWidget {
  final Set<Marker> points;
  final CameraPosition initialPosition;
  final OnMapChanged listener;
  final bool canAutoRefreshInitialPosition;
  final Completer<GoogleMapController> controller;
  final bool showGoToStartButton;
  final Map<PolylineId, Polyline> polyLines;
  final EdgeInsets padding;
  final Function centerMap;

  MapComponent(
      {this.points,
      this.initialPosition,
      @required this.canAutoRefreshInitialPosition,
      this.listener,
      this.padding,
      this.showGoToStartButton = true,
      this.controller,
      this.centerMap,
      this.polyLines});

  @override
  _MapComponentState createState() => _MapComponentState(controller,
      points: points,
      initialPosition: initialPosition,
      canAutoRefreshInitialPosition: canAutoRefreshInitialPosition,
      listener: listener,
      padding: padding,
      centerMap: centerMap,
      showGoToStartButton: showGoToStartButton,
      polyLines: polyLines);
}

class _MapComponentState extends BaseState<MapComponent> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition initialPosition;
  CameraPosition _newPosition;
  Set<Marker> points;
  OnMapChanged listener;
  Map<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{};
  bool canAutoRefreshInitialPosition;
  bool showGoToStartButton;
  EdgeInsets padding;
  Function centerMap;

  _MapComponentState(Completer<GoogleMapController> controller,
      {this.points,
      this.initialPosition,
      this.listener,
      this.showGoToStartButton,
      this.polyLines,
      this.padding,
      this.centerMap,
      this.canAutoRefreshInitialPosition}) {
    _controller = controller;
  }

  Future<void> _goToStart() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(initialPosition ?? AppState().initialPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            markers: points,
            onCameraIdle: () {
              listener.onMapChanged(_newPosition);
            },
            onCameraMove: (pos) {
              _newPosition = pos;
            },
            compassEnabled: false,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: true,
            padding: padding ?? const EdgeInsets.all(0),
            initialCameraPosition: initialPosition ?? AppState().initialPosition,
            polylines: polyLines != null ? Set<Polyline>.of(polyLines.values) : null,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          showGoToStartButton
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.colorWhite, boxShadow: [
                      BoxShadow(color: Colors.black54, blurRadius: 5.0, spreadRadius: 0.5, offset: Offset(2.0, 2.0))
                    ]),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12, right: 15.0),
                    child: IconButton(
                        icon: Icon(Icons.gps_fixed, color: AppColors.colorBlueLight, size: 30.0),
                        onPressed: () => centerMap()),
                  ),
                )
              : SizedBox()
        ],
      ),
    );
  }
}

abstract class OnMapChanged {
  void onMapChanged(CameraPosition newPosition);
}
