import 'dart:convert';

class RegisterData {
  String name = '';
  String email = '';
  String phone = '';
  String ddd = '';
  String photo = '';
  String facebookId = '';
  String device = '';
  String platform = '';
  String pushToken = '';

  Map<String, String> toMap() {
    var map = new Map<String, String>();
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['ddd'] = ddd;
    map['photo'] = photo;
    map['facebook_id'] = facebookId;
    map['device'] = device;
    map['platform'] = platform;
    map['push_token'] = pushToken;
    return map;
  }

  @override
  String toString() {
    return json.encode(toMap());
  }
}
