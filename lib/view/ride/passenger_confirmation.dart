import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/core/bloc/ride/ride_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/ride/set_price/set_price.dart';
import 'package:provider/provider.dart';

class PassengerConfirmation extends StatefulWidget {
  @override
  _PassengerConfirmationState createState() => _PassengerConfirmationState();
}

class _PassengerConfirmationState extends BaseState<PassengerConfirmation> {
  RideBloc bloc;

  _PassengerConfirmationState();

  Future<void> changeConfirm(bool c) async {
    if (bloc.modelBack == null) {
      bloc.model.autoConfirm = c;

      var a = await Navigator.push(context, new MaterialPageRoute(builder: (context) => new SetPrice()));
      if (a != null) Navigator.pop(context, true);
    } else {
      bloc.modelBack.autoConfirm = c;
      var a = await Navigator.push(context, new MaterialPageRoute(builder: (context) => new SetPrice()));
      if (a != null) Navigator.pop(context, true);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<RideBloc>(context);

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: AppColors.colorGreenLight,
        elevation: 0.0,
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.colorWhite, size: 16.0),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: new Text('Oferecer Carona', style: AppTextStyle.textWhiteSmallBold),
      ),
      body: Container(
        decoration: new BoxDecoration(gradient: appGradient),
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: <Widget>[
            new Expanded(
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: 60.0,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Expanded(
                        child: Container(
                          child: new Text('Passageiros podem confirmar automáticamente suas reservas?',
                              style: AppTextStyle.textWhiteSmallBold),
                        ),
                      )
                    ],
                  ),
                  new SizedBox(
                    height: 80.0,
                  ),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: new BoxDecoration(
                      border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        changeConfirm(true);
                      },
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Sim, claro!', style: AppTextStyle.textWhiteSmallBold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new SizedBox(height: 5.0),
                  new Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    decoration: new BoxDecoration(
                      border: Border.all(color: AppColors.colorWhite, style: BorderStyle.solid, width: 1),
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: new FlatButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        changeConfirm(false);
                      },
                      child: new Row(
                        children: <Widget>[
                          new Expanded(
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text('Não, quero responder a cada um individualmente',
                                    style: AppTextStyle.textWhiteSmallBold),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*new Container(
              margin: EdgeInsets.symmetric(
                  vertical: AppSizes.inputPaddingHorizontalDouble),
              alignment: Alignment.bottomCenter,
              child: new FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {
                    onSubmit();
                  },
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
            ),*/
          ],
        ),
      ),
    );
  }
}
