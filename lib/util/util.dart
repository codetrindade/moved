import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movemedriver/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import 'dart:ui' as ui;
import 'package:vector_math/vector_math_64.dart' as math64;

class Util {
  //static methods

  static var timeFormatter = new DateFormat.Hm();
  static var dateTimeFormatter = new DateFormat.yMMMMEEEEd();
  static var dateTimeFormatter2 = new DateFormat('dd/MM/yyyy HH:mm');
  static var formatter = new DateFormat('dd/MM/yyyy');
  static var formatterUs = new DateFormat('yyyy-MM-dd');
  static var timeHourFormatter = new DateFormat('HH:mm');

  static showDialogContent(BuildContext context, Widget body) {
    var _dialog = Dialog(
      elevation: 0.0,
      child: Container(height: MediaQuery.of(context).size.height, child: body),
      backgroundColor: AppColors.colorWhite,
    );
    showDialog(context: context, builder: (_) => _dialog);
  }

  static showMessage(BuildContext context, String title, String message, {int duration = 3}) {
    Flushbar(
        margin: EdgeInsets.all(10),
        borderRadius: 10,
        duration: Duration(seconds: duration),
        title: title,
        message: message)
      ..show(context);
  }

  static showConfirm(BuildContext context, String title, String message, String confirmText,
      String refuseText, bool defaultHeight,
      [Function callbackConfirm, Function callbackRefuse]) {
    var _dialog = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: AppColors.colorGreenLight, style: BorderStyle.solid, width: 1)),
      title: Text(
        title,
        style: AppTextStyle.textBlueLightMediumBold,
        textAlign: TextAlign.left,
      ),
      content: Container(
        height: MediaQuery.of(context).size.height * (defaultHeight ? 0.15 : 0.25),
        child: Column(
          children: <Widget>[
            Expanded(child: Text(message, style: AppTextStyle.textGreyDarkSmall)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                    color: AppColors.colorGreenLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pop(context, false);
                      callbackRefuse();
                    },
                    child: Text(refuseText, style: AppTextStyle.textWhiteExtraSmallBold)),
                FlatButton(
                    color: AppColors.colorBlueLight,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    onPressed: () {
                      Navigator.pop(context);
                      callbackConfirm();
                    },
                    child: Text(confirmText, style: AppTextStyle.textWhiteExtraSmallBold))
              ],
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (_) => _dialog);
  }

  static showRecalculating(BuildContext context, [String message = 'Recalculando...']) {
    var _dialog = AlertDialog(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      content: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.5,
        decoration:
            BoxDecoration(color: AppColors.colorBlueDarkOpacity, borderRadius: BorderRadius.circular(30.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.colorGradientSecondary)),
            SizedBox(height: 10.0),
            Text('Recalculando...', style: AppTextStyle.textWhiteSmallBold, textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    showDialog(context: context, builder: (_) => _dialog, barrierDismissible: false);
  }

  static getMessageTime(DateTime date) {
    if (formatter.format(date) == formatter.format(DateTime.now())) return timeFormatter.format(date);

    if (formatter.format(date.add(new Duration(days: 1))) == formatter.format(DateTime.now())) return 'ontem';

    return dateTimeFormatter2.format(date);
  }

  static getTime(DateTime date) {
    if (formatter.format(date) == formatter.format(DateTime.now())) return timeFormatter.format(date);

    if (formatter.format(date.add(new Duration(days: 1))) == formatter.format(DateTime.now())) return 'ontem';

    return formatter.format(date);
  }

  static popNonRoot(BuildContext context) {
    Navigator.of(context).pop();
  }

  static setPreference(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static String convertDateTimeUSA(DateTime date) {
    final formatter = new DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(date);
  }

  static removePreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<String> getPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = new List<LatLng>();
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;
    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dLat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dLng;
      LatLng p = new LatLng(lat / 1E5, lng / 1E5);
      points.add(p);
    }
    return points;
  }

  static String convertDateFromString(String date) {
    final formatter = new DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(DateTime.parse(date));
  }

  static String convertDateFromDate(DateTime date) {
    final formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static String convertDate(String date) {
    final formatter = new DateFormat('dd/MM/yyyy');
    return formatter.format(DateTime.parse(date));
  }

  static LatLng computeCentroid(List<LatLng> points) {
    var list = new List<LatLng>.from(points);
    list.sort((a, b) => a.latitude.compareTo(b.latitude));
    var minLat = list.first.latitude;
    var maxLat = list.last.latitude;
    list.sort((a, b) => a.longitude.compareTo(b.longitude));
    var minLng = list.first.longitude;
    var maxLng = list.last.longitude;

    var distLat = maxLat - minLat;
    distLat = distLat < 0 ? distLat = -1 * distLat : distLat;
    minLat += (distLat / 2);

    var distLng = maxLng - minLng;
    distLng = distLng < 0 ? distLng = -1 * distLng : distLng;
    minLng += (distLng / 2);

    return new LatLng(minLat, minLng);
  }

  static double haversine(double lat1, lon1, lat2, lon2) {
    double R = 6372.8;
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a = pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c;
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  static double distanceToCenter(LatLng center, List<LatLng> points) {
    var maxD = 0.0;

    for (int i = 0; i < points.length; i++) {
      var d = Util.haversine(points[i].latitude, points[i].longitude, center.latitude, center.longitude);
      if (d > maxD) maxD = d;
    }

    return maxD * 1000;
  }

  static String formatMoney(Object value) {
    value = value is String ? double.parse(value) : value;
    return NumberFormat.currency(locale: 'pt_BR', name: '', symbol: 'R\$', decimalDigits: 2).format(value);
  }

  static String convertDateTimeFromString(String date) {
    final formatter = new DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(DateTime.parse(date));
  }

  static String formatMoneyNoSymbol(Object value) {
    value = value is String ? double.parse(value) : value;
    return NumberFormat.currency(locale: 'pt_BR', name: '', symbol: '', decimalDigits: 2).format(value);
  }

  static double calculateZoomByWidthAndDistance(double width, double d) {
    var zooms = [
      21282,
      16355,
      10064,
      5540,
      2909,
      1485,
      752,
      378,
      190,
      95,
      48,
      24,
      12,
      6,
      3,
      1.48,
      0.74,
      0.37,
      0.19
    ];
    var zoom = 19.0;
    for (int i = 18; i >= 0; i--) {
      var m = zooms[i] * width;
      if (m > (d * 2)) {
        break;
      } else
        zoom = double.parse(i.toString());
    }
    return zoom;
  }

  static double bearing(double lat1, double lon1, double lat2, double lon2) {
    double longitude1 = lon1;
    double longitude2 = lon2;
    double latitude1 = math64.radians(lat1);
    double latitude2 = math64.radians(lat2);
    double longDiff = math64.radians(longitude2 - longitude1);
    double y = sin(longDiff) * cos(latitude2);
    double x = cos(latitude1) * sin(latitude2) - sin(latitude1) * cos(latitude2) * cos(longDiff);

    return (math64.degrees(atan2(y, x)) + 360) % 360;
  }

  //no-static methods

  Future<Uint8List> getBytesFromCanvas(int width, int height, urlAsset) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final ByteData datai = await rootBundle.load(urlAsset);
    var imaged = await loadImage(new Uint8List.view(datai.buffer));
    canvas.drawImageRect(
      imaged,
      Rect.fromLTRB(0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
      Rect.fromLTRB(0.0, 0.0, width.toDouble(), height.toDouble()),
      new Paint(),
    );

    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  static Future<Map<String, dynamic>> deviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      return readIosDeviceInfo(await deviceInfo.iosInfo);
    }
    return readAndroidBuildData(await deviceInfo.androidInfo);
  }

  static Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  static Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
