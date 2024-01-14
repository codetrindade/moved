import 'package:flutter/material.dart';
import 'package:movemedriver/model/address.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/ride/ride_register/ride_register.dart';

class RideListItem extends StatelessWidget {
  final Address model;

  RideListItem ({this.model});

  Future<void> onEditAddressFinished(BuildContext context) async {
    var a = await Navigator.push(context,
        new MaterialPageRoute(builder: (context) =>
        new RideRegister()));
    if (a != null) {
      //model = a;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Text(model.address, style: AppTextStyle.textWhiteExtraSmall, maxLines: 2, overflow: TextOverflow.ellipsis,);
  }
}

abstract class AddressPageListener {
  void onSelectAddress(Address address);
}
