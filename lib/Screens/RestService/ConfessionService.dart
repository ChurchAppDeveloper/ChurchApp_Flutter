//

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class ConfessionService {
  static final String FetchBookedSlots =
      'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/slotModule?slotStatus=Booked';

  static final String PostNewSlot =
      'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/slotModule';

  static final String FetchAvailableSlots =
      'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/slotModule?slotStatus=Available';

  static final String FetchConfession =
      "https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/confessionModule";

  static final int httpStatusOK = 200;

  Future<List<ConfessionData>> getConfessionData() async {
    try {
      final response = await http.get(FetchConfession);
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<ConfessionData> list = rest
          .map<ConfessionData>((json) => ConfessionData.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      print("error $e");
      return List<ConfessionData>();
    }
  }

  createNewSlots(ConfessionItem slot) async {
    final String url = PostNewSlot;
    Map data = {
      'slotId': slot.slotId.toString(),
      'slotStatus': "Booked",
      'startTime': slot.startTime,
      'phoneNumber': slot.phoneNumber,
      "endTime": slot.endTime,
      "confessionId": slot.confessionId
    };
    String body = json.encode(data);
    http.Response response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }

  Future<List<ConfessionItem>> getBookedConfessionList() async {
    try {
      final response = await http.get(FetchBookedSlots);
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<ConfessionItem> list = rest
          .map<ConfessionItem>((json) => ConfessionItem.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      print("error $e");
      return List<ConfessionItem>();
    }
  }

  Future<List<ConfessionItem>> getAvailableConfessionList() async {
    try {
      final response = await http.get(FetchAvailableSlots);
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<ConfessionItem> list = rest
          .map<ConfessionItem>((json) => ConfessionItem.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      print("error $e");
      return List<ConfessionItem>();
    }
  }
}

class ConfessionData {
  final String phoneNumber;
  final int startTime;
  final int endTime;
  final String confessionId;
  final String confessionDate;
  final int slotDuration;
  ConfessionData(
      {this.phoneNumber,
      this.startTime,
      this.endTime,
      this.confessionId,
      this.confessionDate,
      this.slotDuration});

  factory ConfessionData.fromJson(Map<String, dynamic> parsedJson) {
    return ConfessionData(
        phoneNumber: parsedJson['phoneNumber'],
        startTime: parsedJson['startTime'],
        endTime: parsedJson['endTime'],
        confessionId: parsedJson['confessionId'],
        confessionDate: parsedJson['confessionDate'],
        slotDuration: parsedJson['slotDuration']);
  }
}

class ConfessionItem {
  final String startTime;
  final String phoneNumber;
  final String slotStatus;
  final String slotId;
  final String endTime;
  final String confessionId;
  ConfessionItem(
      {this.startTime,
      this.phoneNumber,
      this.slotStatus,
      this.slotId,
      this.endTime,
      this.confessionId});
  factory ConfessionItem.fromJson(Map<String, dynamic> parsedJson) {
    return ConfessionItem(
        startTime: parsedJson['startTime'],
        phoneNumber: parsedJson['phoneNumber'],
        slotStatus: parsedJson['slotStatus'],
        slotId: parsedJson['slotId'],
        endTime: parsedJson['endTime'],
        confessionId: parsedJson['confessionId']);
  }
}
