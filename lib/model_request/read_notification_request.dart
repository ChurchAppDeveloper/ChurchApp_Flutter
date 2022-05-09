import 'dart:developer';

class ReadNotificationRequest {
  int announcementId;
  String deviceId;
  bool status;

  ReadNotificationRequest({this.announcementId, this.deviceId, this.status});
  ReadNotificationRequest.fromJson(Map<String, dynamic> json) {
    announcementId = json['announcementId'];
    deviceId = json['deviceId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['announcementId'] = this.announcementId;
    data['deviceId'] = this.deviceId;
    data['status'] = this.status;
    return data;
  }
}