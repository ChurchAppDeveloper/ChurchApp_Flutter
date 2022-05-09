import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:churchapp/Screens/WebViewPdfLoad.dart';
import 'package:churchapp/model_request/annoucement_create_request.dart';
import 'package:churchapp/model_request/read_notification_request.dart';
import 'package:churchapp/model_response/announcement_count_response.dart';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/model_response/read_notification_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/src/smart_refresher.dart';

Future<AnnouncementResponse> getAnnouncementAPI() async {
  String deviceId = await SharedPref().getStringPref(SharedPref().deviceId);
  debugPrint("deviceId: $deviceId");

  String url = "$baseUrl3/getAnnouncementListMobile?deviceId=$deviceId";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    debugPrint("Announcement_response: ${response.request}");
    debugPrint("profile_response: ${response.body}");

    var data = json.decode(response.body);
    return AnnouncementResponse.fromJson(data);
  } catch (e) {
    print("error $e");
    return AnnouncementResponse();
  }
}

Future getAnnouncementImageAPI(
    BuildContext context, int id, String fileName, Uri uri) async {
  debugPrint("$fileName");
  String url =
     /*"http://3.208.178.159:9876/barnabas/getannouncementImage?announcementid=$id&fileName=$fileName";*/"$baseUrl3/getannouncementImage?announcementid=$id&fileName=$fileName";
  debugPrint("AnnouncementImage:$url");
  var bulletin = WebViewPdfLoad(
    weburl: url,
    isShowAppbar: true,
    pageTitle: "Announcement Details",
    url: uri,
    fileName: fileName,
  );
  bulletin.contentDesc = url;
  debugPrint("bulletin:$bulletin");

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => bulletin),
  );
}

Future readNotificationAPI(ReadNotificationRequest readNotificationRequest,
    RefreshController refreshController) async {
  String deviceId = await SharedPref().getStringPref(SharedPref().deviceId);

  String url = "$baseUrl3/ReadNotificationsbyDeviceId";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  readNotificationRequest.deviceId = deviceId;
  var body = json.encode(readNotificationRequest);
  debugPrint("url read notification : $url");
  debugPrint("notify_body: $body");
  final response =
      await http.post(Uri.parse(url), body: body, headers: requestHeaders);
  debugPrint("productAddRequest1 ${response.body}");

  updateAnnouncementStatus(readNotificationRequest.announcementId);
  var data = ReadNotificationResponse.fromJson(json.decode(response.body));

  if (response.statusCode == 200) {
    refreshController.requestRefresh();

    debugPrint("Response ${data.message}");
  }
}

updateAnnouncementStatus(id)async{
  String deviceId = await SharedPref().getStringPref(SharedPref().deviceId);

  String url = "$baseUrl3/notifications/updatestatus";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "X-Device-ID":deviceId
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  var body = json.encode({
    "id": id
  });
  debugPrint("url annoucemet update status : $url");
  debugPrint("notify_body: $body");
  final response =
      await http.put(Uri.parse(url), body: body, headers: requestHeaders);
  debugPrint("productAddRequest12 ${response.body}");
}

Future<AnnouncementCountResponse> getAnnouncementCountAPI() async {
  String deviceId = await SharedPref().getStringPref(SharedPref().deviceId);
  debugPrint("deviceId: $deviceId");
 // String url = "$baseUrl/UnReadNotificationCount?deviceId=$deviceId";
  String url = "$baseUrl3/notifications/count";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    "X-Device-ID":deviceId
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    debugPrint("Announcement_response: ${response.request}");
    debugPrint("profile_response: ${response.body}");
    var data = json.decode(response.body);
    return AnnouncementCountResponse.fromJson(data);
  } catch (e) {
    print("error $e");
    return AnnouncementCountResponse();
  }
}

Future createAnnouncementAPI(AnnouncementCreateRequest announcementForm,
    {File file}) async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl3/createAnnouncement";
  Map<String, String> requestHeaders = {
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  var request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields["description"] = announcementForm.description;
  request.fields["title"] = announcementForm.title;
  request.headers.addAll({"Content-Type": "application/json"});
  request.headers.addAll(requestHeaders);
  debugPrint("File ${file.path}");

  http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
      'file', file.path,
      filename: file.path.split("/").last); //returns a Future<MultipartFile>

  request.files.add(multipartFile);
  debugPrint("Fields ${request.fields.toString()}");
  try {
    final response = await request.send().timeout(const Duration(seconds: 60));
    var res = await http.Response.fromStream(response);
    debugPrint("Res ${res.body}");
    Get.back();
  } on SocketException {
    snackBarAlert(error, "You are not connected to internet",
        Icon(Icons.error_outline), errorColor, whiteColor);
    throw Exception("You are not connected to internet");
  } on TimeoutException catch (e) {
    snackBarAlert(
        error, 'Time out', Icon(Icons.error_outline), errorColor, whiteColor);
    throw TimeoutException('Time out');
  }
}
