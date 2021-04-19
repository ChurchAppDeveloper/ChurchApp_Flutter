import 'dart:convert';

import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:http/http.dart' as http;

class MassTimingService {
  static final String GET_MassTiming_URL =
      '${Config.baseUrl}/massMeetingModule';

  static final String GET_Echrastic_URL =
      '${Config.baseUrl}/eventModule?eventId=1';

  static final String GET_Rosary_URL =
      '${Config.baseUrl}/eventModule?eventId=2';

  static final int httpStatusOK = 200;

  static Future<List<MassTiming>> getTimings() async {
    try {
      final response = await http.get(Uri.parse(GET_MassTiming_URL));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      // print("rest $rest");
      List<MassTiming> list =
          rest.map<MassTiming>((json) => MassTiming.fromJson(json)).toList();
      // print("list   $list");
      return list;
    } catch (e) {
      return List<MassTiming>();
    }
  }

  Future<List<EchurasticRosaryData>> getEchrasticData() async {
    try {
      final response = await http.get(Uri.parse(GET_Echrastic_URL));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;

      List<EchurasticRosaryData> list = rest
          .map<EchurasticRosaryData>(
              (json) => EchurasticRosaryData.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      return List<EchurasticRosaryData>();
    }
  }

  Future<List<EchurasticRosaryData>> getRosaryData() async {
    try {
      final response = await http.get(Uri.parse(GET_Rosary_URL));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;

      List<EchurasticRosaryData> list = rest
          .map<EchurasticRosaryData>(
              (json) => EchurasticRosaryData.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      return List<EchurasticRosaryData>();
    }
  }

  updateWeelyMassTiming1() async {
    final String url = GET_MassTiming_URL;
    Map data = {
      'phoneNumber': "9876543210",
      'startTime': 1613395183064,
      'endTime': 1613402983064,
      'massId': "7",
      'days': "Saturday",
      'endReminder': true,
      'startReminder': true
    };
    String body = json.encode(data);
    http.Response response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }

  updateWeelyMassTiming(MassTiming masstiming) async {
    final String url = GET_MassTiming_URL;
    Map data = {
      'phoneNumber': masstiming.phoneNumber,
      'startTime': masstiming.startTime,
      'endTime': masstiming.endTime,
      'massId': masstiming.massId,
      'days': masstiming.days,
      'endReminder': masstiming.endReminder,
      'startReminder': masstiming.startReminder
    };
    String body = json.encode(data);
    http.Response response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }

  updateEchurasticRosaryData(
      EchurasticRosaryData masstiming, bool isRosary) async {
    final String url = isRosary ? GET_Rosary_URL : GET_Echrastic_URL;
    Map data = {
      'startTime': masstiming.startTime,
      'eventId': masstiming.eventId,
      'days': masstiming.days,
      'startRemainder': masstiming.startRemainder,
      'phoneNumber': masstiming.phoneNumber,
    };
    String body = json.encode(data);
    http.Response response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }
}

class MassTiming {
  final String phoneNumber;
  final int startTime;
  final String massId;
  final int endTime;
  final String days;
  final bool endReminder;
  final bool startReminder;

  MassTiming(
      {this.phoneNumber,
      this.startTime,
      this.massId,
      this.endTime,
      this.days,
      this.endReminder,
      this.startReminder});

  factory MassTiming.fromJson(Map<String, dynamic> parsedJson) {
    return MassTiming(
        phoneNumber: parsedJson['phoneNumber'],
        startTime: parsedJson['startTime'],
        massId: parsedJson['massId'],
        endTime: parsedJson['endTime'],
        days: parsedJson['days'],
        endReminder: parsedJson['endReminder'],
        startReminder: parsedJson['startReminder']);
  }
}

class EchurasticRosaryData {
  final String eventId;
  final String days;
  final String phoneNumber;
  final int startTime;
  final String startRemainder;
  EchurasticRosaryData(
      {this.eventId,
      this.days,
      this.phoneNumber,
      this.startTime,
      this.startRemainder});

  factory EchurasticRosaryData.fromJson(Map<String, dynamic> parsedJson) {
    return EchurasticRosaryData(
        startTime: parsedJson['startTime'],
        eventId: parsedJson['eventId'],
        days: parsedJson['days'],
        startRemainder: parsedJson['startRemainder'],
        phoneNumber: parsedJson['phoneNumber']);
  }
}
