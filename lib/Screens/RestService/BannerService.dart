import 'dart:convert';

import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:http/http.dart' as http;

// List<Vendor> vendorFromJson(String str) =>
//     List<Vendor>.from(json.decode(str).map((x) => Vendor.fromJson(x)));

// String vendorToJson(List<Vendor> data) =>
//     json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// class Vendor {
//   Vendor({
//     this.id,
//     this.queueLength,
//     this.waitTimeEst,
//     this.name,
//     this.rating,
//     this.userFeedbackNo,
//     this.type,
//   });

//   String id;
//   int queueLength;
//   String waitTimeEst;
//   String name;
//   double rating;
//   int userFeedbackNo;
//   bool type;

//   factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
//         id: json["_id"],
//         queueLength: json["queueLength"],
//         waitTimeEst: json["waitTimeEST"],
//         name: json["name"],
//         rating: json["rating"].toDouble(),
//         userFeedbackNo: json["userFeedbackNo"],
//         type: json["type"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "queueLength": queueLength,
//         "waitTimeEST": waitTimeEst,
//         "name": name,
//         "rating": rating,
//         "userFeedbackNo": userFeedbackNo,
//         "type": type,
//       };
// }

// Future<List<BannerList>> getBannerData() async {
//   var response = await Dio().get(
//       "https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/bannerModule");
//   BannerList banerdata = BannerList.fromJson(response.data);
//   print("banerdata:" + banerdata.Items[0].imageName);
//   return response.extra["Items"];
// }

/*

List<BannerList> bannerslistFromJson(String str) =>
    List<BannerList>.from(json.decode(str).map((x) => BannerList.fromJson(x)));

String bannerslisttToJson(List<BannerList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerList {
  final List<BannerImages> Items;
  final int Count;
  final int ScannedCount;

  BannerList(this.Items, this.Count, this.ScannedCount);

  BannerList.fromJson(Map<String, dynamic> json)
      : Items = json["Items"],
        Count = json["Count"],
        ScannedCount = json["ScannedCount"];

  Map<String, dynamic> toJson() =>
      {"Items": Items, "Count": Count, "ScannedCount": ScannedCount};
}

List<BannerImages> bannersFromJson(String str) => List<BannerImages>.from(
    json.decode(str).map((x) => BannerImages.fromJson(x)));

String bannersToJson(List<BannerImages> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BannerImages {
  final String phoneNumber;
  final String imageName;

  BannerImages(this.phoneNumber, this.imageName);

  BannerImages.fromJson(Map<String, dynamic> json)
      : phoneNumber = json["phoneNumber"],
        imageName = json["endpoint"];

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "endpoint": imageName,
      };
}

class BannerService {
  static final String GET_BANNERS_URL =
      'https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/bannerModule';

  static final int httpStatusOK = 200;

  static Future<List<BannerList>> getBanners() async {
    try {
      final response = await http.get(GET_BANNERS_URL);
      if (response.statusCode == httpStatusOK) {
        final List<BannerList> bookMeetingData =
            bannerslistFromJson(response.body);
        return bookMeetingData;
      } else {
        return List<BannerList>();
      }
    } catch (e) {
      return List<BannerList>();
    }
  }
}
*/

// List<BannerList> bannerslistFromJson(String str) =>
//     List<BannerList>.from(json.decode(str).map((x) => BannerList.fromJson(x)));

// class BannerList {
//   final int Count;
//   final int ScannedCount;
//   final List<BannerImage> Items;

//   BannerList({this.Items, this.Count, this.ScannedCount});

//   factory BannerList.fromJson(Map<String, dynamic> parsedJson) {
//     var list = parsedJson['Items'] as List;
//     List<BannerImage> imagesList =
//         list.map((i) => BannerImage.fromJson(i)).toList();
//     return BannerList(
//         Count: parsedJson['Count'],
//         ScannedCount: parsedJson['ScannedCount'],
//         Items: imagesList);
//   }
// }

class BannerImage {
  final String phoneNumber;
  final String imageName;

  BannerImage({this.phoneNumber, this.imageName});

  factory BannerImage.fromJson(Map<String, dynamic> parsedJson) {
    return BannerImage(
        phoneNumber: parsedJson['phoneNumber'],
        imageName: parsedJson['endpoint']);
  }
}

class BannerService {
  static final String GET_BANNERS_URL = '${Config.baseUrl}/bannerModule';

  static final int httpStatusOK = 200;

  static Future<List<BannerImage>> getBanners() async {
    try {
      final response = await http.get(Uri.parse(GET_BANNERS_URL));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;

      List<BannerImage> list =
          rest.map<BannerImage>((json) => BannerImage.fromJson(json)).toList();
      return list;
    } catch (e) {
      return List<BannerImage>();
    }
  }
}
