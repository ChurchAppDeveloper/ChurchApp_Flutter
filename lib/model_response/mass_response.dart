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
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.primaryColour,
    this.secondaryColour,
    this.scheduleType,
  });

  int id;
  String startDate;
  String endDate;
  String startTime;
  String endTime;
  String primaryColour;
  String secondaryColour;
  String scheduleType;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    id: json["id"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    primaryColour: json["primaryColour"],
    secondaryColour:json["secondaryColour"],
    scheduleType: json["schedule_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "startDate": startDate,
    "endDate": endDate,
    "start_time": startTime,
    "end_time": endTime,
    "primaryColour": primaryColour,
    "secondaryColour": secondaryColour,
    "schedule_type": scheduleType,
  };
}
