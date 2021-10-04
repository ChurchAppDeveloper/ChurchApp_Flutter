class AnnouncementResponse {
  bool success;
  String message;
  List<Content> content;

  AnnouncementResponse({this.success, this.message, this.content});

  AnnouncementResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['content'] != null) {
      content = new List<Content>();
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
  String title;
  String description;
  String filename;
  bool status;
  bool readStatus;

  Content(
      {this.id,
        this.title,
        this.description,
        this.filename,
        this.status,
        this.readStatus});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    filename = json['filename'];
    status = json['status'];
    readStatus = json['readStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['filename'] = this.filename;
    data['status'] = this.status;
    data['readStatus'] = this.readStatus;
    return data;
  }
}