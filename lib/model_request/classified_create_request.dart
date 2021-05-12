class ClassifiedCreateRequest {
  String businessName;
  String phoneNumber;
  int businessTypeId;

  ClassifiedCreateRequest({this.businessName, this.phoneNumber, this.businessTypeId});

  ClassifiedCreateRequest.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    phoneNumber = json['phoneNumber'];
    businessTypeId = json['businessTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = this.businessName;
    data['phoneNumber'] = this.phoneNumber;
    data['businessTypeId'] = this.businessTypeId;
    return data;
  }
}