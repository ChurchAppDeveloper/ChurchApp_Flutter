import 'dart:convert';
import 'dart:io';

import 'package:churchapp/model_response/mass_response.dart';
import 'package:churchapp/model_response/timing_create_response.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:churchapp/util/api_constants.dart';

Future<MassResponse> getMass() async {
  String token = await SharedPref().getStringPref(SharedPref().token);
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse('$baseUrl/massTimingList'),headers: requestHeaders);
    var data = json.decode(response.body);

    MassResponse list =
    MassResponse.fromJson(data);
    return list;
  } catch (e) {
    debugPrint("Error $e");
    return null;
  }
}

Future createTimingAPI(Map<String, dynamic> timingForm) async {
  debugPrint("TIMING :${jsonEncode(timingForm)}");
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/createMassTiming";
  Map<String, String> requestHeaders = {
    // HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  final response = await http.post(Uri.parse(url),
      body: jsonEncode(timingForm), headers: requestHeaders);
  var data = TimingCreateResponse.fromJson(json.decode(response.body));
  debugPrint("Timing_response: ${response.request.headers.toString()}");
  debugPrint("Timing_response: ${response.body}");
  if (response.statusCode == 200) {
    if (data.success) {
      debugPrint("content:${data.content}");
      Get.back();
    } else {
      snackBarAlert(warning, data.message.toString(),
          Icon(Icons.warning_amber_outlined), warningColor, blackColor);
    }
  } else {
    snackBarAlert(error, data.message.toString(), Icon(Icons.error_outline),
        errorColor, whiteColor);
  }
}
