class BusinessTypeResponse {
  bool success;
  String message;
  List<Content> content;

  BusinessTypeResponse({this.success, this.message, this.content});

  BusinessTypeResponse.fromJson(Map<String, dynamic> json) {
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
  int businessId;
  String businessName;

  Content({this.businessId,this.businessName});

  Content.fromJson(Map<String, dynamic> json) {
    businessId = json['businessId'];
    businessName = json['businessName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessId'] = this.businessId;
    data['businessName'] = this.businessName;

    return data;
  }
}
