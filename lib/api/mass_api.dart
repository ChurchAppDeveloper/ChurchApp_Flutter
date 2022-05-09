import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:churchapp/model_response/mass_response.dart';
import 'package:churchapp/model_response/timing_create_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
    final response = await http.get(Uri.parse('$baseUrl3/massTimingListMobile'),
        headers: requestHeaders);
    var data = json.decode(response.body);
    debugPrint("massTimingListMobiles: $data");

    MassResponse list = MassResponse.fromJson(data);
    List<Content> contentTiming = list.content;

    for (int i = 0; i < contentTiming.length; i++) {
      // DateTime tempDate =
      //     DateFormat("yyyy-MM-dd HH:mm:ss").parse(contentTiming[i].startDate);
      DateTime tempStart = new DateFormat("yyyy-MM-dd HH:mm:ss")
          .parse(contentTiming[i].startTime);
      DateTime tempEnd =
          DateFormat("yyyy-MM-dd HH:mm:ss").parse(contentTiming[i].endTime);
      // debugPrint("Date: $tempDate");
      debugPrint("StartDate: $tempStart");
      debugPrint("EndDate: $tempEnd");
      // String day = DateFormat("EEEE").format(tempDate);
      // debugPrint("DateTime: ${day.substring(0, 3)}");
      appointments.add(Appointment(
        startTime: tempStart,
        endTime: tempEnd,
        location: "In Church",
        isAllDay: false,
        subject: contentTiming[i].scheduleType,
        color:contentTiming[i].primaryColour==null?Color.fromARGB(255, 219, 69, 71): HexColor(contentTiming[i].primaryColour),
        // recurrenceRule:
          //     'FREQ=WEEKLY;INTERVAL=1;BYDAY=${day.substring(0, 3).toUpperCase()};'
      ));
    }

    return appointments;
  } catch (e) {
    debugPrint("Error $e");
    return appointments;
  }
}
class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    log("yes usss ${hexColor==null}");
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
Future createTimingAPI(Map<String, dynamic> timingForm) async {
  debugPrint("TIMING :${jsonEncode(timingForm)}");
  String token = await SharedPref().getStringPref(SharedPref().token);

  String url = "$baseUrl3/createMassTiming";

  Map<String, String> requestHeaders = {
    // HttpHeaders.acceptHeader: "application/json",
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.authorizationHeader: 'Bearer $token',
  };
print("urls is $url ${jsonEncode(timingForm)}");
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
