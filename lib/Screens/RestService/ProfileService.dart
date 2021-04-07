import 'dart:convert';
import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static final String GET_Profile_URL = '${Config.baseUrl}/profileModule';

  static final int httpStatusOK = 200;

  getProfileDetails() async {
    try {
      final response = await http.get(GET_Profile_URL);
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<ProfileData> list =
          rest.map<ProfileData>((json) => ProfileData.fromJson(json)).toList();
      ProfileData dataval = list.first;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phoneNumber', dataval.phoneNumber);
      prefs.setString('aboutUs', dataval.aboutUs);
      prefs.setString('ministersUrl', dataval.ministersUrl);
      prefs.setString('donateUrl', dataval.donateUrl);
      prefs.setString('websiteUrl', dataval.websiteUrl);
      prefs.setString('youtubeUrl', dataval.youtubeUrl);
      prefs.setString('facebookUrl', dataval.facebookUrl);
      prefs.setString('schoolUrl', dataval.schoolUrl);
      prefs.setString('bulletinUrl', dataval.bulletinUrl);
      prefs.setString('onlieReadingUrl', dataval.onlieReadingUrl);
      prefs.setString('prayerRequestUtl', dataval.prayerRequestUtl);
      prefs.setString('masstimingintention', dataval.masstimingintention);

      return list;
    } catch (e) {
      return List<ProfileData>();
    }
  }
}

class ProfileData {
  final String phoneNumber;
  final String aboutUs;
  final String ministersUrl;
  final String donateUrl;
  final String websiteUrl;
  final String youtubeUrl;
  final String facebookUrl;
  final String schoolUrl;
  final String bulletinUrl;
  final String onlieReadingUrl;
  final String prayerRequestUtl;
  final String profileId;
  final String masstimingintention;

  ProfileData(
      {this.phoneNumber,
      this.aboutUs,
      this.ministersUrl,
      this.donateUrl,
      this.websiteUrl,
      this.youtubeUrl,
      this.facebookUrl,
      this.schoolUrl,
      this.bulletinUrl,
      this.onlieReadingUrl,
      this.prayerRequestUtl,
      this.profileId,
      this.masstimingintention});

  factory ProfileData.fromJson(Map<String, dynamic> parsedJson) {
    return ProfileData(
        phoneNumber: parsedJson['phoneNumber'],
        aboutUs: parsedJson['aboutUs'],
        ministersUrl: parsedJson['ministersUrl'],
        donateUrl: parsedJson['donateUrl'],
        websiteUrl: parsedJson['websiteUrl'],
        youtubeUrl: parsedJson['youtubeUrl'],
        facebookUrl: parsedJson['facebookUrl'],
        schoolUrl: parsedJson['schoolUrl'],
        bulletinUrl: parsedJson['bulletinUrl'],
        onlieReadingUrl: parsedJson['onlieReadingUrl'],
        prayerRequestUtl: parsedJson['prayerRequestUtl'],
        profileId: parsedJson['profileId'],
        masstimingintention: parsedJson['MassTimingIntention']);
  }
}
