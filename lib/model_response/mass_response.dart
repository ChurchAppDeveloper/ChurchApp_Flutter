// To parse this JSON data, do
//
//     final massResponse = massResponseFromJson(jsonString);

import 'dart:convert';

MassResponse massResponseFromJson(String str) => MassResponse.fromJson(json.decode(str));

String massResponseToJson(MassResponse data) => json.encode(data.toJson());

class MassResponse {
  MassResponse({
    this.success,
    this.message,
    this.content,
  });

  bool success;
  String message;
  List<Content> content;

  factory MassResponse.fromJson(Map<String, dynamic> json) => MassResponse(
    success: json["success"],
    message: json["message"],
    content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "content": List<dynamic>.from(content.map((x) => x.toJson())),
  };
}

class Content {
  Content({
    this.id,
    this.date,
    this.startTime,
    this.endTime,
    this.scheduleType,
  });

  int id;
  String date;
  String startTime;
  String endTime;
  String scheduleType;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    scheduleType: json["schedule_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "start_time": startTime,
    "end_time": endTime,
    "schedule_type": scheduleType,
  };
}
