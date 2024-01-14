import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:movemedriver/core/model/push_message.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin manager = FlutterLocalNotificationsPlugin();

  LocalNotificationService();

  Future<void> initialize() async {
    final NotificationAppLaunchDetails notificationAppLaunchDetails =
        await manager.getNotificationAppLaunchDetails();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

  //  final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
 //       requestAlertPermission: false,
 //       requestBadgePermission: false,
 //       requestSoundPermission: false,
 //       onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  //  final InitializationSettings initializationSettings = InitializationSettings(
  //      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

 //   await manager.initialize(initializationSettings, onSelectNotification: selectNotification);
//
    manager
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> showOngoingNotification(String message) async {
   // const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
   //     'your channel id', 'your channel name', 'your channel description',
  //      importance: Importance.max, priority: Priority.high, ongoing: true, autoCancel: false);
  //  const NotificationDetails platformChannelSpecifics =
  //      NotificationDetails(android: androidPlatformChannelSpecifics);
  //  await manager.show(0, 'MoveMe', message, platformChannelSpecifics);
  }

  Future<void> removeOngoingNotification() async {
    await manager.cancel(0);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {}

  Future selectNotification(String payload) async {}

 Future showNotification(PushMessage push) async {
  //  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //      'your channel id', 'your channel name', 'your channel description',
 //       importance: Importance.max, priority: Priority.high);
//    const NotificationDetails platformChannelSpecifics =
 //       NotificationDetails(android: androidPlatformChannelSpecifics);
 //   await manager.show(0, push.title, push.body, platformChannelSpecifics, payload: push.toString());
  }
//

}

