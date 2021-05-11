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
  Content content;

  factory MassResponse.fromJson(Map<String, dynamic> json) => MassResponse(
    success: json["success"],
    message: json["message"],
    content: Content.fromJson(json["content"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "content": content.toJson(),
  };
}

class Content {
  Content({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  List<Monday> monday;
  List<dynamic> tuesday;
  List<dynamic> wednesday;
  List<dynamic> thursday;
  List<dynamic> friday;
  List<dynamic> saturday;
  List<dynamic> sunday;

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    monday: List<Monday>.from(json["monday"].map((x) => Monday.fromJson(x))),
    tuesday: List<dynamic>.from(json["tuesday"].map((x) => x)),
    wednesday: List<dynamic>.from(json["wednesday"].map((x) => x)),
    thursday: List<dynamic>.from(json["thursday"].map((x) => x)),
    friday: List<dynamic>.from(json["friday"].map((x) => x)),
    saturday: List<dynamic>.from(json["saturday"].map((x) => x)),
    sunday: List<dynamic>.from(json["sunday"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "monday": List<dynamic>.from(monday.map((x) => x.toJson())),
    "tuesday": List<dynamic>.from(tuesday.map((x) => x)),
    "wednesday": List<dynamic>.from(wednesday.map((x) => x)),
    "thursday": List<dynamic>.from(thursday.map((x) => x)),
    "friday": List<dynamic>.from(friday.map((x) => x)),
    "saturday": List<dynamic>.from(saturday.map((x) => x)),
    "sunday": List<dynamic>.from(sunday.map((x) => x)),
  };
}

class Monday {
  Monday({
    this.id,
    this.startTime,
    this.endTime,
    this.notification,
    this.day,
  });

  int id;
  String startTime;
  String endTime;
  bool notification;
  String day;

  factory Monday.fromJson(Map<String, dynamic> json) => Monday(
    id: json["id"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    notification: json["notification"],
    day: json["day"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "start_time": startTime,
    "end_time": endTime,
    "notification": notification,
    "day": day,
  };
}
