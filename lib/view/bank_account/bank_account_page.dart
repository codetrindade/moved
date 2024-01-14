import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:movemedriver/component/app_bar.dart';
import 'package:movemedriver/component/text_field_custom.dart';
import 'package:movemedriver/core/bloc/bank_account/bank_account_bloc.dart';
import 'package:movemedriver/core/model/bank_account.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/widgets/confirm_sheet.dart';
import 'package:movemedriver/widgets/loading_circle.dart';
import 'package:movemedriver/widgets/multiselect_page.dart';
import 'package:provider/provider.dart';

class BankAccountPage extends StatefulWidget {
  @override
  _BankAccountPageState createState() => _BankAccountPageState();
}

class _BankAccountPageState extends State<BankAccountPage> {
  BankAccountBloc bloc;

  var _holderName = TextEditingController();
  var _holderDocument = MaskedTextController(mask: '000.000.000-00');
  var _holderDocumentFocus = FocusNode();
  var _accountNumber = TextEditingController();
  var _accountNumberFocus = FocusNode();
  var _agencyNumber = TextEditingController();
  var _agencyNumberFocus = FocusNode();
  String _bankNumber;
  String _bank;
  bool accountTypeChecking = true;
  DateTime _datePicked;
  String caixaCodeText = '';
  String caixaCode = '';
  String uf = '';

  var _zipCode = MaskedTextController(mask: '00000-000');
  var _zipCodeFocus = FocusNode();
  var _neighbohood = TextEditingController();
  var _neighbohoodFocus = FocusNode();
  var _complement = TextEditingController();
  var _complementFocus = FocusNode();
  var _enableNeighborhood = true;
  var _street = TextEditingController();
  var _streetFocus = FocusNode();
  var _enableStreet = true;
  var _streetNumber = TextEditingController();
  var _streetNumberFocus = FocusNode();
  var _city = TextEditingController();
  var _cityFocus = FocusNode();
  var _enableCity = true;
  var _enableState = true;

  getAddressByZipCode() async {
    FocusScope.of(context).requestFocus(FocusNode());
    var address = await bloc.getAddressByZipCode(_zipCode.text);
    if (address == null) {
      _enableState = true;
      _enableCity = true;
      _enableStreet = true;
      _enableNeighborhood = true;
      bloc.setLoading(false);
      return;
    }
    _street.text = address.street;
    _enableStreet = address.street.isEmpty;
    _neighbohood.text = address.neighborhood;
    _enableNeighborhood = address.neighborhood.isEmpty;
    _city.text = address.city;
    _enableCity = address.city.isEmpty;
    uf = address.state;
    _enableState = address.state.isEmpty;
    FocusScope.of(context).requestFocus(_streetNumberFocus);
    bloc.setLoading(false);
  }

  saveAccount() async {
    if (_datePicked == null) {
      bloc.dialogService.showDialog('Atenção', 'A data de nascimento é obrigatória');
      return;
    }

    if (bloc.isNullOrEmpty(_street.text)) {
      bloc.dialogService.showDialog('Atenção', 'O nome da rua é obrigatório');
      FocusScope.of(context).requestFocus(_streetFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_holderDocument.text)) {
      bloc.dialogService.showDialog('Atenção', 'O cpf é obrigatório');
      FocusScope.of(context).requestFocus(_holderDocumentFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_bankNumber)) {
      bloc.dialogService.showDialog('Atenção', 'Escolha um banco');
      return;
    }

    if (_bankNumber == '104' && bloc.isNullOrEmpty(caixaCode)) {
      bloc.dialogService.showDialog('Atenção', 'O código da caixa é obrigatório');
      return;
    }

    if (bloc.isNullOrEmpty(_city.text)) {
      bloc.dialogService.showDialog('Atenção', 'O nome da cidade é obrigatório');
      FocusScope.of(context).requestFocus(_cityFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_accountNumber.text)) {
      bloc.dialogService.showDialog('Atenção', 'O número da conta é obrigatório');
      FocusScope.of(context).requestFocus(_accountNumberFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_agencyNumber.text)) {
      bloc.dialogService.showDialog('Atenção', 'O número da agência é obrigatório');
      FocusScope.of(context).requestFocus(_agencyNumberFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_neighbohood.text)) {
      bloc.dialogService.showDialog('Atenção', 'O bairro é obrigatório');
      FocusScope.of(context).requestFocus(_neighbohoodFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_streetNumber.text)) {
      bloc.dialogService
          .showDialog('Atenção', 'O número do endreço é obrigatório (caso não exista, favor digitar N/A)');
      FocusScope.of(context).requestFocus(_streetNumberFocus);
      return;
    }

    if (bloc.isNullOrEmpty(_zipCode.text)) {
      bloc.dialogService.showDialog('Atenção', 'O CEP da rua é obrigatório');
      FocusScope.of(context).requestFocus(_zipCodeFocus);
      return;
    }

    var bankAccount = BankAccount(
        street: _street.text,
        state: uf,
        accountHolderDocument: _holderDocument.text.replaceAll('.', '').replaceAll('-', ''),
        accountHolderName: _holderName.text,
        bankNumber: _bankNumber,
        city: _city.text,
        complement: _complement.text,
        accountComplementNumber: '',
        accountCaixaNumber: caixaCode,
        accountNumber: _accountNumber.text,
        agencyNumber: _agencyNumber.text,
        neighborhood: _neighbohood.text,
        number: _streetNumber.text,
        accountType: accountTypeChecking ? 'CHECKING' : 'SAVINGS',
        birthDate: Util.convertDateTimeUSA(_datePicked),
        postCode: _zipCode.text.replaceAll('-', ''));

    this.showConfirmSheet(
        'Atenção, as informações serão enviadas para aprovação e seu cadastro ficará pendente até que todas'
        ' elas sejam validadas, deseja realmente continuar?',
        callback: () async => await bloc.saveAccount(bankAccount));
  }

  void showConfirmSheet(String message, {Function callback}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ConfirmSheet(
              onCancel: () => Navigator.pop(context),
              onConfirm: () {
                Navigator.pop(context);
                callback();
              },
              text: message);
        });
  }

  pickDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _datePicked ?? DateTime.now(),
        firstDate: DateTime.now().add(Duration(days: -40000)),
        lastDate: DateTime.now());

    setState(() {
      _datePicked = DateTime(picked.year, picked.month, picked.day, 0, 0);
    });
    }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await bloc.getBankList();
      if (bloc.model != null) {
        _agencyNumber.text = bloc.model.agencyNumber;
        _zipCode.text = bloc.model.postCode;
        _streetNumber.text = bloc.model.number;
        _neighbohood.text = bloc.model.neighborhood;
        _street.text = bloc.model.street;
        caixaCode = bloc.model.accountCaixaNumber;
        _complement.text = bloc.model.complement;
        uf = bloc.model.state;
        _city.text = bloc.model.city;
        _holderName.text = bloc.model.accountHolderName;
        _holderDocument.text = bloc.model.accountHolderDocument;
        accountTypeChecking = bloc.model.accountType == 'CHECKING';
        _accountNumber.text = bloc.model.accountNumber;
        _enableState = false;
        _enableCity = false;
        _enableStreet = false;
        _enableNeighborhood = false;
        _datePicked = DateTime.parse(bloc.model.birthDate);
        _bankNumber = bloc.model.bankNumber;
        _bank = _bankNumber + ' - ' + bloc.banks.firstWhere((element) => element.number == _bankNumber).name;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<BankAccountBloc>(context);

    return Scaffold(
        appBar: PreferredSize(
            child: AppBarCustom(title: 'Dados Bancários', callback: () => Navigator.pop(context)),
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.08)),
        body: bloc.isLoading
            ? LoadingCircle()
            : SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                //ADDRESS
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      SizedBox(height: 20),
                      Text('Dados do Titular', style: AppTextStyle.textBlueBold),
                      SizedBox(height: 20.0),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'Nome do titular da conta',
                          controller: _holderName,
                          maxLength: 50,
                          capitalization: TextCapitalization.words,
                          nextFocus: _holderDocumentFocus),
                      SizedBox(height: 10.0),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'CPF',
                          keyBoardType: TextInputType.number,
                          focus: _holderDocumentFocus,
                          controller: _holderDocument),
                      SizedBox(height: 10.0),
                      InkWell(
                          onTap: () async => await pickDate(),
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: AppColors.colorBlueLight, width: 1.0)),
                              child: Text(
                                  _datePicked == null
                                      ? 'Data de nascimento'
                                      : Util.convertDateFromDate(_datePicked),
                                  maxLines: 1,
                                  style: _datePicked == null
                                      ? AppTextStyle.textBlueLightExtraSmall
                                      : TextStyle(fontSize: AppSizes.fontMedium)))),
                      /*InkWell(
                          onTap: () async => await pickDate(),
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: AppColors.colorBlueLight, width: 1.0)),
                              child: Text(
                                  _datePicked == null
                                      ? 'Data de nascimento'
                                      : Util.convertDateFromDate(_datePicked),
                                  maxLines: 1,
                                  style: _datePicked == null
                                      ? AppTextStyle.textBlueLightExtraSmall
                                      : TextStyle(fontSize: AppSizes.fontMedium)))),*/
                      Divider(height: 50),
                      Text('Tipo de Conta', style: AppTextStyle.textBlueBold),
                      Row(children: [
                        Text('Corrente', style: AppTextStyle.textGreySmall),
                        Checkbox(
                            activeColor: AppColors.colorGreen,
                            value: accountTypeChecking,
                            onChanged: (a) {
                              setState(() {
                                accountTypeChecking = a;
                              });
                            }),
                        Text('Poupança', style: AppTextStyle.textGreySmall),
                        Checkbox(
                            activeColor: AppColors.colorGreen,
                            value: !accountTypeChecking,
                            onChanged: (a) {
                              setState(() {
                                accountTypeChecking = !a;
                              });
                            }),
                      ]),
                      SizedBox(height: 10),
                      InkWell(
                          onTap: () async {
                            var result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MultiSelectPage(
                                        title: 'Selecione o Banco',
                                        multi: false,
                                        items: bloc.banks
                                            .map((e) => SelectItem(
                                                id: e.number,
                                                text: e.number + ' - ' + e.name,
                                                selected: false))
                                            .toList())));

                            if (result != null) {
                              _bank = result[0].text;
                              _bankNumber = result[0].id;
                              setState(() {});
                            }
                          },
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: AppColors.colorBlueLight, width: 1.0)),
                              child: Text(_bank == null ? 'Selecione o banco' : _bank,
                                  maxLines: 1,
                                  style: _bank == null
                                      ? AppTextStyle.textBlueLightExtraSmall
                                      : TextStyle(fontSize: AppSizes.fontMedium)))),
                      if (_bankNumber == '104') SizedBox(height: 10),
                      if (_bankNumber == '104')
                        InkWell(
                            onTap: () async {
                              var a = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MultiSelectPage(title: 'Código da conta', multi: false, items: [
                                            SelectItem(
                                                id: '001',
                                                selected: false,
                                                text: '001 - Conta Corrente de Pessoa Física'),
                                            SelectItem(
                                                id: '002',
                                                selected: false,
                                                text: '002 - Conta Simples de Pessoa Física'),
                                            SelectItem(
                                                id: '003',
                                                selected: false,
                                                text: '003 - Conta Corrente de Pessoa Jurídica'),
                                            SelectItem(
                                                id: '006', selected: false, text: '006 - Entidades Públicas'),
                                            SelectItem(
                                                id: '007',
                                                selected: false,
                                                text: '007 - Depósitos Instituições Financeiras'),
                                            SelectItem(
                                                id: '013',
                                                selected: false,
                                                text: '013 - Poupança de Pessoa Física'),
                                            SelectItem(
                                                id: '022',
                                                selected: false,
                                                text: '022 - Poupança de Pessoa Jurídica'),
                                            SelectItem(
                                                id: '023', selected: false, text: '023 - Conta Caixa Fácil'),
                                            SelectItem(
                                                id: '028',
                                                selected: false,
                                                text: '028 - Poupança de Crédito Imobiliário'),
                                            SelectItem(
                                                id: '043', selected: false, text: '043 - Depósitos Lotéricos')
                                          ])));
                              if (a != null) {
                                caixaCode = a[0].id;
                                caixaCodeText = a[0].text;
                                bloc.refresh();
                              }
                            },
                            child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color: AppColors.colorBlueLight, width: 1.0)),
                                child: Text(
                                    caixaCode.isEmpty ? 'Código da conta' : caixaCode,
                                    maxLines: 1,
                                    style: caixaCode.isEmpty
                                        ? AppTextStyle.textBlueLightExtraSmall
                                        : TextStyle(fontSize: AppSizes.fontMedium)))),
                      SizedBox(height: 10),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'Nº da agência',
                          controller: _agencyNumber,
                          maxLength: 6,
                          keyBoardType: TextInputType.number,
                          focus: _agencyNumberFocus,
                          nextFocus: _accountNumberFocus),
                      SizedBox(height: 10.0),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'Nº da conta com dígito',
                          maxLength: 20,
                          controller: _accountNumber,
                          keyBoardType: TextInputType.number,
                          focus: _accountNumberFocus),
                      Divider(height: 50),
                      Text('Endereço do titular da Conta', style: AppTextStyle.textBlueBold),
                      Text('Informe um endereço', style: AppTextStyle.textGreySmall),
                      SizedBox(height: 20.0),
                      Row(children: <Widget>[
                        Flexible(
                            child: TextFieldCustom(
                                isDecorationDefault: false,
                                label: 'CEP',
                                controller: _zipCode,
                                keyBoardType: TextInputType.numberWithOptions(),
                                focus: _zipCodeFocus,
                                nextFocus: _streetFocus)),
                        SizedBox(width: 5.0),
                        FlatButton(
                            onPressed: () => getAddressByZipCode(),
                            padding: EdgeInsets.zero,
                            child: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: BoxDecoration(
                                    color: AppColors.colorGreen, borderRadius: BorderRadius.circular(30.0)),
                                child: Center(child: Icon(Icons.search, color: Colors.white))))
                      ]),
                      SizedBox(height: 10.0),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'Rua',
                          controller: _street,
                          maxLength: 150,
                          focus: _streetFocus,
                          enabled: _enableStreet,
                          nextFocus: _streetNumberFocus),
                      SizedBox(height: 10.0),
                      Row(children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: TextFieldCustom(
                                isDecorationDefault: false,
                                label: 'Nº',
                                controller: _streetNumber,
                                focus: _streetNumberFocus,
                                nextFocus: _complementFocus)),
                        SizedBox(width: 10.0),
                        Flexible(
                            child: TextFieldCustom(
                                isDecorationDefault: false,
                                label: 'Complemento',
                                maxLength: 50,
                                controller: _complement,
                                keyBoardType: TextInputType.text,
                                focus: _complementFocus,
                                //enabled: _enableNeighbohood,
                                nextFocus: _neighbohoodFocus))
                      ]),
                      SizedBox(height: 10.0),
                      TextFieldCustom(
                          isDecorationDefault: false,
                          label: 'Bairro',
                          controller: _neighbohood,
                          maxLength: 50,
                          keyBoardType: TextInputType.text,
                          focus: _neighbohoodFocus,
                          enabled: _enableNeighborhood,
                          nextFocus: _cityFocus),
                      SizedBox(height: 10.0),
                      Row(children: <Widget>[
                        Flexible(
                            child: TextFieldCustom(
                                isDecorationDefault: false,
                                label: 'Cidade',
                                controller: _city,
                                keyBoardType: TextInputType.text,
                                focus: _cityFocus,
                                maxLength: 150,
                                enabled: _enableCity)),
                        SizedBox(width: 10.0),
                        Container(
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: InkWell(
                                onTap: () async {
                                  var a = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MultiSelectPage(title: 'Código da conta', multi: false, items: [
                                                SelectItem(id: 'SP', selected: false, text: 'SP - São Paulo'),
                                                SelectItem(
                                                    id: 'RJ', selected: false, text: 'RJ - Rio de Janeiro'),
                                                SelectItem(id: 'RO', selected: false, text: 'RO - Rondônia'),
                                                SelectItem(id: 'AC', selected: false, text: 'AC - Acre'),
                                                SelectItem(id: 'AM', selected: false, text: 'AM - Amazonas'),
                                                SelectItem(id: 'RR', selected: false, text: 'RR - Roraima'),
                                                SelectItem(id: 'PA', selected: false, text: 'PA - Pará'),
                                                SelectItem(id: 'AP', selected: false, text: 'AP - Amapá'),
                                                SelectItem(id: 'TO', selected: false, text: 'TO - Tocantins'),
                                                SelectItem(id: 'MA', selected: false, text: 'MA - Maranhão'),
                                                SelectItem(id: 'PI', selected: false, text: 'PI - Piauí'),
                                                SelectItem(id: 'CE', selected: false, text: 'CE - Ceará'),
                                                SelectItem(
                                                    id: 'RN',
                                                    selected: false,
                                                    text: 'RN - Rio Grande do Norte'),
                                                SelectItem(id: 'PB', selected: false, text: 'PB - Paraíba'),
                                                SelectItem(
                                                    id: 'PE', selected: false, text: 'PE - Pernambuco'),
                                                SelectItem(id: 'AL', selected: false, text: 'AL - Alagoas'),
                                                SelectItem(id: 'SE', selected: false, text: 'SE - Sergipe'),
                                                SelectItem(id: 'BH', selected: false, text: 'BH - Bahia'),
                                                SelectItem(
                                                    id: 'MG', selected: false, text: 'MG - Minas Gerais'),
                                                SelectItem(
                                                    id: 'ES', selected: false, text: 'ES - Espírito Santo'),
                                                SelectItem(id: 'PR', selected: false, text: 'PR - Paraná'),
                                                SelectItem(
                                                    id: 'SC', selected: false, text: 'SC - Santa Catarina'),
                                                SelectItem(
                                                    id: 'RS',
                                                    selected: false,
                                                    text: 'RS - Rio Grande do Sul'),
                                                SelectItem(
                                                    id: 'MS',
                                                    selected: false,
                                                    text: 'MS - Mato Grosso do Sul'),
                                                SelectItem(
                                                    id: 'MT', selected: false, text: 'MT - Mato Grosso'),
                                                SelectItem(id: 'GO', selected: false, text: 'GO - Goiás'),
                                                SelectItem(
                                                    id: 'DF', selected: false, text: 'DF - Distrito Federal'),
                                              ])));
                                  if (a != null) {
                                    uf = a[0].id;
                                    bloc.refresh();
                                  }
                                },
                                child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                        border: Border.all(color: AppColors.colorBlueLight, width: 1.0)),
                                    child: Center(
                                        child: Text(uf.isEmpty ? 'UF' : uf,
                                            maxLines: 1,
                                            style: uf.isEmpty
                                                ? AppTextStyle.textBlueLightExtraSmall
                                                : TextStyle(fontSize: AppSizes.fontMedium))))))
                      ]),
                      SizedBox(height: 30),
                      FlatButton(
                          onPressed: () => saveAccount(),
                          padding: EdgeInsets.zero,
                          child: Container(
                              height: 60.0,
                              decoration: BoxDecoration(
                                  color: AppColors.colorGreen, borderRadius: BorderRadius.circular(30.0)),
                              child:
                                  Center(child: Text('Confirmar', style: TextStyle(color: Colors.white))))),
                      SizedBox(height: 30)
                    ]))
              ])));
  }
}
