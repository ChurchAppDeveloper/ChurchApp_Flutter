class ClassifiedResponse {
  bool success;
  String message;
  List<Content> content;

  ClassifiedResponse({this.success, this.message, this.content});

  ClassifiedResponse.fromJson(Map<String, dynamic> json) {
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
  int businessTypeId;
  String businessTypeName;
  String businessName;
  String phoneNumber;
  String imagename;
  int businessSubTypeId;
  String businessSubTypeName;

  Content({this.id,this.businessTypeId, this.businessTypeName,this.businessName,this.phoneNumber, this.imagename});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    businessTypeId = json['businessTypeId'];
    businessTypeName = json['businessTypeName'];
    businessName = json['businessName'];
    phoneNumber = json['phoneNumber'];
    imagename = json['imagename'];
    businessSubTypeId=json['businessSubTypeId'];
    businessSubTypeName=json['businessSubTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['businessTypeId'] = this.businessTypeId;
    data['businessTypeName'] = this.businessTypeName;
    data['businessName'] = this.businessName;
    data['phoneNumber'] = this.phoneNumber;
    data['imagename'] = this.imagename;
    data['businessSubTypeName']=this.businessSubTypeName;
    data['businessSubTypeId']=this.businessSubTypeId;

    return data;
  }
}
