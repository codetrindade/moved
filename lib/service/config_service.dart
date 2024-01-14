import 'package:movemedriver/base/base_http.dart';
import 'package:movemedriver/model/response.dart';

class ConfigService extends HttpBase {
  ConfigService(String token) : super(token);

  Future<ResponseData> contact(subject, detail, phone, description) async {
    return await post('contact',
            '{"subject":"$subject","detail":"$detail","phone":"$phone","description":"$description"}')
        .then((map) => ResponseData.fromJson(map));
  }
}
