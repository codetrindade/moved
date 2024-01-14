import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/core/bloc/vehicle/vehicle_bloc.dart';
import 'package:movemedriver/core/model/vehicle.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class VehicleCreateInformationPage extends StatefulWidget {
  @override
  _VehicleCreateInformationPageState createState() => _VehicleCreateInformationPageState();
}

class _VehicleCreateInformationPageState extends State<VehicleCreateInformationPage> {
  VehicleBloc bloc;

  var _licensePlate = TextEditingController();
  var _model = TextEditingController();
  var _color = TextEditingController();
  var _year = MaskedTextController(mask: '0000');

  var _licensePlateFocus = FocusNode();
  var _modelFocus = FocusNode();
  var _colorFocus = FocusNode();
  var _yearFocus = FocusNode();

  Future<void> onSendRegister() async {
    if (_licensePlate.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Preencha corretamente a placa');
      FocusScope.of(context).requestFocus(_licensePlateFocus);
      return;
    }
    if (_model.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Preencha corretamente o modelo');
      FocusScope.of(context).requestFocus(_modelFocus);
      return;
    }
    if (_year.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Preencha corretamente o ano');
      FocusScope.of(context).requestFocus(_yearFocus);
      return;
    }
    if (_color.text.isEmpty) {
      bloc.dialogService.showDialog('Atenção', 'Preencha corretamente a cor predominante');
      FocusScope.of(context).requestFocus(_colorFocus);
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    if (bloc.vehicle == null) {
      bloc.vehicle = Vehicle(
          color: _color.text,
          licensePlate: _licensePlate.text,
          model: _model.text,
          year: int.parse(_year.text),
          type: 'car');
      await bloc.register();
    } else {
      await bloc.update(Vehicle(
          id: bloc.vehicle.id,
          color: _color.text,
          licensePlate: _licensePlate.text,
          model: _model.text,
          year: int.parse(_year.text),
          type: 'car'));
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (bloc.vehicle != null) {
        _year.text = bloc.vehicle.year.toString();
        _licensePlate.text = bloc.vehicle.licensePlate;
        _model.text = bloc.vehicle.model;
        _color.text = bloc.vehicle.color;
      }
    });
  }

  @override
  void dispose() {
    _licensePlate.dispose();
    _model.dispose();
    _color.dispose();
    _year.dispose();
    _licensePlateFocus.dispose();
    _modelFocus.dispose();
    _colorFocus.dispose();
    _yearFocus.dispose();
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
                    title: 'Informações do veículo', callback: () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: SingleChildScrollView(
                    child: Column(children: [
                  TextFieldCustom(
                      controller: _licensePlate,
                      focus: _licensePlateFocus,
                      label: 'Placa',
                      capitalization: TextCapitalization.characters,
                      nextFocus: _modelFocus,
                      maxLength: 8),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      controller: _model,
                      focus: _modelFocus,
                      capitalization: TextCapitalization.sentences,
                      label: 'Marca / Modelo',
                      nextFocus: _colorFocus,
                      maxLength: 30),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      controller: _color,
                      focus: _colorFocus,
                      label: 'Cor predominante',
                      nextFocus: _yearFocus,
                      maxLength: 20),
                  SizedBox(height: 10.0),
                  TextFieldCustom(
                      controller: _year,
                      focus: _yearFocus,
                      label: 'Ano',
                      action: TextInputAction.done,
                      keyBoardType: TextInputType.number,
                      maxLength: 4),
                  SizedBox(height: 20.0),
                  Container(
                      height: 70,
                      child: Center(
                          child: BlueDarkButton(
                              text: 'Salvar', callback: () async => await this.onSendRegister()))),
                  SizedBox(height: 10.0),
                ]))));
  }
}
