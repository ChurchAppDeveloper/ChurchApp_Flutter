import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:churchapp/Screens/RestService/app_config.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as fileUtil;
import 'package:http_parser/http_parser.dart';
import 'dart:math' as math;

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class ClassifieldService {
  static final String CreateBusiness = '${Config.baseUrl}/businessModule';

  static final String FetchBusiness = '${Config.baseUrl}/businessModule';

  static final String FetchClassifields = '${Config.baseUrl}/classifieldModule';

  static final String UploadDoc = "${Config.baseUrl}/uploaderModule?";

  static final String MediaURL =
      "https://assets-barnabas.s3.us-east-2.amazonaws.com/";

  static final String CreateClassifield = "${Config.baseUrl}/classifieldModule";

  static final int httpStatusOK = 200;

  String name = "";
  String contactnumber = "";
  String businesstype = "";
  File uploadfile;

  createNewBusiness(String businessname) async {
    var random = new math.Random();
    var randomNum = random.nextInt(888);
    print(randomNum);
    final String url = CreateBusiness;
    Map data = {
      'businessId': randomNum.toString(),
      'businessType': businessname
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }

  Future<List<BusinessModel>> getBusinessModel(filter) async {
    var response = await Dio().get(FetchBusiness);
    var models = BusinessModel.fromJsonList(response.data["Items"]).toList();
    print("models $models");
    return models;
  }

  Future<List<BusinessModel>> getBusinessType(filter) async {
    try {
      final response = await http.get(Uri.parse(FetchBusiness));
      var data = json.decode(response.body);
      print("models $data");
      var rest = data["Items"] as List;

      List<BusinessModel> list = rest
          .map<BusinessModel>((json) => BusinessModel.fromJson(json))
          .toList();
      print("models $list");
      return list;
    } catch (e) {
      return List<BusinessModel>();
    }
  }

  Future<List<Classifield>> getClassifieldList() async {
    try {
      final response = await http.get(Uri.parse(FetchClassifields));
      var data = json.decode(response.body);
      var rest = data["Items"] as List;

      List<Classifield> list =
          rest.map<Classifield>((json) => Classifield.fromJson(json)).toList();
      print("models $list");
      return list;
    } catch (e) {
      return List<Classifield>();
    }
  }

  getMediaUpload(filename, String filepath, String format) async {
    String geturl = UploadDoc +
        "fname=" +
        filename +
        "." +
        format +
        "&extension=image/" +
        format;
    // String geturl =
    //     UploadDoc + "fname=" + filename + "&extension=image/" + format;
    print("geturl  $geturl");
    try {
      final response = await http.get(Uri.parse(geturl));
      var data = json.decode(response.body);
      print("data $data");
      String uploadurl = data["uploadURL"] as String;
      String photoFilename = data["photoFilename"] as String;
      _asyncFileUpload(photoFilename, filepath, uploadurl, format);
    } catch (e) {
      print("error $e");
    }
  }

  _asyncFileUpload(
      filename, String filepath, String uploadurl, String format) async {
    // String imagefileename = uploadfile.path.split("/").last;
    // var postUri = Uri.parse(uploadurl);

    // var uploadURI = Uri.parse(filepath);

    // var request = new http.MultipartRequest("PUT", postUri);

    // var pic = new http.MultipartFile.fromBytes(
    //     filename, await File.fromUri(uploadURI).readAsBytes(),
    //     contentType: new MediaType('image', format));

    // request.files.add(pic);

    // request.send().then((response) {
    //   if (response.statusCode == 200) {
    //     print("Uploaded!");
    //     String mediaurl = MediaURL + filename; //+ "." + format;
    //     print("mediaurl $mediaurl");
    //     if (mediaurl != null) {
    //       createNewClassifield(mediaurl, name, contactnumber, businesstype);
    //     }
    //   }
    // });

    // var request = http.MultipartRequest("PUT", Uri.parse(uploadurl));
    // var pic = await http.MultipartFile.fromPath(filename, filepath);
    // print("pic $pic");
    // request.files.add(pic);
    // await request.send().then((response) async {
    //   String mediaurl = MediaURL + filename; //+ "." + format;
    //   print("mediaurl $mediaurl");
    //   if (mediaurl != null) {
    //     createNewClassifield(mediaurl, name, contactnumber, businesstype);
    //   }
    // }).catchError((e) {
    //   print(e);
    // });

    // _upload(filename, uploadfile, uploadurl, format);
    uploadDataFileHttp(uploadurl, format);
    // _uploadFileAsFormData(uploadurl, filename);

    // postFileClient(filename, uploadfile, uploadurl, format);

    String mediaurl = MediaURL + filename;
    print("mediaurl $mediaurl");
    if (mediaurl != null) {
      createNewClassifield(mediaurl, name, contactnumber, businesstype);
    }
  }

  Future _uploadFileAsFormData(String uploadurl, String filename) async {
    String apiUrl = uploadurl;
    final length = await uploadfile.length();
    final request = new http.MultipartRequest('PUT', Uri.parse(apiUrl))
      ..files
          .add(new http.MultipartFile(filename, uploadfile.openRead(), length));
    http.Response response =
        await http.Response.fromStream(await request.send());
    print("Result: ${response.body}");
  }

  void _upload(
      String filename, File file, String uploadurl, String format) async {
    Response responseGoogleStorage = await Dio().put(
      uploadurl,
      data: File(file.path).readAsBytesSync(),
      options: Options(
        headers: {
          'Content-Type': "image/" + format,
          'Accept': "*/*",
          'Content-Length': File(file.path).lengthSync().toString(),
          'Connection': 'keep-alive',
        },
      ),
    );
    print("responseGoogleStorage $responseGoogleStorage");
  }

  postFileClient(
      String filename, File file, String uploadurl, String format) async {
    var url = uploadurl;
    var client = new http.MultipartRequest("put", Uri.parse(url));
    http.MultipartFile.fromPath('file', file.path,
            filename: filename, contentType: MediaType('image', format))
        .then((http.MultipartFile file) {
      client.files.add(file);
      client.send().then((http.StreamedResponse response) {
        if (response.statusCode == 200) {
          print("uploadded");
          response.stream.transform(utf8.decoder).join().then((String string) {
            print(string);
          });
        } else {
          print("not uploaded");
          response.stream.transform(utf8.decoder).join().then((String string) {
            print(string);
          });
        }
      }).catchError((error) {
        print("error");
        print(error);
      });
    });
  }

  uploadDataFileHttp(String uploadurl, String format) async {
    final String url = uploadurl;
    // Map data = {'businessType': businesstype};
    // String body = json.encode(uploadfile.readAsBytesSync());
    http.Response response = await http.put(Uri.parse(url),
        headers: {"Content-Type": "image/" + format},
        body: uploadfile.readAsBytesSync());
    print(response.body.toString());
  }

  createNewClassifield(String mediaURL, String name, String contactnumber,
      String businesstype) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String phonenumer = prefs.getString('phone');
    var random = new math.Random();
    var randomNum = random.nextInt(888);
    print(randomNum);
    final String url = CreateClassifield;
    Map data = {
      'classifieldId': randomNum.toString(),
      'phoneNumber': contactnumber.toString(),
      'endpoint': mediaURL,
      'name': name,
      'businessType': businesstype
    };
    String body = json.encode(data);
    http.Response response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    print(response.body.toString());
  }
}

class BusinessModel {
  final int id;
  final String name;

  BusinessModel({
    this.id,
    this.name,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return BusinessModel(
      id: json["businessId"],
      name: json["businessType"],
    );
  }

  static List<BusinessModel> fromJsonList(List list) {
    if (list == null) return null;
    return list.map((item) => BusinessModel.fromJson(item)).toList();
  }

  @override
  String toString() => name;

  @override
  operator ==(o) => o is BusinessModel && o.id == id;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}

class Classifield {
  final String name;
  final int phonenumber;
  final String businesstype;
  final String imageName;
  Classifield({this.name, this.phonenumber, this.businesstype, this.imageName});

  factory Classifield.fromJson(Map<String, dynamic> parsedJson) {
    return Classifield(
        name: parsedJson['userName'],
        phonenumber: parsedJson['phoneNumber'],
        businesstype: parsedJson['businessType'],
        imageName: parsedJson['endpoint']);
  }
}
