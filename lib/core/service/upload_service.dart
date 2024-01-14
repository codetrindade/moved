import 'dart:io';

import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/upload_response.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';
import 'package:http/http.dart' as http;

class UploadService extends BaseService {
  Api _api;

  UploadService() {
    this._api = locator.get<Api>();
  }

  Future<UploadResponse> uploadImage(String id, String type, File file, {String subtype}) async {
    var url = "upload/$type/$id";
    url += "/$subtype";
    var streamedResponse = await _api.postFile(url, file);
    return UploadResponse.fromJson(getResponse(await http.Response.fromStream(streamedResponse)));
  }

  Future<UploadResponse> uploadDocument(String type, File file, {String id}) async {
    var url = "upload/$type";
    url += "/$id";
    var streamedResponse = await _api.postFile(url, file);
    return UploadResponse.fromJson(getResponse(await http.Response.fromStream(streamedResponse)));
  }
}
