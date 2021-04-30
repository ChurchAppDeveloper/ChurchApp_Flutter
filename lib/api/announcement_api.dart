import 'dart:io';
import 'dart:convert';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
Future<AnnouncementResponse> getAnnouncementAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl//getAnnouncementList";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    debugPrint("Announcement_response: ${response.request}");
    debugPrint("profile_response: ${response.body}");

    var data = json.decode(response.body);
    // var rest = data["Items"] as List;
    // List<AnnouncementResponse> list = rest
    //     .map<AnnouncementResponse>(
    //         (json) => AnnouncementResponse.fromJson(json)).toList();
    //
    // print("models $list");
    return AnnouncementResponse.fromJson(data);
  }catch (e) {
    print("error $e");
    return AnnouncementResponse();
  }
  // var data = AnnouncementResponse.fromJson(json.decode(response.body));
  // debugPrint("Announcement_response: ${response.request}");
  // debugPrint("Announcement_response: ${response.body}");
  //
  // if (response.statusCode == 200) {
  //   if (data.success) {
  //     debugPrint("content:${data.content}");
  //     Get.offAndToNamed("/home");
  //   } else {
  //     Get.offAndToNamed("/login");
  //   }
  // } else {
  //   Get.offAndToNamed("/login");
  // }
}