import 'package:movemedriver/core/base/base_service.dart';
import 'package:movemedriver/core/model/extract.dart';
import 'package:movemedriver/core/service/api_service.dart';
import 'package:movemedriver/locator.dart';

class ExtractService extends BaseService {
  Api _api;

  ExtractService() {
    this._api = locator.get<Api>();
  }

  Future<Extract> getExtract(String start, String end) async {
    return Extract.fromJson(
        getResponse(await _api.post('driver/route/extract', '{"start":"$start", "end":"$end"}')));
  }
}
