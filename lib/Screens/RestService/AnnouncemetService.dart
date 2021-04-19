import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementService {
  String announcettitle = "";
  String announcedesc = "";
  File uploadfile;

  static final String FetchAnnouncement =
      '${Config.baseUrl}/announcementModule';

  static final String CreateAnnouncement =
      '${Config.baseUrl}/announcementModule';

  static final String UploadDoc = '${Config.baseUrl}/uploaderModule?';

  static final String MediaURL =
      "https://assets-barnabas.s3.us-east-2.amazonaws.com/";

  static final int httpStatusOK = 200;

  Future<List<AnnouncementListItem>> getAnnouncementModel() async {
    try {
      final response = await http.get(Uri.parse(FetchAnnouncement));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;
      List<AnnouncementListItem> list = rest
          .map<AnnouncementListItem>(
              (json) => AnnouncementListItem.fromJson(json))
          .toList();

      print("models $list");
      return list;
    } catch (e) {
      print("error $e");
      return List<AnnouncementListItem>();
    }
  }

  getMediaUpload(filename, String filepath, String format) async {
    String mimeType = mime(filepath);
    print('mimeType $mimeType');
    String geturl = UploadDoc +
        "fname=" +
        filename +
        "." +
        format +
        "&extension=" +
        mimeType;
    try {
      final response = await http.get(Uri.parse(geturl));
      var data = json.decode(response.body);
      String uploadurl = data["uploadURL"] as String;
      String filename = data["photoFilename"] as String;
      String mediaurl = MediaURL + filename;
      print("mediaurl $mediaurl");
      uploadDataFileHttp(uploadurl, format, filepath);
      if (mediaurl != null) {
        createNewAnnouncement(mediaurl, announcedesc, announcettitle);
      }
    } catch (e) {
      print("error $e");
    }
  }

  uploadDataFileHttp(String uploadurl, String format, String filepath) async {
    final String url = uploadurl;
    String mimeType = mime(filepath);
    http.Response response = await http.put(Uri.parse(url),
        headers: {"Content-Type": mimeType},
        body: uploadfile.readAsBytesSync());
    print(response.body.toString());
  }

  createNewAnnouncement(String mediaURL, String desc, String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phonenumer = prefs.getString('phone');
    var random = new math.Random();
    var randomNum = random.nextInt(888);
    print(randomNum);
    final String url = CreateAnnouncement;
    Map data = {
      'announcementId': randomNum.toString(),
      'phoneNumber': phonenumer,
      'mediaUrl': mediaURL,
      'content': desc,
      'title': title,
      'readStatus': true
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }
}

class AnnouncementListItem {
  final String phoneNumber;
  final String content;
  final String read;
  final String announcementId;
  final String mediaUrl;
  final String title;
  AnnouncementListItem(
      {this.phoneNumber,
      this.content,
      this.read,
      this.announcementId,
      this.mediaUrl,
      this.title});

  factory AnnouncementListItem.fromJson(Map<String, dynamic> parsedJson) {
    return AnnouncementListItem(
        phoneNumber: parsedJson['phoneNumber'],
        content: parsedJson['content'],
        read: parsedJson['read'],
        announcementId: parsedJson['announcementId'],
        mediaUrl: parsedJson['mediaUrl'],
        title: parsedJson['title']);
  }
}
