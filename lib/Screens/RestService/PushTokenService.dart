import 'dart:convert';

import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PushTokenService {
// https://zrrlyf7lv2.execute-api.us-east-1.amazonaws.com/churchapi/CreateEndpointModule
  static final String GET_CreateEndPoint_URL =
      '${Config.baseUrl}/CreateEndpoint';

  static final String GET_DeleteEndPoint_URL =
      '${Config.baseUrl}/deleteEndpointModule';

  sendupdatedToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String pushtoken = prefs.getString('pushtoken');
    String token = prefs.getString('newpushtoken');
    String phonenumber = prefs.getString('phone');
    // if (pushtoken != token) {
    prefs.setString('pushtoken', token);
    final String url = GET_CreateEndPoint_URL;
    Map data = {'deviceId': token, "phoneNumber": phonenumber};
    print("Map" + data.toString());
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("create or Push " + response.body.toString());
    // }
  }

  deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phonenumber = prefs.getString('phone');
    final String url = GET_DeleteEndPoint_URL;
    Map data = {"phoneNumber": phonenumber};
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print("delete" + response.body.toString());
    sendupdatedToken();
  }
}
