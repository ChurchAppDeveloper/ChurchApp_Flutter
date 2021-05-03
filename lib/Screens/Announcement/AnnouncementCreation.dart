import 'dart:async';
import 'dart:io';
import 'package:churchapp/Screens/RestService/AnnouncemetService.dart';
import 'package:churchapp/api/announcement_api.dart';
import 'package:churchapp/model_request/annoucement_create_request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:math' as math;

class AnnouncementCreation extends StatefulWidget {
  final bool isShowAppbar;

  const AnnouncementCreation({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _AnnouncementCreationState createState() => _AnnouncementCreationState();
}

class _AnnouncementCreationState extends State<AnnouncementCreation> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  String announceTitle = "";
  String announcedesc = "";
  File selectedFile;
  final maxLines = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 219, 69, 71),
              title: Text("Announcement Creation",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  )),
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                },
              )),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                    child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                          clipper: WaveClipper(),
                          child: Container(
                              color: Colors.deepOrangeAccent,
                              height:
                                  MediaQuery.of(context).size.height / 3.2)),
                    ),
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                          padding: EdgeInsets.only(bottom: 50),
                          color: Colors.red,
                          height: MediaQuery.of(context).size.height / 3.4,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('image/bg1.jpg'),
                          )),
                    )
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      enableSuggestions: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      keyboardType: TextInputType.text,
                      decoration:
                          InputDecoration(labelText: 'Announcement Title'),
                      onChanged: (text) {
                        announceTitle = text;
                      }),
                ),
                // TextField(
                //     decoration: InputDecoration(
                //         hintText: 'Enter a Announcement Description'),
                //     maxLines: null,
                //     onChanged: (text) {
                //       announcedesc = text;
                //     }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // margin: EdgeInsets.all(12),
                    height: maxLines * 18.0,
                    child: TextFormField(
                      maxLines: maxLines,
                      enableSuggestions: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: "Announcement Description",
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  // color: Colors.red,
                  // textColor: Colors.white,
                  child: Text("Browse Attachments",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )),
                  onPressed: () async {
                    FilePickerResult result = await FilePicker.platform
                        .pickFiles(type: FileType.custom, allowedExtensions: [
                      'pdf',
                      'docx',
                      'doc',
                      'xlsx',
                      'xls',
                      'pptx',
                      'ppt',
                      'txt',
                      'jpg',
                      'jpeg',
                      'png',
                      'm3u',
                      'm4a',
                      'm4b',
                      'm4p',
                      'mp2',
                      'mp3',
                      'mpga',
                      'ogg',
                      'rmvb',
                      'wav',
                      'wma',
                      'wmv',
                      '3gp',
                      'asf',
                      'avi',
                      'm4u',
                      'm4v',
                      'mov',
                      'mp4',
                      'mpe',
                      'mpeg',
                      'mpg',
                      'mpg4'
                    ]);

                    if (result != null) {
                      setState(() {
                        selectedFile = File(result.files.single.path);
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                ),
                selectedFile != null
                    ? (Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RoundedLoadingButton(
                          animateOnTap: true,
                          child: Text('Submit',
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              )),
                          color: Colors.red,
                          successColor: Colors.red,
                          controller: _btnController,
                          onPressed: onSubmitPressed,
                        ),
                      ))
                    : Container()
              ],
            ),
          ),
        ));
  }

  onSubmitPressed() async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.red
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5)
      ..userInteractions = false;
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.custom,
    );
    String format = selectedFile.path.split(".").last;
    // Map<String, dynamic> otpForm = {
    //   "grant_type": "password",
    //   "username": Get.arguments,
    //   "password": smsOTP,
    //   "client_id": "barnabas"
    // };
    // createAnnouncementAPI(AnnouncementCreateRequest(title: announceTitle, description: announcedesc, urls: );
   /* var random = new math.Random();
    var randomNum = random.nextInt(888).toString();
    AnnouncementService anservice = AnnouncementService();
    anservice.announcettitle = announceTitle;
    anservice.announcedesc = announcedesc;
    anservice.uploadfile = selectedFile;

    anservice.getMediaUpload(
        "Announcement" + randomNum, selectedFile.path, format);*/
    /*Timer(Duration(seconds: 6), () {
      _btnController.success();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
    });*/
  }
}

//Costom CLipper class with Path
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(
        0, size.height); //start path with this if you are making at bottom

    var firstStart = Offset(size.width / 5, size.height);
    //fist point of quadratic bezier curve
    var firstEnd = Offset(size.width / 2.25, size.height - 50.0);
    //second point of quadratic bezier curve
    path.quadraticBezierTo(
        firstStart.dx, firstStart.dy, firstEnd.dx, firstEnd.dy);

    var secondStart =
        Offset(size.width - (size.width / 3.24), size.height - 105);
    //third point of quadratic bezier curve
    var secondEnd = Offset(size.width, size.height - 10);
    //fourth point of quadratic bezier curve
    path.quadraticBezierTo(
        secondStart.dx, secondStart.dy, secondEnd.dx, secondEnd.dy);

    path.lineTo(
        size.width, 0); //end with this path if you are making wave at bottom
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false; //if new instance have different instance than old instance
    //then you must return true;
  }
}
