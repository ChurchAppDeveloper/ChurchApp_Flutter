class ReadNotificationResponse {
  bool success;
  String message;
  String content;

  ReadNotificationResponse({this.success, this.message, this.content});

  ReadNotificationResponse.fromJson(Map<String, dynamic> json) {
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