import 'dart:convert';
import 'dart:io';

import 'package:churchapp/model_response/mass_response.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/material.dart';
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