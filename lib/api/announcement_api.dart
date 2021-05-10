import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:churchapp/model_request/annoucement_create_request.dart';
import 'package:churchapp/model_response/announcement_count_response.dart';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dios;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';

Future<AnnouncementResponse> getAnnouncementAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/getAnnouncementList";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
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
    BuildContext context, int id, String fileName) async {
  if (fileName != null) {
    String url =
        "$baseUrl/getannouncementImage?announcementid=$id&fileName=$fileName";
    var bulletin = WebViewLoad(
        weburl: url, isShowAppbar: true, pageTitle: "Announcement Details");
    bulletin.contentDesc = url;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => bulletin),
    );
  }
}

Future<AnnouncementCountResponse> getAnnouncementCountAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/getAnnouncementCount";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
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
  var list = List<String>();
  list.insert(0, "");
  announcementForm.urls = list;

  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/createAnnouncement";
  Map<String, String> requestHeaders = {
    // HttpHeaders.acceptHeader: "application/json",
    // HttpHeaders.contentTypeHeader: "multipart/form-data",

    HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  // var request = http.MultipartRequest("POST", Uri.parse(url));
  // request.fields["json"] = jsonEncode(announcementForm);
  // request.headers.addAll({"Content-Type": "application/json"});
  // request.headers.addAll(requestHeaders);
  // debugPrint("File ${file.path}");
  //
  // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //     'file', file.path, contentType: new MediaType("image", "jpeg"), filename: file.path.split("/").last
  // ); //returns a Future<MultipartFile>
  //
  // request.files.add(multipartFile);
  // debugPrint("Fields ${request.fields.toString()}");
  // try {
  //   final response =
  //   await request.send().timeout(const Duration(seconds: 60));
  //   var res = await http.Response.fromStream(response);
  //   // responseJson = responseToJson(res);
  //   // responseJson = res;
  //   debugPrint("Res ${res.body}");
  //   Get.back();
  //
  // } on SocketException {
  //   throw Exception("You are not connected to internet");
  // } on TimeoutException catch (e) {
  //   print('Time out');
  //   throw TimeoutException('Time out');
  // }

  /*var stream =  http.ByteStream(file.openRead());
  stream.cast();
  var length = await file.length();

  var uri = Uri.parse(url);

  var request =  http.MultipartRequest("POST", uri);
  var multipartFile =  http.MultipartFile('file', stream, length,
      filename: basename(file.path));
  //contentType: new MediaType('image', 'png'));
  request.fields["json"] = jsonEncode(announcementForm);
  request.headers.addAll({"Accept": "application/json",});
  request.headers.addAll({"Content-Type": "application/json"});
  request.headers.addAll(requestHeaders);
  debugPrint("File ${file.path}");
  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  print(response.headers);
  print(request.headers);
  print(request.fields);
  print(request.files);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });*/
  print(jsonEncode(announcementForm));
  Dio dio = Dio();
  print("Token $token");
  String mimeType = mime(file.path);
  String mimee = mimeType.split('/')[0];
  String type = mimeType.split('/')[1];
  // dio.options.headers["Accept"] = "application/json";
  dio.options.headers["Authorization"] = "Bearer $token";
  //dio.options.headers["Content-Type"] = "multipart/form-data";
  var formData = dios.FormData.fromMap({
    'json': jsonEncode(announcementForm),
    'file': await dios.MultipartFile.fromFile(file.path,
        filename: file.path.split('/').last),
  });
  var response = await dio.post(
    url,
    data: formData,
    onSendProgress: (int sent, int total) {
      print('$sent $total');
    },
  ).catchError((error) {
    debugPrint("Error $error");
  }).then((value) {
    debugPrint("Then $value");
  });
  print(response.data);
  print(response.headers);
  print(response.statusCode);

  // await request.send().then((response) {
  //
  //    if (response.statusCode == 200) {
  //      Get.back();
  //    } else if(response.statusCode == 415){
  //      snackBarAlert(error, "Invalid file format", Icon(Icons.error_outline),
  //          errorColor, whiteColor);
  //    }
  //    else {
  //      snackBarAlert(error, response.statusCode.toString(), Icon(Icons.error_outline),
  //          errorColor, whiteColor);
  //    }
  //  }).catchError((error){
  //    snackBarAlert(error, error.toString(), Icon(Icons.error_outline),
  //        errorColor, whiteColor);
  //  });
}
