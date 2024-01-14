import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/vehicle/vehicle_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/vehicle/vehicle_create_information_page.dart';
import 'package:movemedriver/widgets/confirm_sheet.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class VehicleCreatePage extends StatefulWidget {
  @override
  _VehicleCreatePageState createState() => _VehicleCreatePageState();
}

class _VehicleCreatePageState extends State<VehicleCreatePage> {
  VehicleBloc bloc;

  void showConfirmSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () async => Navigator.pop(context),
              onConfirm: () async {
                Navigator.pop(context);
                await bloc.sendForReview();
              },
              text: 'Atenção, As informações serão enviadas a nossa equipe para análise,'
                  ' deseja continuar?');
        });
  }

  void showImageSourceSheet(String type) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          var model = bloc.getDocument(type);
          return Container(
              height: MediaQuery.of(context).size.height * (model == null ? 0.3 : 0.8),
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: Column(
                          children: [
                            if (model != null && model.obs != null)
                              Row(children: [
                                InkWell(
                                    child: Icon(Icons.info_rounded, color: Colors.red),
                                    onTap: () => Util.showMessage(context, 'Atenção',
                                        model.obs + '\n\n(Arraste para baixo para ocultar)',
                                        duration: 60))
                              ]),
                            if (model != null)
                              Container(
                                  height: MediaQuery.of(context).size.height * 0.5,
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  child: FadeInImage.assetNetwork(
                                      image: model.file, placeholder: 'assets/gifs/loading.gif')),
                            Text(
                                model == null
                                    ? 'De onde deseja adicionar uma foto?'
                                    : 'Para alterar, selecione um local:',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.textBlueLightSmallBold),
                          ],
                        ))),
                Row(children: <Widget>[
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            await bloc.chooseImage(ImageSource.camera, type);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Theme.of(context).colorScheme.primaryContainer, width: 0.5))),
                              height: 70,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.camera_alt, color: AppColors.colorBlueLight)),
                                Text('Câmera', style: AppTextStyle.textBlueLightSmallBold)
                              ])))),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            await bloc.chooseImage(ImageSource.gallery, type);
                          },
                          child: Container(
                              height: 70,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              color: Theme.of(context).colorScheme.primaryContainer,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.photo_library, color: Colors.white)),
                                Text('Galeria', style: AppTextStyle.textWhiteSmallBold)
                              ]))))
                ])
              ]));
        });
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
                child: AppBarCustom(title: 'Dados do veículo', callback: () => Navigator.pop(context)),
                preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
            body: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.colorBlueLight),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Informações do veículo', style: AppTextStyle.textBlueLightMediumBold),
                    SizedBox(height: 5),
                    Text('Placa: ' + bloc.vehicle.licensePlate, style: AppTextStyle.textBlueLightSmall),
                    Text('Marca: ' + bloc.vehicle.model, style: AppTextStyle.textBlueLightSmall, maxLines: 1),
                    SizedBox(height: 5),
                    Row(children: [
                      Text('Cor: ' + bloc.vehicle.color, style: AppTextStyle.textBlueLightSmall),
                      Spacer(),
                      Text('Ano: ' + bloc.vehicle.year.toString(), style: AppTextStyle.textBlueLightSmall)
                    ]),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        if (bloc.vehicle.obs != null)
                          InkWell(
                              child: Icon(Icons.info_rounded, color: Colors.red),
                              onTap: () => Util.showMessage(context, 'Atenção',
                                  bloc.vehicle.obs + '\n\n(Arraste para baixo para ocultar)',
                                  duration: 60)),
                        Spacer(),
                        InkWell(
                            onTap: () => Navigator.push(context,
                                MaterialPageRoute(builder: (context) => VehicleCreateInformationPage())),
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: AppColors.colorGreenLight,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Text('Editar', style: AppTextStyle.textWhiteSmallBold))),
                      ],
                    )
                  ])),
              Divider(),
              Column(children: [
                TransparentButton(
                    text: 'Foto do documento do veículo',
                    callback: () => showImageSourceSheet('photo_document'),
                    iconLeft: Icon(Icons.web_outlined, color: AppColors.colorBlueLight),
                    ok: bloc.getDocument('photo_document') != null &&
                        bloc.getDocument('photo_document').status == 'approved',
                    warning: bloc.getDocument('photo_document') == null ||
                        bloc.getDocument('photo_document').status == 'disapproved',
                    pending: bloc.getDocument('photo_document') != null &&
                        bloc.getDocument('photo_document').status == 'pending',
                    arrow: false),
                TransparentButton(
                    text: 'Foto da frente do veículo com a placa  ',
                    callback: () => showImageSourceSheet('photo_front'),
                    iconLeft: Icon(Icons.photo_camera, color: AppColors.colorBlueLight),
                    ok: bloc.getDocument('photo_front') != null &&
                        bloc.getDocument('photo_front').status == 'approved',
                    warning: bloc.getDocument('photo_front') == null ||
                        bloc.getDocument('photo_front').status == 'disapproved',
                    pending: bloc.getDocument('photo_front') != null &&
                        bloc.getDocument('photo_front').status == 'pending',
                    arrow: false),
                TransparentButton(
                    text: 'Foto do painel do veículo',
                    callback: () => showImageSourceSheet('photo_panel'),
                    iconLeft: Icon(Icons.photo_camera, color: AppColors.colorBlueLight),
                    ok: bloc.getDocument('photo_panel') != null &&
                        bloc.getDocument('photo_panel').status == 'approved',
                    warning: bloc.getDocument('photo_panel') == null ||
                        bloc.getDocument('photo_panel').status == 'disapproved',
                    pending: bloc.getDocument('photo_panel') != null &&
                        bloc.getDocument('photo_panel').status == 'pending',
                    arrow: false),
                TransparentButton(
                    text: 'Foto da lateral do veículo',
                    callback: () => showImageSourceSheet('photo_side'),
                    iconLeft: Icon(Icons.photo_camera, color: AppColors.colorBlueLight),
                    ok: bloc.getDocument('photo_side') != null &&
                        bloc.getDocument('photo_side').status == 'approved',
                    warning: bloc.getDocument('photo_side') == null ||
                        bloc.getDocument('photo_side').status == 'disapproved',
                    pending: bloc.getDocument('photo_side') != null &&
                        bloc.getDocument('photo_side').status == 'pending',
                    arrow: false),
                TransparentButton(
                    text: 'Foto do porta-malas do veículo aberto',
                    callback: () => showImageSourceSheet('photo_bag_open'),
                    iconLeft: Icon(Icons.photo_camera, color: AppColors.colorBlueLight),
                    ok: bloc.getDocument('photo_bag_open') != null &&
                        bloc.getDocument('photo_bag_open').status == 'approved',
                    warning: bloc.getDocument('photo_bag_open') == null ||
                        bloc.getDocument('photo_bag_open').status == 'disapproved',
                    pending: bloc.getDocument('photo_bag_open') != null &&
                        bloc.getDocument('photo_bag_open').status == 'pending',
                    arrow: false),
                if (bloc.vehicle != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: BlueDarkButton(
                          text: 'Enviar para análise', callback: () => this.showConfirmSheet()))
              ])
            ])));
  }
}
