import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static final String GET_Users_URL =
      'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/userModule';

  static final int httpStatusOK = 200;

  Future<List<UserData>> getProfileDetails() async {
    try {
      final response = await http.get(GET_Users_URL);
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<UserData> list =
          rest.map<UserData>((json) => UserData.fromJson(json)).toList();
      return list;
    } catch (e) {
      return List<UserData>();
    }
  }

  createNewUser(String phonenumber) async {
    final String url = GET_Users_URL;
    Map data = {'phoneNumber': phonenumber, 'userRole': "Contributor"};
    String body = json.encode(data);
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }
}

class UserData {
  final String phoneNumber;
  final String userRole;

  UserData({this.phoneNumber, this.userRole});

  factory UserData.fromJson(Map<String, dynamic> parsedJson) {
    return UserData(
        phoneNumber: parsedJson['phoneNumber'],
        userRole: parsedJson['userRole']);
  }
}
