import 'dart:async';
import 'dart:io';
import 'package:churchapp/Screens/RestService/AnnouncemetService.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:math' as math;

class AnnouncemetCreation extends StatefulWidget {
  final bool isShowAppbar;

  const AnnouncemetCreation({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _AnnouncemetCreationState createState() => _AnnouncemetCreationState();
}

class _AnnouncemetCreationState extends State<AnnouncemetCreation> {
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  String announceTitle = "";
  String announcedesc = "";
  File selectedFile;
  final maxLines = 5;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 219, 69, 71),
                title: Text('Announcement Creation'),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )),
            body: Column(
              children: [
                Container(
                    child: Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: ClipPath(
                          clipper: WaveClipper(),
                          child: Container(
                              color: Colors.deepOrangeAccent, height: 200)),
                    ),
                    ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                          padding: EdgeInsets.only(bottom: 50),
                          color: Colors.red,
                          height: 180,
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('image/bg1.jpg'),
                          )),
                    )
                  ],
                )),
                TextField(
                    decoration:
                        InputDecoration(hintText: 'Enter a Announcement Title'),
                    onChanged: (text) {
                      announceTitle = text;
                    }),
                // TextField(
                //     decoration: InputDecoration(
                //         hintText: 'Enter a Announcement Description'),
                //     maxLines: null,
                //     onChanged: (text) {
                //       announcedesc = text;
                //     }),
                Container(
                  // margin: EdgeInsets.all(12),
                  height: maxLines * 24.0,
                  child: TextField(
                    maxLines: maxLines,
                    decoration: InputDecoration(
                      hintText: "Enter a Announcement Description",
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ),
                RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text('Browse Documents'),
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
                      selectedFile = File(result.files.single.path);
                    } else {
                      // User canceled the picker
                    }
                  },
                ),
              ],
            ),
            floatingActionButton: RoundedLoadingButton(
              child: Text('Submit', style: TextStyle(color: Colors.white)),
              color: Colors.red,
              successColor: Colors.red,
              controller: _btnController,
              onPressed: onSubmitPressed,
            )));
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
    var random = new math.Random();
    var randomNum = random.nextInt(888).toString();
    AnnouncementService anservice = AnnouncementService();
    anservice.announcettitle = announceTitle;
    anservice.announcedesc = announcedesc;
    anservice.uploadfile = selectedFile;

    anservice.getMediaUpload(
        "Announcement" + randomNum, selectedFile.path, format);
    Timer(Duration(seconds: 6), () {
      _btnController.success();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
    });
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
