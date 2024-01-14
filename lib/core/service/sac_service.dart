import 'package:http/http.dart' as http;
import 'package:movemedriver/core/base/base_service.dart';

class SacService extends BaseService {
  Future<bool> createTicket(String ticket) async {
    var result = getResponse(
        await http.post(Uri.parse('https://movemebrhelp.zendesk.com/api/v2/requests.json'), body: ticket, headers: getHeaders()));
    if (result != null)
      return true;
    else
      return false;
  }

  getHeaders() {
    var header = new Map<String, String>();
    header['Content-Type'] = 'application/json';
    header['Accept'] = 'application/json';
    return header;
  }
}
