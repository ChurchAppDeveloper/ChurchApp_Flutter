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
    final response = await http.get(Uri.parse('$baseUrl3/bannerImageListMobile'),
        headers: requestHeaders);
    var data = json.decode(response.body);
    debugPrint("BannerData $data");

    BannerResponse list = BannerResponse.fromJson(data);
    debugPrint("BannerList:${list.content}");
    return list;
  } catch (e) {
    debugPrint("Error in banners api $e");
    return null;
  }
}
