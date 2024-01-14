import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/presenter/address_presenter.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/util/util.dart';
import 'package:movemedriver/view/ride/map_address/map_address.dart';
import 'package:movemedriver/view/trip/address_item.dart';
import 'package:uuid/uuid.dart';

import 'address_route_view.dart';

class AddressRoutePage extends StatefulWidget {
  final bool choosingOrigin;

  AddressRoutePage({this.choosingOrigin = false});

  @override
  _AddressRoutePageState createState() =>
      _AddressRoutePageState(choosingOrigin: this.choosingOrigin);
}

class _AddressRoutePageState extends BaseState<AddressRoutePage>
    implements AddressRouteView, AddressPageListener {
  bool _isLoading = false;
  bool _isSearchingAddress = false;
  bool choosingOrigin;
  String _searchAddress;
  AddressRoutePresenter _presenter;
  List<AddressItem> selectedRoutes = new List<AddressItem>();
  List<AddressItem> addressSearchResult = new List<AddressItem>();

  Timer _debounce;
  var _search = new TextEditingController();

  _AddressRoutePageState({this.choosingOrigin}) {
    _presenter = new AddressRoutePresenter(this);
  }

  @override
  void initState() {
    super.initState();
    _search.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _search.removeListener(_onSearchChanged);
    _search.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      if (_search.text.length > 5) {
        if (_searchAddress != _search.text) {
          setState(() {
            _isSearchingAddress = true;
          });
          _presenter.getAutoCompleteResults(new Address(address: _search.text));
          _searchAddress = _search.text;
        }
      } else {
        setState(() {
          addressSearchResult.clear();
          _isSearchingAddress = false;
        });
      }
    });
  }

  onConfirmRoutes() {
    var result = new List<Address>();
    selectedRoutes.forEach((adWidget) => result.add(adWidget.model));
    Navigator.pop(context, result);
  }

  Future<void> setMapAddress() async {
    if (selectedRoutes.length == 3) {
      Util.showMessage(
          context, 'Atenção', 'Você já selecionou o número máximo de destinos');
      return;
    }
    _isLoading = true;
    var a = await Navigator.push(
        context, new MaterialPageRoute(builder: (context) => new MapAddress()));

    if (a != null) {
      a.order = selectedRoutes.length + 1;
      selectedRoutes.add(new AddressItem(model: a, listener: this));
      if (choosingOrigin) {
        onConfirmRoutes();
        return;
      } else
        setState(() {});
    }
    _isLoading = false;
  }

  List<Widget> buildAddressItems() {
    var addressItems = new List<Widget>();

    if (selectedRoutes.length > 0) {
      selectedRoutes.forEach((item) => addressItems.add(item));

      addressItems.add(new Container(
        color: AppColors.colorGreenLight,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
        height: 1,
      ));
    }

    if (_isSearchingAddress) {
      addressSearchResult.clear();
      addressItems.add(new SizedBox(height: 20.0));
      addressItems.add(new Center(
        child: new CircularProgressIndicator(
            valueColor:
                new AlwaysStoppedAnimation<Color>(AppColors.colorGreenLight)),
      ));
    } else
      addressSearchResult.forEach((item) => addressItems.add(item));

    if (selectedRoutes.length <= 2)
      addressItems.add(new Container(
        height: MediaQuery.of(context).size.height * 0.08,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            color: AppColors.colorWhite,
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(
                color: AppColors.colorGreenLight,
                style: BorderStyle.solid,
                width: 1)),
        child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: setMapAddress,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.location_on,
                color: AppColors.colorGreenLight,
              ),
              new SizedBox(width: 20.0),
              new Expanded(
                  child: new Text('Defina o local no mapa',
                      style: AppTextStyle.textGreyDarkSmall)),
              new Icon(Icons.arrow_forward_ios,
                  size: 16.0, color: AppColors.colorGreenLight)
            ],
          ),
        ),
      ));

    if (selectedRoutes.length > 0)
      addressItems.add(new Container(
        height: MediaQuery.of(context).size.height * 0.08,
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
            color: AppColors.colorBlueLight,
            borderRadius: BorderRadius.circular(40.0),
            border: Border.all(
                color: AppColors.colorBlueLight,
                style: BorderStyle.solid,
                width: 1)),
        child: new FlatButton(
          padding: EdgeInsets.all(0),
          onPressed: onConfirmRoutes,
          child: new Text('Confirmar', style: AppTextStyle.textWhiteSmallBold),
        ),
      ));

    return addressItems;
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? new Container(
            color: AppColors.colorWhite,
            child: new Center(
                child: new CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(
                        AppColors.colorGreenLight))),
          )
        : new Scaffold(
            body: new Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.07,
                        bottom: 30.0,
                        left: MediaQuery.of(context).size.width * 0.2,
                        right: MediaQuery.of(context).size.width * 0.1),
                    decoration: BoxDecoration(
                        color: AppColors.colorGreenLight,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25.0),
                            bottomRight: Radius.circular(25.0))),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: new IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: AppColors.colorWhite, size: 16.0),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ),
                  new Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: MediaQuery.of(context).size.height * 0.11),
                    decoration: BoxDecoration(
                        color: AppColors.colorWhite,
                        borderRadius: BorderRadius.circular(40.0),
                        border: Border.all(
                            color: AppColors.colorGreenLight,
                            style: BorderStyle.solid,
                            width: 1)),
                    child: new Row(
                      children: <Widget>[
                        new SizedBox(width: 20.0),
                        new Expanded(
                          child: new TextField(
                            style: AppTextStyle.textGreyDarkSmall,
                            keyboardType: TextInputType.text,
                            textAlign: TextAlign.start,
                            controller: _search,
                            autofocus: selectedRoutes.length == 0,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Qual é o seu destino?',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new Expanded(
                  child: new ListView(
                padding: EdgeInsets.all(0),
                children: buildAddressItems(),
              ))
            ],
          ));
  }

  @override
  void onError(String message) {
    Util.showMessage(context, 'Erro', message);
  }

  @override
  void onGetAutoCompleteResultsSuccess(List<Address> result) {
    result.forEach((item) => addressSearchResult.add(new AddressItem(
        model: item, listener: this, isFromSelectAddressList: true)));
    setState(() {
      _isSearchingAddress = false;
    });
  }

  @override
  void onSelectAddress(Address address) {
    if (selectedRoutes.length == 3) {
      Util.showMessage(
          context, 'Atenção', 'Você já selecionou o número máximo de destinos');
      return;
    }
    address.id = new Uuid().v1();
    address.order = selectedRoutes.length + 1;
    FocusScope.of(context).requestFocus(new FocusNode());
    addressSearchResult.clear();
    _search.text = '';
    selectedRoutes.add(new AddressItem(model: address, listener: this));

    if (choosingOrigin) {
      onConfirmRoutes();
      return;
    } else
      setState(() {});
  }

  @override
  void onChangeAddress(Address address) {
    var index = selectedRoutes.indexWhere((a) => a.model.id == address.id);
    selectedRoutes.removeAt(index);
    selectedRoutes.insert(
        index, new AddressItem(model: address, listener: this));
  }

  @override
  void onRemoveAddress(Address address) {
    var index = selectedRoutes.indexWhere((a) => a.model.id == address.id);
    setState(() {
      selectedRoutes.removeAt(index);
      var newIndex = 1;

      for (var a in selectedRoutes) {
        a.model.order = newIndex;
        newIndex++;
      }
    });
  }
}
