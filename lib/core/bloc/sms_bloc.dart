import 'dart:async';

import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_bloc.dart';
import 'package:movemedriver/core/bloc/app/app_event.dart';
import 'package:movemedriver/core/service/sms_service.dart';
import 'package:movemedriver/locator.dart';

class SmsBloc extends BaseBloc {
  var smsService = locator.get<SmsService>();
  bool phonePage = true;

  int wait = 60;
  bool canSendSms = true;

  confirmSms(String phone, {String code = ''}) async {
    try {
      setLoading(true);
      var message = await smsService.confirmSMS(code, phone);
      if (message.message == 'SMS enviado!' || phonePage == true) {
        setLoading(false);
        phonePage = false;
        startTimer();
        this.refresh();
      } else {
        AppState.user.status = 'inactive';
        AppState.user.phone = phone;
        await AppState().setUser(AppState.user, token: true);
        setLoading(false);
        eventBus.fire(ChangeStateEvent(AppStateEnum.WIZARD));
      }
    } catch (e) {
      super.onError(e);
      canSendSms = true;
    } finally {
      setLoading(false);
    }
  }

  void startTimer() {
    new Timer.periodic(new Duration(seconds: 1), (Timer t) {
      try {
        wait -= 1;
        if (wait == 0) {
          t.cancel();
          canSendSms = true;
          wait = 60;
        }
        this.refresh();
      } catch (ex) {
        wait = 60;
        canSendSms = true;
        t.cancel();
        this.refresh();
      }
    });
  }
}
