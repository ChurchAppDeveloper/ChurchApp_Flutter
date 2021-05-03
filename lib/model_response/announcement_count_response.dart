class AnnouncementCountResponse {
  bool success;
  String message;
  int content;

  AnnouncementCountResponse({this.success, this.message, this.content});

  AnnouncementCountResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['content'] = this.content;
    return data;
  }
}