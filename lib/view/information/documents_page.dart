import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/transparent_button.dart';
import 'package:movemedriver/core/bloc/document/document_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:provider/provider.dart';

class DocumentsPage extends StatefulWidget {
  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  DocumentBloc bloc;

  void showImageSourceSheet(String type, {String obs}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
              height: MediaQuery.of(context).size.height * (obs == null ? 0.3 : 0.5),
              width: double.infinity,
              padding: EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
              child: Column(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        child: obs == null
                            ? Text('De onde deseja adicionar uma foto?',
                            textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold)
                            : SingleChildScrollView(
                          child: Column(
                            children: [
                              Text('Atenção',
                                  textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold),
                              SizedBox(height: 15),
                              Text(obs, textAlign: TextAlign.center, style: AppTextStyle.textGreySmall),
                              SizedBox(height: 30),
                              Text('De onde deseja adicionar uma foto?',
                                  textAlign: TextAlign.center, style: AppTextStyle.textBlueLightSmallBold)
                            ],
                          ),
                        ))),
                Row(children: <Widget>[
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.camera, type);
                            Navigator.pop(context);
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top:
                                      BorderSide(color: Theme.of(context).colorScheme.primaryContainer, width: 0.5))),
                              height: 70,
                              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                Expanded(child: Icon(Icons.camera_alt, color: AppColors.colorBlueLight)),
                                Text('Câmera', style: AppTextStyle.textBlueLightSmallBold)
                              ])))),
                  Expanded(
                      child: InkWell(
                          onTap: () async {
                            await bloc.chooseImage(ImageSource.gallery, type);
                            Navigator.pop(context);
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
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.listDocuments());
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<DocumentBloc>(context);

    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(title: 'Documentos', callback: () => Navigator.pop(context)),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 10),
            TransparentButton(
                text: 'Comprovante de endereço',
                callback: () {
                  if (bloc.verifyOkPhoto('address')) return;
                  if (bloc.verifyWarningPhoto('address'))
                    showImageSourceSheet('address',
                        obs: bloc.documents.firstWhere((element) => element.type == 'address').obs);
                  else
                    showImageSourceSheet('address');
                },
                iconLeft: Icon(Icons.home, color: AppColors.colorBlueLight),
                ok: bloc.verifyOkPhoto('address'),
                warning: bloc.verifyWarningPhoto('license'),
                arrow: false),
            TransparentButton(
                text: 'Carteira de motorista',
                callback: () {
                  if (bloc.verifyOkPhoto('license')) return;
                  if (bloc.verifyWarningPhoto('license'))
                    showImageSourceSheet('license',
                        obs: bloc.documents.firstWhere((element) => element.type == 'license').obs);
                  else
                    showImageSourceSheet('license');
                },
                iconLeft: Icon(Icons.drive_eta_rounded, color: AppColors.colorBlueLight),
                ok: bloc.verifyOkPhoto('license'),
                warning: bloc.verifyWarningPhoto('license'),
                arrow: false),
            TransparentButton(
                text: 'Antecedentes criminais',
                callback: () {
                  if (bloc.verifyOkPhoto('criminal')) return;
                  if (bloc.verifyWarningPhoto('criminal'))
                    showImageSourceSheet('criminal',
                        obs: bloc.documents.firstWhere((element) => element.type == 'criminal').obs);
                  else
                    showImageSourceSheet('criminal');
                },
                iconLeft: Icon(Icons.local_police, color: AppColors.colorBlueLight),
                ok: bloc.verifyOkPhoto('criminal'),
                warning: bloc.verifyWarningPhoto('criminal'),
                arrow: false),
            TransparentButton(
                text: 'Selfie segurando o documento',
                callback: () {
                  if (bloc.verifyOkPhoto('selfie')) return;
                  if (bloc.verifyWarningPhoto('selfie'))
                    showImageSourceSheet('selfie',
                        obs: bloc.documents.firstWhere((element) => element.type == 'selfie').obs);
                  else
                    showImageSourceSheet('selfie');
                },
                iconLeft: Icon(Icons.person, color: AppColors.colorBlueLight),
                ok: bloc.verifyOkPhoto('selfie'),
                warning: bloc.verifyWarningPhoto('selfie'),
                arrow: false),
          ])),
    );
  }
}
