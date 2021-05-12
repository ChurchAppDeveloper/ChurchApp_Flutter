class BusinessTypeCreateRequest {
  String businessName;

  BusinessTypeCreateRequest({this.businessName});

  BusinessTypeCreateRequest.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    return data;
  }
}
