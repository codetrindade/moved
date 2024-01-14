import 'package:flutter/material.dart';
import 'package:movemedriver/theme.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final ImageProvider imageProvider;

  ImageView({this.imageProvider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PhotoView(imageProvider: this.imageProvider, enableRotation: false),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
              padding: EdgeInsets.only(left: 15, right: 5, top: 10, bottom: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.colorGreenLight,
              ),
              child: Icon(Icons.arrow_back_ios, color: Colors.white)),
        ));
  }
}
