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
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const colorizeColors = [
  Colors.white,
  Colors.red,
  Colors.orange,
  Colors.black,
];

Future<List<Appointment>> getMass() async {
  List<Appointment> appointments = <Appointment>[];

  String token = await SharedPref().getStringPref(SharedPref().token);
  Map<String, String> requestHeaders = {
    HttpHeaders.contentTypeHeader: 'application/json',
    // HttpHeaders.authorizationHeader: 'Bearer $token',
  };
  try {
    final response = await http.get(Uri.parse('$baseUrl/massTimingListMobile'),
        headers: requestHeaders);
    var data = json.decode(response.body);
    debugPrint("massTimingListMobiles: $data");

    MassResponse list = MassResponse.fromJson(data);
    List<Content> contentTiming = list.content;
    Color colorType;
    for (int i = 0; i < contentTiming.length; i++) {
      if (contentTiming[i].scheduleType == "Mass Timing") {
        colorType = Colors.red;
      } else if (contentTiming[i].scheduleType == "Rosary") {
        colorType = Colors.pink;
      } else {
        colorType = Colors.orange;
      }
      DateTime tempDate =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(contentTiming[i].date);
      DateTime tempStart = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(contentTiming[i].startTime);
      DateTime tempEnd =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(contentTiming[i].endTime);
      debugPrint("Date: $tempDate");
      debugPrint("Date: $tempStart");
      debugPrint("Date: $tempEnd");
      String day = DateFormat("EEEE").format(tempDate);
      debugPrint("DateTime: ${day.substring(0, 3)}");
      appointments.add(Appointment(
          startTime: tempStart,
          endTime: tempEnd,
          subject: contentTiming[i].scheduleType,
          color: colorType,
          recurrenceRule:
              'FREQ=WEEKLY;INTERVAL=1;BYDAY=${day.substring(0, 3).toUpperCase()};'));
    }

    return appointments;
  } catch (e) {
    debugPrint("Error $e");
    return appointments;
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
