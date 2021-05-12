class AnnouncementCreateRequest {
  String description;
  String title;

  AnnouncementCreateRequest({this.description, this.title});

  AnnouncementCreateRequest.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['title'] = this.title;
    return data;
  }
}