class AnnouncementResponse {
  bool success;
  String message;
  List<Content> content;

  AnnouncementResponse({this.success, this.message, this.content});

  AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  int id;
  String deviceId;
  int announcementId;
  Announcement announcement;
  bool read;

  Content(
      {this.id,
        this.deviceId,
        this.announcementId,
        this.announcement,
        this.read});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    deviceId = json['deviceId'];
    announcementId = json['announcementId'];
    announcement = json['announcement'] != null
        ? new Announcement.fromJson(json['announcement'])
        : null;
    read = json['read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deviceId'] = this.deviceId;
    data['announcementId'] = this.announcementId;
    if (this.announcement != null) {
      data['announcement'] = this.announcement.toJson();
    }
    data['read'] = this.read;
    return data;
  }
}

class Announcement {
  int id;
  String title;
  String description;
  String filename;
  bool status;
  bool readStatus;
  int createdDate;

  Announcement(
      {this.id,
        this.title,
        this.description,
        this.filename,
        this.status,
        this.readStatus,
        this.createdDate});

  Announcement.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    filename = json['filename'];
    status = json['status'];
    readStatus = json['readStatus'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['filename'] = this.filename;
    data['status'] = this.status;
    data['readStatus'] = this.readStatus;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

