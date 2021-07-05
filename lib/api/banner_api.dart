import 'dart:convert';
import 'dart:io';

import 'package:churchapp/model_response/banner_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<BannerResponse> getBanners() async {
  String token = await SharedPref().getStringPref(SharedPref().token);
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse('$baseUrl/bannerImageListMobile'),headers: requestHeaders);
    var data = json.decode(response.body);

    BannerResponse list =
     BannerResponse.fromJson(data);
    return list;
  } catch (e) {
    debugPrint("Error $e");
    return null;
  }
}