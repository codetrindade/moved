import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:movemedriver/app_state.dart';
import 'package:movemedriver/core/base/base_bloc.dart';
import 'package:movemedriver/core/service/upload_service.dart';
import 'package:movemedriver/core/service/user_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:movemedriver/model/user.dart';

class UserBloc extends BaseBloc {
  var userService = locator.get<UserService>();
  var uploadService = locator.get<UploadService>();
  var appDataUser = AppState.user;
  bool showMyPhone = false;

  initialize() {
    showMyPhone = appDataUser.displayMyPhone;
    notifyListeners();
  }

  changeDisplayMyPhone() async {
    try {
      setLoading(true);
      showMyPhone = await userService.changeDisplayMyPhone();
      AppState.user.displayMyPhone = showMyPhone;
      await AppState().setUser(AppState.user);
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }

  update(User model) async {
    try {
      setLoading(true);
      await userService.updateProfile(model);
      await AppState().setUser(AppState.user);
      navigationManager.goBack();
      dialogService.showDialog('Sucesso', 'Dados atualizados com sucesso!');
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(true);
    }
  }

  chooseImage(ImageSource source) async {
    try {
      var pickedFile = await ImagePicker().getImage(
          source: source, preferredCameraDevice: CameraDevice.front, maxHeight: 600, maxWidth: 600);
      if (pickedFile != null) {
        var img = await navigationManager.navigateTo('/crop', arguments: File(pickedFile.path));
        var result = await uploadService.uploadDocument('user-photo', img);
        AppState.user.photo = result.message;
        await AppState().setUser(AppState.user);
      }
    } catch (e) {
      super.onError(e);
    } finally {
      setLoading(false);
    }
  }
}
