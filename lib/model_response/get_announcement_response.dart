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
  String title;
  String description;
  List<UserAnouncementImageurls> userAnouncementImageurls;

  Content({this.title, this.description, this.userAnouncementImageurls});

  Content.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    if (json['userAnouncementImageurls'] != null) {
      userAnouncementImageurls = new List<UserAnouncementImageurls>();
      json['userAnouncementImageurls'].forEach((v) {
        userAnouncementImageurls.add(new UserAnouncementImageurls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.userAnouncementImageurls != null) {
      data['userAnouncementImageurls'] =
          this.userAnouncementImageurls.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserAnouncementImageurls {
  String userAnouncementImageurl;

  UserAnouncementImageurls({this.userAnouncementImageurl});

  UserAnouncementImageurls.fromJson(Map<String, dynamic> json) {
    userAnouncementImageurl = json['userAnouncementImageurl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userAnouncementImageurl'] = this.userAnouncementImageurl;
    return data;
  }
}