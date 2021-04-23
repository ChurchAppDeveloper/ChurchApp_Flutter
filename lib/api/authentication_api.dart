import 'dart:convert';
import 'dart:io';

import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/model_response/login_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void loginAPI(LoginRequest loginRequest) async {
  String url =
      "$baseUrl/sendNotification?contactNumber=${loginRequest.contactNumber}";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response = await http.post(Uri.parse(url), headers: requestHeaders);
  var data = LoginResponse.fromJson(json.decode(response.body));

  if (response.statusCode == 200) {
    debugPrint("login_response: ${response.body}");
    if (data.success) {
      debugPrint("content:${data.content}");
      Get.toNamed("/otp", arguments: loginRequest.contactNumber);
    } else {
      snackBarAlert(warning, data.message.toString(),
          Icon(Icons.warning_amber_outlined), warningColor, blackColor);
    }
  } else {
    snackBarAlert(error, data.message.toString(), Icon(Icons.error_outline),
        errorColor, whiteColor);
  }
}
