class BannerResponse {
  bool success;
  String message;
  List<String> content;

  BannerResponse({this.success, this.message, this.content});

  BannerResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    content = json['content'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['content'] = this.content;
    return data;
  }
}