import 'dart:io';
import 'dart:convert';
import 'package:amazon_s3_cognito/amazon_s3_cognito.dart';
import 'package:amazon_s3_cognito/aws_region.dart';
import 'package:churchapp/model_request/annoucement_create_request.dart';
import 'package:churchapp/model_response/announcement_count_response.dart';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/s3_upload.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
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
}
Future<AnnouncementCountResponse> getAnnouncementCountAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl//getAnnouncementCount";
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
    return AnnouncementCountResponse.fromJson(data);
  }catch (e) {
    print("error $e");
    return AnnouncementCountResponse();
  }
}

Future createAnnouncementAPI(AnnouncementCreateRequest announcementForm, {File file}) async {

   await uploadToS3(file, "announcement-data").catchError((error){
    debugPrint("Error: $error");
    snackBarAlert(
        error, error, Icon(Icons.error_outline), errorColor, whiteColor);
  }).then((value) async {
     var list = List<String>();
     list.insert(0,value);
     announcementForm.urls= list;

     String token = await SharedPref().getStringPref(SharedPref().token);

     String url = "$baseUrl/createAnnouncement";
     Map<String, String> requestHeaders = {
       HttpHeaders.acceptHeader: "application/json",
       HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
       HttpHeaders.authorizationHeader: 'Bearer $token',

     };

     // var body = json.encode(otpForm);
     final response = await http.post(Uri.parse(url),
         body: announcementForm,
         headers: requestHeaders,
         encoding: Encoding.getByName("utf-8"));
     var data = AnnouncementResponse.fromJson(json.decode(response.body));
     debugPrint("Announcement_response: ${response.request.toString()}");
     debugPrint("Announcement_response: ${response.body}");

     if (response.statusCode == 200) {
       debugPrint("content:${data.content}");
       // await SharedPref().setStringPref(SharedPref().token, data.accessToken);

       // Get.offAllNamed("/home");'
     } else {
       snackBarAlert(
           error, attachmentError, Icon(Icons.error_outline), errorColor, whiteColor);
     }
  });

}
