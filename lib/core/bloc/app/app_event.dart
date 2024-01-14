import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/model/push_message.dart';
import 'package:movemedriver/model/user.dart';

class AppNewMessageEvent {
  PushMessage pushMessage;

  AppNewMessageEvent(this.pushMessage);
}

class UnauthenticatedEvent {
  UnauthenticatedEvent();
}

class CreateOrOpenNewChatEvent {
  String type;
  String id;
  CreateOrOpenNewChatEvent(this.type, this.id);
}

class AppLoginEvent {
  User user;

  AppLoginEvent(this.user);
}

class AppLogoffEvent {
  AppLogoffEvent();
}

class ChangeStateEvent {
  AppStateEnum state;
  ChangeStateEvent(this.state);
}

class GpsChangedEvent {
  GpsChangedEvent();
}

class RouteFinishedEvent {
  String id;

  RouteFinishedEvent({this.id});
}