import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:churchapp/Model/ClassifiedModel.dart';
import 'package:churchapp/model_request/business_create_request.dart';
import 'package:churchapp/model_request/classified_create_request.dart';
import 'package:churchapp/model_response/business_type_create_response.dart';
import 'package:churchapp/model_response/get_business_type_response.dart';
import 'package:churchapp/model_response/get_classified_response.dart'
    as getClassified;
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future createBusinessTypeAPI(Map<String, dynamic> businessTypeForm) async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/createBusinessType";
  Map<String, String> requestHeaders = {
    // HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  final response = await http.post(Uri.parse(url),
      body: jsonEncode(businessTypeForm), headers: requestHeaders);
  var data = BusinessTypeCreateResponse.fromJson(json.decode(response.body));
  debugPrint("business_response: ${response.request.headers.toString()}");
  debugPrint("business_response: ${response.body}");
  if (response.statusCode == 200) {
    debugPrint("business_response: ${response.body}");
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

Future<List<ClassifiedModel>> getBusinessType(filter) async {
  String token = await SharedPref().getStringPref(SharedPref().token);
  List<ClassifiedModel> model = List<ClassifiedModel>();
  String url = "$baseUrl/businessTypeList?search=$filter";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    debugPrint("Announcement_response: ${response.request}");
    debugPrint("profile_response: ${response.body}");

    var data = json.decode(response.body);
    BusinessTypeResponse businessTypeResponse =
        BusinessTypeResponse.fromJson(data);
    List<Content> content = businessTypeResponse.content;

    for (int i = 0; i < content.length; i++) {
      model.add(ClassifiedModel(
          name: content[i].businessName, id: content[i].businessId));
    }

    return model;
  } catch (e) {
    print("error $e");
    return model;
  }
}

Future createClassifiedAPI(ClassifiedCreateRequest classifiedForm,
    {File file}) async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/createClassifier";
  Map<String, String> requestHeaders = {
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };

  var request = http.MultipartRequest("POST", Uri.parse(url));
  request.fields["businessName"] = classifiedForm.businessName;
  request.fields["phoneNumber"] = classifiedForm.phoneNumber;
  request.fields["businessTypeId"] = classifiedForm.businessTypeId.toString();
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

Future<getClassified.ClassifiedResponse> getClassifiedAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/classifiedList";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse(url), headers: requestHeaders);
    debugPrint("Announcement_response: ${response.request}");
    debugPrint("profile_response: ${response.body}");

    var data = json.decode(response.body);
    return getClassified.ClassifiedResponse.fromJson(data);
  } catch (e) {
    print("error $e");
    return getClassified.ClassifiedResponse();
  }
}
