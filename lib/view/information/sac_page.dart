import 'package:flutter/material.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/blue_dark_button.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/core/bloc/sac/sac_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:provider/provider.dart';

class SacPage extends StatefulWidget {
  @override
  _SacPageState createState() => _SacPageState();
}

class _SacPageState extends BaseState<SacPage> {
  SacBloc bloc;

  var _subject = TextEditingController();
  var _detail = TextEditingController();
  var _phone = TextEditingController();
  var _description = TextEditingController();

  var _subjectFocus = FocusNode();
  var _detailFocus = FocusNode();
  var _phoneFocus = FocusNode();
  var _descriptionFocus = FocusNode();

  Future<void> submit() async {
    if (_subject.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O motivo do contato é obrigatório');
      FocusScope.of(context).requestFocus(_subjectFocus);
      return;
    }
    if (_detail.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O detalhe do contato é obrigatório');
      FocusScope.of(context).requestFocus(_detailFocus);
      return;
    }
    if (_phone.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'O telefone do contato é obrigatório');
      FocusScope.of(context).requestFocus(_phoneFocus);
      return;
    }
    if (_description.text.isEmpty) {
      Util.showMessage(context, 'Atenção', 'A descrição do contato é obrigatória');
      FocusScope.of(context).requestFocus(_descriptionFocus);
      return;
    }

    await bloc.contact(_subject.text, _detail.text, _phone.text, _description.text);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _phone.text = AppState.user.phone;
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<SacBloc>(context);

    return Scaffold(
      appBar: PreferredSize(
          child: AppBarCustom(
            title: 'Fale conosco',
            callback: () {
              Navigator.pop(context);
            },
          ),
          preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05, left: 20.0, right: 20.0),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            TextFieldCustom(
              label: 'Motivo do Contato',
              controller: _subject,
              focus: _subjectFocus,
              nextFocus: _detailFocus,
              maxLength: 20,
            ),
            SizedBox(height: 20.0),
            TextFieldCustom(
              label: 'Detalhes do Motivo',
              controller: _detail,
              focus: _detailFocus,
              nextFocus: _phoneFocus,
              maxLength: 20,
            ),
            SizedBox(height: 20.0),
            TextFieldCustom(
              label: 'Telefone',
              controller: _phone,
              focus: _phoneFocus,
              nextFocus: _descriptionFocus,
              keyBoardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            TextField(
              style: AppTextStyle.textBlueLightExtraSmall,
              keyboardType: TextInputType.multiline,
              controller: _description,
              focusNode: _descriptionFocus,
              onSubmitted: (String a) => submit,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                contentPadding: AppSizes.inputPadding,
                labelText: 'O que aconteceu?',
                labelStyle: AppTextStyle.textBlueLightExtraSmall,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorBlueLight, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.colorBlueLight, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: bloc.isLoading
          ? LoadingCircle()
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: BlueDarkButton(text: 'Enviar', callback: () => submit()),
            ),
    );
  }
}
