import 'dart:convert';
import 'dart:io';

import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/model_response/login_response.dart';
import 'package:churchapp/model_response/otp_response.dart';
import 'package:churchapp/model_response/profile_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void loginAPI(LoginRequest loginRequest) async {
  String url =
      "$baseUrl/sendNotification?app=MOBILE&contactNumber=${loginRequest.contactNumber}";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
  };
  final response = await http.post(Uri.parse(url), headers: requestHeaders);
  var data = LoginResponse.fromJson(json.decode(response.body));

  if (response.statusCode == 200) {
    debugPrint("login_response: ${response.body}");
    if (data.success) {
      debugPrint("content:${data.content}");
      if (data.content == "Admin") {
        debugPrint("Role Content:${data.content}");
        snackBarAlert(warning, "Your Number Already Exits in Admin Role",
            Icon(Icons.warning_amber_outlined), warningColor, blackColor);

        // Get.toNamed("/otp", arguments: loginRequest.contactNumber);
      } else {
        Map<String, dynamic> otpForm = {
          "grant_type": "password",
          "username": loginRequest.contactNumber,
          "password": "",
          "client_id": "barnabas"
        };
        verifyOTPAPI(otpForm);
        // Get.offAllNamed("/home");
      }
    } else {
      snackBarAlert(warning, data.message.toString(),
          Icon(Icons.warning_amber_outlined), warningColor, blackColor);
    }
  } else {
    snackBarAlert(error, data.message.toString(), Icon(Icons.error_outline),
        errorColor, whiteColor);
  }
}

void verifyOTPAPI(Map<String, dynamic> otpForm) async {
  String url = "$baseUrl/oauth/token";
  String barnabas = "barnabas";
  String basicAuth =
      'Basic ' + base64Encode(utf8.encode('$barnabas:$barnabas'));
  Map<String, String> requestHeaders = {
    HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
    HttpHeaders.authorizationHeader: basicAuth,
  };
  // var body = json.encode(otpForm);
  debugPrint("otp_response: ${otpForm.toString()}");
  final response = await http.post(Uri.parse(url),
      body: otpForm,
      headers: requestHeaders,
      encoding: Encoding.getByName("utf-8"));
  var data = OTPResponse.fromJson(json.decode(response.body));
  debugPrint("otp_response: ${response.request.toString()}");
  debugPrint("otp_response: ${response.body}");

  if (response.statusCode == 200) {
    debugPrint("content:${data.accessToken}");
    await SharedPref().setStringPref(SharedPref().token, data.accessToken);

    Get.offAllNamed("/home");
  } else {
    snackBarAlert(
        error, invalidOTP, Icon(Icons.error_outline), errorColor, whiteColor);
  }
}

void profileAPI() async {
  // await SharedPref().setStringPref(SharedPref().token, "ab7e95c9-20a5-4922-8482-9a310230539c");
  // await SharedPref().setStringPref(SharedPref().token, "784e37cb-78f6-4a1d-bf07-aee955781157");
  String token = await SharedPref().getStringPref(SharedPref().token);
  debugPrint("Token: $token");
  String url = "$baseUrl/myprofile";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  final response = await http.get(Uri.parse(url), headers: requestHeaders);
  var data = ProfileResponse.fromJson(json.decode(response.body));
  debugPrint("profile_response: ${response.request}");
  debugPrint("profile_response: ${response.body}");

  if (response.statusCode == 200) {
    if (data.success) {
      debugPrint("content:${data.content}");
      Get.offAndToNamed("/home");
    } else {
      Get.offAndToNamed("/login");
    }
  } else {
    Get.offAndToNamed("/login");
  }
}

void profileDashAPI() async {
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl/myprofileMobile";
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  final response = await http.get(Uri.parse(url), headers: requestHeaders);
  var dataval = ProfileResponse.fromJson(json.decode(response.body));
  debugPrint("profile_request: ${response.request}");
  if (response.statusCode == 200) {
    debugPrint("profile_response1: ${response.body}");
    if (dataval.success) {
      debugPrint("content:${dataval.content}");
      await SharedPref().setStringPref(
          'phoneNumber', dataval.content.churchProfile.contactUs);
      await SharedPref().setStringPref(
          'confessionNumber', dataval.content.churchProfile.contactUs);
      await SharedPref().setStringPref(
          'confessionEmail', dataval.content.churchProfile.confessionEmail);
      await SharedPref().setStringPref(
          'confessionDetails', dataval.content.churchProfile.confessionDetails);
      await SharedPref()
          .setStringPref('aboutUs', dataval.content.churchProfile.aboutUs);
      await SharedPref().setStringPref(
          'ministersUrl', dataval.content.churchProfile.ministers);
      await SharedPref()
          .setStringPref('donateUrl', dataval.content.churchProfile.donate);
      await SharedPref()
          .setStringPref('websiteUrl', dataval.content.churchProfile.website);
      await SharedPref()
          .setStringPref('youtubeUrl', dataval.content.churchProfile.youtube);
      await SharedPref()
          .setStringPref('facebookUrl', dataval.content.churchProfile.facebook);
      await SharedPref()
          .setStringPref('schoolUrl', dataval.content.churchProfile.school);
      await SharedPref()
          .setStringPref('bulletinUrl', dataval.content.churchProfile.bulletIn);
      await SharedPref().setStringPref(
          'onlieReadingUrl', dataval.content.churchProfile.onlineReading);
      await SharedPref().setStringPref(
          'prayerRequestUtl', dataval.content.churchProfile.prayerRequest);
      await SharedPref().setStringPref('masstimingintention',
          dataval.content.churchProfile.massTimeIntention);
      await SharedPref()
          .setStringPref(SharedPref().role, dataval.content.roleName);
      await SharedPref().setStringPref('userNumber', dataval.content.contactNo);
    } else {
      snackBarAlert(warning, dataval.message.toString(),
          Icon(Icons.warning_amber_outlined), warningColor, blackColor);
    }
  } else {
    snackBarAlert(error, dataval.message, Icon(Icons.error_outline), errorColor,
        whiteColor);
  }
}
