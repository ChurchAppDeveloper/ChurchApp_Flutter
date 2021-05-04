

import 'dart:io';

Future<void> sendTokenToServer(String token) async {
 /* String userToken =
  await FirebaseAuth.instance.currentUser.getIdToken().then((value) {
    debugPrint("access_token1:$value");
    return value;
  });

  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "Accept": "application/json",
    'x-access-token': '$userToken',
    'app': 'mobile',
  };
  Map<String, dynamic> args = {"deviceToken": token};
  var body = json.encode(args);
  Response response = await http.post('$base_url/deviceToken',
      headers: requestHeaders, body: body);
  if (response.statusCode == 200) {
    debugPrint(" Notification data: ${response.body}");
  }*/
}