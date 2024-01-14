import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/model/points.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/ride/address_route/address_route_page.dart';
import 'package:movemedriver/view/ride/detail_passenger.dart';
import 'package:movemedriver/view/ride/passenger_confirmation.dart';
import 'package:provider/provider.dart';

class RideRegister extends StatefulWidget {
  @override
  _RideRegisterState createState() => _RideRegisterState();
}

class _RideRegisterState extends BaseState<RideRegister> {
  RideBloc bloc;

  int _page = 0;
  DateTime _datePicked = new DateTime.now().add(new Duration(days: 31));
  DateTime _dateTimePicked = new DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  final formatterDate = new DateFormat('yyyy-MM-dd');
  final formatterTime = new DateFormat('HH:mm');
  PageController _pageController;

  _RideRegisterState() {
    _pageController = new PageController();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (bloc.model == null) {
        bloc.myAddressNow.lat = AppState.pos.latitude;
        bloc.myAddressNow.long = AppState.pos.longitude;
        bloc.getFromCoordinates(new Address(lat: bloc.myAddressNow.lat, long: bloc.myAddressNow.long));
      } else {
        setParameters();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.clear();
  }

  void setParameters() {
    bloc.newRide = false;
    bloc.myAddressNow.address = bloc.model.points.first.address;
    bloc.people = bloc.model.reservations;
    _dateTimePicked = DateTime.parse('0000-00-00 ' + bloc.model.time + ':00');
    _datePicked = DateTime.parse(bloc.model.date + ' 00:00:00');
    bloc.model.points.forEach((p) {
      if (p.order == 0) return;
      bloc.listRideAddress.add(new Address(address: p.address, order: p.order));
    });
    bloc.refresh();
  }

  Future<void> onSubmit() async {
    if (_dateTimePicked == null) {
      bloc.dialogService.showDialog('Atenção', 'Preencha a hora');
      return;
    }

    if (_datePicked == null) {
      bloc.dialogService.showDialog('Atenção', 'Preencha a data');
      return;
    }

    if (bloc.listRideAddress == null || bloc.listRideAddress.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Preencha o destino');
      return;
    }

    if (bloc.myAddressNow == null) {
      bloc.dialogService.showDialog('Atenção', 'Preencha a origem');
      return;
    }

    if (bloc.newRide) {
      bloc.model = new Ride();
      bloc.model.date = formatterDate.format(_datePicked);
      bloc.model.time = formatterTime.format(_dateTimePicked);
      bloc.model.reservations = bloc.people;
      bloc.model.back = false;

      bloc.model.points = [];

      bloc.model.points.add(new Points(
          price: 0,
          order: 0,
          address: bloc.myAddressNow.address,
          long: bloc.myAddressNow.long.toString(),
          lat: bloc.myAddressNow.lat.toString()));

      bloc.listRideAddress.forEach((r) {
        bloc.model.points
            .add(new Points(order: r.order, lat: r.lat.toString(), long: r.long.toString(), address: r.address));
      });

      var a = await Navigator.push(
          context, new MaterialPageRoute(builder: (context) => new PassengerConfirmation()));

      if (a != null) Navigator.pop(context);
      return;
    } else {
      bloc.model.reservations = bloc.people;
      bloc.model.date = formatterDate.format(_datePicked);
      bloc.model.time = formatterTime.format(_dateTimePicked);
      bloc.update(bloc.model);
    }
  }

  void approve(String passengerId) {
    bloc.isPassengersLoading = true;
    bloc.approvePassenger(bloc.model.id, passengerId);
  }

  changePeopleQuantity(bool add) {
    setState(() {
      bloc.people = bloc.people + (add ? 1 : -1);
      if (bloc.people == 0) bloc.people = 1;
      if (bloc.people == bloc.maxPeople + 1) bloc.people = bloc.maxPeople;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context, initialTime: new TimeOfDay(hour: _dateTimePicked.hour, minute: _dateTimePicked.minute));

    if (picked != null) {
      setState(() {
        _dateTimePicked = new DateTime(0, 0, 0, picked.hour, picked.minute, 0, 0, 0);
      });
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _datePicked,
        firstDate: _datePicked,
        lastDate: _datePicked.add(new Duration(days: 720)));

    setState(() {
      _datePicked = new DateTime(picked.year, picked.month, picked.day, 0, 0);
    });
    }

  setRides() {
    var items = <Widget>[];
    bloc.listRideAddress.asMap().forEach((index, Address model) {
      items.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(model.order.toString() + ". ", style: AppTextStyle.textBlueLightSmallBold),
          Expanded(
            child: Text(
              model.address,
              style: AppTextStyle.textBlueDarkSmall,
            ),
          )
        ],
      ));
      items.add(SizedBox(height: 5.0));
    });
    return items;
  }

  choosePoints() async {
    if (!bloc.newRide) return;
    var a = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddressRoutePage()));
    if (a != null)
      setState(() {
        bloc.listRideAddress = a;
      });
  }

  void navigationTapped(int page) {
    _page = page;
    setState(() {
      _pageController.animateToPage(page, duration: const Duration(milliseconds: 600), curve: Curves.ease);
    });
  }

  Widget bodyRide(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.colorGreenLight,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(bloc.newRide ? 'Oferecer Carona' : 'Editar Carona', style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(0),
                children: <Widget>[
                  !bloc.newRide
                      ? Container(
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(bloc.model.back ? 'Volta' : 'Ida',
                                        style: AppTextStyle.textBlueLightSmallBold),
                                  ),
                                  new Column(
                                    children: <Widget>[
                                      new Icon(Icons.arrow_forward, color: AppColors.colorBlueLight, size: 20.0),
                                      new Icon(Icons.arrow_back, color: AppColors.colorGreenLight, size: 20.0),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10.0),
                              Container(color: AppColors.colorGreenLight, height: 1.0)
                            ],
                          ))
                      : SizedBox(),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () async {
                      if (!bloc.newRide) return;
                      var a = await Navigator.push(
                          context, new MaterialPageRoute(builder: (context) => AddressRoutePage(choosingOrigin: true)));
                      if (a != null)
                        setState(() {
                          bloc.myAddressNow = a[0];
                        });
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 15),
                              Text('Origem', style: AppTextStyle.textBlueLightSmallBold),
                              Text(bloc.myAddressNow.address, style: AppTextStyle.textBlueDarkSmall),
                            ],
                          ),
                        ),
                        bloc.newRide
                            ? new Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorGreenLight)
                            : new SizedBox()
                      ],
                    ),
                  ),
                  new SizedBox(height: 5.0),
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () => choosePoints(),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Destino (s)', style: AppTextStyle.textBlueLightSmallBold),
                            ],
                          ),
                        ),
                        bloc.newRide
                            ? Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorGreenLight)
                            : SizedBox(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => choosePoints(),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: setRides()),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.colorGreenLight),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _selectDate(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Data', style: AppTextStyle.textBlueLightSmallBold),
                              Text(Util.dateTimeFormatter.format(_datePicked), style: AppTextStyle.textBlueDarkSmall),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorGreenLight)
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.colorGreenLight),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Horário', style: AppTextStyle.textBlueLightSmallBold),
                              Text(Util.timeFormatter.format(_dateTimePicked), style: AppTextStyle.textBlueDarkSmall),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorGreenLight)
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color: AppColors.colorGreenLight),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  bloc.newRide
                      ? Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Número de Reservas', style: AppTextStyle.textBlueLightSmallBold),
                                  Text(bloc.people.toString() + ' Pessoas', style: AppTextStyle.textWhiteSmall),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  iconSize: 16,
                                  onPressed: () {
                                    changePeopleQuantity(false);
                                  },
                                  icon: Icon(Icons.remove, size: 16.0, color: AppColors.colorGreenLight),
                                ),
                                Container(
                                    padding: EdgeInsets.all(4.0),
                                    height: 27.0,
                                    width: 27.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                                        borderRadius: AppSizes.buttonCorner * 0.30),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child:
                                              Text(bloc.people.toString(), style: AppTextStyle.textBlueLightExtraSmall),
                                        ),
                                      ],
                                    )),
                                IconButton(
                                  iconSize: 16,
                                  onPressed: () {
                                    changePeopleQuantity(true);
                                  },
                                  icon: Icon(Icons.add, size: 16.0, color: AppColors.colorGreenLight),
                                ),
                              ],
                            ),
                          ],
                        )
                      : FlatButton(
                          padding: EdgeInsets.all(0.0),
                          onPressed: () {
                            bloc.getPassenger(bloc.model.id);
                            navigationTapped(1);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Row(children: <Widget>[
                                bloc.model.pending
                                    ? Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                                        child:
                                            Icon(Icons.notification_important, size: 20.0, color: AppColors.colorGreen))
                                    : SizedBox(),
                                Expanded(
                                    child: Text('Administrar passageiros', style: AppTextStyle.textBlueLightSmallBold)),
                                Icon(Icons.arrow_forward_ios, size: 16.0, color: AppColors.colorGreenLight)
                              ]))),
                  Container(
                    decoration: BoxDecoration(color: AppColors.colorGreenLight),
                    margin: EdgeInsets.only(top: 8, bottom: 20.0),
                    height: 1.0,
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSizes.inputPaddingHorizontalDouble),
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    onSubmit();
                  },
                  child: Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(color: AppColors.colorGreenLight, borderRadius: AppSizes.buttonCorner),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(bloc.newRide ? 'Continuar' : 'Salvar', style: AppTextStyle.textWhiteSmallBold)
                          ],
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }

  Widget bodyRidePassengers(BuildContext context) {
    return bloc.isLoading
        ? new Container(
            color: Colors.white,
            child: new Center(
                child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
        : new Scaffold(
            appBar: new AppBar(
              backgroundColor: AppColors.colorGreenLight,
              elevation: 0.0,
              centerTitle: true,
              leading: new IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.colorGreenLight, size: 16.0),
                  onPressed: () {
                    navigationTapped(0);
                  }),
              title: new Text('Administrar Passageiros', style: AppTextStyle.textWhiteSmallBold),
            ),
            body: Container(
              decoration: new BoxDecoration(gradient: appGradient),
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Número de Reservas', style: AppTextStyle.textBlueLightSmallBold),
                            new Text(bloc.people.toString() + ' Pessoas', style: AppTextStyle.textWhiteSmall),
                          ],
                        ),
                      ),
                      new Row(
                        children: <Widget>[
                          new IconButton(
                            iconSize: 16,
                            onPressed: () {
                              changePeopleQuantity(false);
                            },
                            icon: new Icon(Icons.remove, size: 16.0, color: AppColors.colorGreenLight),
                          ),
                          new Container(
                              padding: EdgeInsets.all(5.0),
                              height: 27.0,
                              width: 27.0,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1.0),
                                  borderRadius: AppSizes.buttonCorner * 0.30),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Text(bloc.people.toString(), style: AppTextStyle.textWhiteExtraSmallBold),
                                ],
                              )),
                          new IconButton(
                            iconSize: 16,
                            onPressed: () {
                              changePeopleQuantity(true);
                            },
                            icon: new Icon(Icons.add, size: 16.0, color: AppColors.colorGreenLight),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new Container(color: Colors.white, margin: EdgeInsets.symmetric(vertical: 15.0), height: 1.0),
                  new SizedBox(height: 10.0),
                  new GestureDetector(
                    onTap: () {
                      setState(() {
                        bloc.model.autoConfirm = !bloc.model.autoConfirm;
                      });
                    },
                    child: new Container(
                      padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 15.0),
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          border: Border.all(color: Colors.white, style: BorderStyle.solid, width: 1.0)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: new Text('Aprovar automaticamente', style: AppTextStyle.textWhiteSmallBold),
                          ),
                          bloc.model != null && bloc.model.autoConfirm != null && bloc.model.autoConfirm
                              ? new Icon(Icons.check, color: Colors.white, size: 20.0)
                              : new SizedBox()
                        ],
                      ),
                    ),
                  ),
                  new SizedBox(height: 10.0),
                  new Container(color: Colors.white, margin: EdgeInsets.symmetric(vertical: 15.0), height: 1.0),
                  new Text('Interessados', style: AppTextStyle.textBlueLightSmallBold, textAlign: TextAlign.start),
                  new SizedBox(
                    height: 10.0,
                  ),
                  new Expanded(
                    child: new ListView.builder(
                        itemCount: bloc.passengers.length,
                        itemBuilder: (BuildContext context, int index) {
                          return userItem(index);
                        }),
                  )
                ],
              ),
            ),
          );
  }

  Widget userItem(int index) {
    return new FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new DetailPassenger(
                      model: bloc.passengers[index],
                      callback: approve,
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(children: <Widget>[
          new ClipOval(
            child: new Image(
              width: 50.0,
              image: AssetImage('assets/images/user.png'),
              height: 50.0,
            ),
          ),
          new SizedBox(
            width: 10.0,
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(bloc.passengers[index].user.name, style: AppTextStyle.textWhiteSmallBold),
                new Row(children: <Widget>[
                  new Text('Avaliação:', style: AppTextStyle.textWhiteExtraSmall),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Icon(
                    MoveMeIcons.man_user,
                    color: Colors.white,
                    size: 15.0,
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Text('4.75', style: AppTextStyle.textWhiteSmallBold)
                ]),
                new Icon(bloc.passengers[index].confirmed ? Icons.check : Icons.access_time,
                    color: bloc.passengers[index].confirmed ? AppColors.colorGreen : Colors.yellow, size: 15.0),
              ],
            ),
          ),
          new Icon(Icons.arrow_forward_ios, color: Colors.white)
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RideBloc>(context);
    return bloc.isLoading
        ? new Container(
            color: Colors.white,
            child: new Center(
                child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight))))
        : WillPopScope(
            onWillPop: () {
              if (_page == 1) {
                navigationTapped(0);
                return;
              }
              if (bloc.updated)
                Navigator.pop(context, true);
              else
                Navigator.pop(context);
            },
            child: PageView(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[bodyRide(context), bodyRidePassengers(context)],
            ));
  }
}
