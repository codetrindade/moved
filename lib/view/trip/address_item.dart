import 'package:flutter/material.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/view/ride/map_address/map_address.dart';

class AddressItem extends StatelessWidget {
  final Address model;
  final AddressPageListener listener;
  final bool isFromSelectAddressList;

  AddressItem(
      {@required this.model,
      this.isFromSelectAddressList = false,
      @required this.listener});

  Future<void> onEditAddressFinished(BuildContext context) async {
    var a = await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => new MapAddress(
                selectedAddress: Address(
                    address: model.address,
                    long: model.long,
                    lat: model.lat,
                    id: model.id))));
    if (a != null) {
      listener.onChangeAddress(a);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.08,
      margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
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
        onPressed: () {
          if (isFromSelectAddressList)
            listener.onSelectAddress(model);
          else
            onEditAddressFinished(context);
        },
        child: new Row(
          children: <Widget>[
            isFromSelectAddressList
                ? new Icon(MoveMeIcons.check,
                    color: AppColors.colorGreenLight, size: 20.0)
                : new Container(
              height: 25.0,
                    width: 25.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.colorGreenLight),
                    child: Center(
                      child: new Text(model.order.toString(),
                          style: AppTextStyle.textWhiteSmallBold),
                    )),
            new SizedBox(width: 10.0),
            new Expanded(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  model.address,
                  style: AppTextStyle.textGreyDarkSmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )
              ],
            )),
            new SizedBox(width: 10.0),
            isFromSelectAddressList
                ? new Icon(Icons.arrow_forward_ios,
                    size: 16.0, color: AppColors.colorGreenLight)
                : new IconButton(
                    icon: new Icon(Icons.clear,
                        size: 16.0, color: AppColors.colorGreenLight),
                    onPressed: () => listener.onRemoveAddress(model))
          ],
        ),
      ),
    );
  }
}

abstract class AddressPageListener {
  void onSelectAddress(Address address);

  void onChangeAddress(Address address);

  void onRemoveAddress(Address address);
}
