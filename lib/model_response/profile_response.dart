class ProfileResponse {
  bool success;
  String message;
  Content content;

  ProfileResponse({this.success, this.message, this.content});

  ProfileResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    content =
        json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class Content {
  ChurchProfile churchProfile;
  String contactNo;
  String roleName;

  Content({this.churchProfile, this.contactNo, this.roleName});

  Content.fromJson(Map<String, dynamic> json) {
    churchProfile = json['churchProfile'] != null
        ? new ChurchProfile.fromJson(json['churchProfile'])
        : null;
    contactNo = json['contact_no'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.churchProfile != null) {
      data['churchProfile'] = this.churchProfile.toJson();
    }
    data['contact_no'] = this.contactNo;
    data['role_name'] = this.roleName;
    return data;
  }
}

class ChurchProfile {
  int id;
  String contactUs;
  String aboutUs;
  String onlineReading;
  String facebook;
  String school;
  String website;
  String bulletIn;
  String donate;
  String ministers;
  String prayerRequest;
  String youtube;
  String massTimeIntention;

  ChurchProfile(
      {this.id,
      this.contactUs,
      this.aboutUs,
      this.onlineReading,
      this.facebook,
      this.school,
      this.website,
      this.bulletIn,
      this.donate,
      this.ministers,
      this.prayerRequest,
      this.youtube,
      this.massTimeIntention});

  ChurchProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    contactUs = json['contactUs'];
    aboutUs = json['aboutUs'];
    onlineReading = json['onlineReading'];
    facebook = json['facebook'];
    school = json['school'];
    website = json['website'];
    bulletIn = json['bulletIn'];
    donate = json['donate'];
    ministers = json['ministers'];
    prayerRequest = json['prayerRequest'];
    youtube = json['youtube'];
    massTimeIntention = json['massTimeIntention'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['contactUs'] = this.contactUs;
    data['aboutUs'] = this.aboutUs;
    data['onlineReading'] = this.onlineReading;
    data['facebook'] = this.facebook;
    data['school'] = this.school;
    data['website'] = this.website;
    data['bulletIn'] = this.bulletIn;
    data['donate'] = this.donate;
    data['ministers'] = this.ministers;
    data['prayerRequest'] = this.prayerRequest;
    data['youtube'] = this.youtube;
    data['massTimeIntention'] = this.massTimeIntention;
    return data;
  }
}
