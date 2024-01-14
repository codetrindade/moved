import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_light_button.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/ride/ride_register/ride_register.dart';
import 'package:movemedriver/view/ride_list/ride_list_item.dart';
import 'package:provider/provider.dart';

class RideListPage extends StatefulWidget {
  @override
  _RideListPageState createState() => _RideListPageState();
}

class _RideListPageState extends BaseState<RideListPage> {
  RideBloc bloc;
  BitmapDescriptor mapIcon;
  BitmapDescriptor myPosIcon;
  Set<Marker> points = Set<Marker>();

  _RideListPageState();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.list());
  }

  setRides() {
    var items = <Widget>[];
    bloc.listRide.asMap().forEach((index, Ride model) {
      items.add(FlatButton(
          onPressed: () => selectToUpdate(model), padding: EdgeInsets.all(0), child: RideListItem(model: model)));
    });
    items.add(SizedBox(height: MediaQuery.of(context).size.height * 0.1));
    return items;
  }

  selectToUpdate(Ride ride) async {
    bloc.model = ride;
    var a = await Navigator.push(context, MaterialPageRoute(builder: (context) => RideRegister()));

    if (a != null) {
      bloc.list();
    }
  }

  setMapMarkers() async {
    await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/car-top.png').then((value) {
      mapIcon = value;
    });

    await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/start.png').then((value) {
      myPosIcon = value;
    });

    setState(() {
      points = {
        Marker(
            markerId: MarkerId('myPos'),
            position: LatLng(AppState.pos.latitude, AppState.pos.longitude),
            icon: myPosIcon),
        Marker(
            markerId: MarkerId('teste2'), position: LatLng(-23.120000, AppState.pos.longitude - 0.001), icon: mapIcon)
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RideBloc>(context);

    return Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Caronas'),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: bloc.isLoading
            ? Container(
                child: Center(
                    child:
                        CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
            : Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: AppColors.colorTextGreyLight,
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(vertical: AppSizes.inputPaddingVerticalDouble),
                            width: double.infinity,
                            child: BlueLightButton(
                                text: 'Oferecer Carona',
                                callback: () {
                                  if (AppState.user.status == 'inactive')
                                    bloc.dialogService
                                        .showDialog('Atenção', 'Seu usuário ainda não foi ativado pela nossa equipe!');
                                  else
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => RideRegister()));
                                }),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: AppSizes.inputPaddingHorizontalDouble),
                        child: bloc.listRide.isEmpty
                            ? Center(
                                child: Text('Nenhuma carona para exibir no momento',
                                    style: AppTextStyle.textGreySmallBold, textAlign: TextAlign.center),
                              )
                            : ListView(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                scrollDirection: Axis.vertical,
                                children: setRides(),
                              ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
