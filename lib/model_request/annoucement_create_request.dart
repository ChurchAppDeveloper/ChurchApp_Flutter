class AnnouncementCreateRequest {
  String description;
  String title;
  List<String> urls;

  AnnouncementCreateRequest({this.description, this.title, this.urls});

  AnnouncementCreateRequest.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    title = json['title'];
    urls = json['urls'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['title'] = this.title;
    data['urls'] = this.urls;
    return data;
  }
}