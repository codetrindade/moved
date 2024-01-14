import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/document.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';

class DocumentService extends BaseService {
  Api _api;

  DocumentService() {
    this._api = locator.get<Api>();
  }

  Future<List<Document>> listAll() async {
    var data = getResponse(await _api.get('driver/document/list'));
    return (data as List).map((i) => new Document.fromJson(i)).toList();
  }
}