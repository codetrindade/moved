import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/base/base_state.dart';
import 'package:movemedriver/component/moveme_icons.dart';
import 'package:movemedriver/core/bloc/main/main_bloc.dart';
import 'package:movemedriver/theme.dart';
import 'package:movemedriver/view/chat/chat_list_page.dart';
import 'package:movemedriver/view/history/history_list_page.dart';
import 'package:movemedriver/view/ride_list/ride_list_page.dart';
import 'package:movemedriver/view/home_scheduled/home_scheduled_page.dart';
import 'package:movemedriver/view/information/information_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage> {
  MainBloc bloc;

  getBody() {
    switch (bloc.state) {
      case MainState.CHAT:
        return ChatListPage();
      case MainState.PROFILE:
        return InformationPage();
      case MainState.HISTORY:
        return HistoryListPage();
      case MainState.RIDE:
        return RideListPage();
      default:
        return HomeScheduledPage();
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async => await bloc.initialize());
  }

  @override
  Widget build(BuildContext context) {
    AppState.devicePixelRatio = MediaQuery.of(context).devicePixelRatio.round();
    bloc = Provider.of<MainBloc>(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          Container(child: getBody()),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      decoration: BoxDecoration(
                          color: AppColors.colorWhite,
                          border: Border.all(color: AppColors.colorBlueLight),
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 10.0),
                            IconButton(
                                onPressed: () => bloc.changeState(MainState.CHAT),
                                icon: Icon(MoveMeIcons.speech_bubble,
                                    size: 30.0,
                                    color: bloc.state == MainState.CHAT
                                        ? AppColors.colorBlueLight
                                        : AppColors.colorGreyLight)),
                            IconButton(
                                onPressed: () => bloc.changeState(MainState.HISTORY),
                                icon: Icon(MoveMeIcons.parked_car,
                                    size: 30.0,
                                    color: bloc.state == MainState.HISTORY
                                        ? AppColors.colorBlueLight
                                        : AppColors.colorGreyLight)),
                            IconButton(
                                onPressed: () => bloc.changeState(MainState.HOME),
                                icon: Icon(MoveMeIcons.web_page_home,
                                    size: 30.0,
                                    color: bloc.state == MainState.HOME
                                        ? AppColors.colorBlueLight
                                        : AppColors.colorGreyLight)),
                            /*IconButton(
                                onPressed: () => bloc.changeState(MainState.RIDE),
                                icon: Icon(MoveMeIcons.people,
                                    size: 30.0,
                                    color: bloc.state == MainState.RIDE
                                        ? AppColors.colorBlueLight
                                        : AppColors.colorGreyLight)),*/
                            IconButton(
                                onPressed: () => bloc.changeState(MainState.PROFILE),
                                icon: Icon(MoveMeIcons.perfil,
                                    size: 30.0,
                                    color: bloc.state == MainState.PROFILE
                                        ? AppColors.colorBlueLight
                                        : AppColors.colorGreyLight)),
                            SizedBox(width: 10.0)
                          ]))))
        ]));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
