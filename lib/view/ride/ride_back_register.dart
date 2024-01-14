import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/model/ride.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/ride/passenger_confirmation.dart';

// class RideBackRegister extends StatefulWidget {
//   final Ride model;
//
//   RideBackRegister({@required this.model});
//
//   @override
//   _RideBackRegisterState createState() => _RideBackRegisterState(model: model);
// }
class RideBackRegister extends StatefulWidget {
  RideBackRegister();

  @override
  _RideBackRegisterState createState() => _RideBackRegisterState();
}

class _RideBackRegisterState extends BaseState<RideBackRegister> {
  // Ride model;
  // DateTime _dateTimePicked = new DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  // DateTime _datePicked = new DateTime.now().add(new Duration(days: 31));
  // int people = 1;
  // int maxPeople = 10;
  // final formatterDate = new DateFormat('yyyy-MM-dd');
  // final formatterTime = new DateFormat('HH:mm');
  //
  // _RideBackRegisterState({this.model});

  RideBloc bloc;
  DateTime _dateTimePicked = new DateTime(0, 0, 0, 0, 0, 0, 0, 0);
  DateTime _datePicked = new DateTime.now().add(new Duration(days: 31));
  final formatterDate = new DateFormat('yyyy-MM-dd');
  final formatterTime = new DateFormat('HH:mm');

  _RideBackRegisterState();

  changePeopleQuantity(bool add) {
    setState(() {
      bloc.people = bloc.people + (add ? 1 : -1);
      if (bloc.people == 0) bloc.people = 1;
      if (bloc.people == bloc.maxPeople + 1) bloc.people = bloc.maxPeople;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: new TimeOfDay(
            hour: _dateTimePicked.hour, minute: _dateTimePicked.minute));

    if (picked != null) {
      setState(() {
        _dateTimePicked =
            new DateTime(0, 0, 0, picked.hour, picked.minute, 0, 0, 0);
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

  goToPricesPage() {
    var parsedDate = DateTime.parse(bloc.model.date);
    var parsedTime = DateTime.parse('0000-00-00 ' + bloc.model.time + ':00');
    _datePicked = DateTime.parse(Util.formatterUs.format(_datePicked) + ' 00:00:00');
    if (parsedDate.isAfter(_datePicked)) {
      Util.showMessage(context, 'Atenção',
          'A data de retorno precisa ser igual ou maior que a data de partida');
      return;
    }
    if ((parsedTime.isAfter(_dateTimePicked) ||
            parsedTime.isAtSameMomentAs(_dateTimePicked)) &&
        parsedDate.isAtSameMomentAs(_datePicked)) {
      Util.showMessage(context, 'Atenção',
          'A hora de retorno precisa ser maior que a hora de patida');
      return;
    }
    Ride modelBack = new Ride();
    modelBack.date = formatterDate.format(_datePicked);
    modelBack.time = formatterTime.format(_dateTimePicked);
    modelBack.reservations = bloc.people;
    modelBack.back = true;
    bloc.modelBack = modelBack;
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => new PassengerConfirmation()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: AppColors.colorGreenLight,
        elevation: 0.0,
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
        title:
            new Text('Oferecer Carona', style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            new Expanded(
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
//                          margin: EdgeInsets.all(AppSizes.inputPaddingHorizontalDouble),
                          child: new Text('Quando você volta?',
                              style: AppTextStyle.textWhiteSmallBold),
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 15.0,
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _selectDate(context);
                      /*Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new CalendarPage(datePicked: _datePicked)));*/
                    },
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('Data',
                                  style: AppTextStyle.textBlueLightSmallBold),
                              new Text(
                                  Util.dateTimeFormatter.format(_datePicked),
                                  style: AppTextStyle.textWhiteSmall),
                            ],
                          ),
                        ),
                        new Icon(Icons.arrow_forward_ios,
                            size: 16.0, color: AppColors.colorWhite)
                      ],
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new FlatButton(
                    padding: EdgeInsets.all(0),
                    onPressed: () {
                      _selectTime(context);
                    },
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text('Horário',
                                  style: AppTextStyle.textBlueLightSmallBold),
                              new Text(
                                  Util.timeFormatter.format(_dateTimePicked),
                                  style: AppTextStyle.textWhiteSmall),
                            ],
                          ),
                        ),
                        new Icon(Icons.arrow_forward_ios,
                            size: 16.0, color: AppColors.colorWhite)
                      ],
                    ),
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    height: 1.0,
                  ),
                  new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Número de Reservas',
                                style: AppTextStyle.textBlueLightSmallBold),
                            new Text(bloc.people.toString() + ' Pessoas',
                                style: AppTextStyle.textWhiteSmall),
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
                            icon: Icon(Icons.remove,
                                size: 16.0, color: AppColors.colorWhite),
                          ),
                          Container(
                              padding: EdgeInsets.all(4.0),
                              height: 27.0,
                              width: 27.0,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.colorWhite,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  borderRadius: AppSizes.buttonCorner * 0.30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(bloc.people.toString(),
                                        style: AppTextStyle
                                            .textWhiteExtraSmallBold),
                                  ),
                                ],
                              )),
                          IconButton(
                            iconSize: 16,
                            onPressed: () {
                              changePeopleQuantity(true);
                            },
                            icon: Icon(Icons.add,
                                size: 16.0, color: AppColors.colorWhite),
                          ),
                        ],
                      ),
                    ],
                  ),
                  new Container(
                    decoration: BoxDecoration(color: AppColors.colorWhite),
                    margin: EdgeInsets.only(top: 8, bottom: 20.0),
                    height: 1.0,
                  ),
                ],
              ),
            ),
            new Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.inputPaddingHorizontalDouble),
              alignment: Alignment.bottomCenter,
              child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: goToPricesPage,
                  child: new Container(
                      height: AppSizes.buttonHeight,
                      decoration: BoxDecoration(
                          color: AppColors.colorPurpleDark,
                          borderRadius: AppSizes.buttonCorner),
                      child: new Center(
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text('Continuar',
                                style: AppTextStyle.textWhiteSmallBold)
                          ],
                        ),
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
