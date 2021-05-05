import 'dart:async';
import 'dart:io';
import 'package:churchapp/api/announcement_api.dart';
import 'package:churchapp/model_request/annoucement_create_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
  PickedFile imageFile;

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Stack(
                      alignment: Alignment.topCenter,
                  children: [
                    ClipPath(
                        clipper: WaveClipper(),
                        child: Container(
                            color: const Color(0xffea5d49),
                            height:
                                MediaQuery.of(context).size.height / 3.2)),
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.0,
                        height: MediaQuery.of(context).size.width / 2.0,
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: imageFile == null
                                ? AssetImage('image/imageplaceholder.png')
                                : FileImage(File(imageFile.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      enableSuggestions: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration:
                          InputDecoration(labelText: 'Announcement Title'),
                      onChanged: (text) {
                        announceTitle = text;
                      }),
                ),
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
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        labelText: "Announcement Description",
                      ),
                    ),
                  ),
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
  Future imageSelector(BuildContext context, String pickerType) async {
    switch (pickerType) {
      case "gallery":

      /// GALLERY IMAGE PICKER
        imageFile = (await ImagePicker()
            .getImage(source: ImageSource.gallery, imageQuality: 90));
        selectedFile = File(imageFile.path);
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = await ImagePicker()
            .getImage(source: ImageSource.camera, imageQuality: 90);
         selectedFile = File(imageFile.path);
        break;
    }

    if (imageFile != null) {
      print("You selected  image : " + imageFile.path);
      setState(() {
        debugPrint("SELECTED IMAGE PICK   $imageFile");
      });
    } else {
      print("You have not taken image");
    }
  }

  // Image picker
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    title: new Text('Gallery'),
                    onTap: () => {
                      imageSelector(context, "gallery"),
                      Get.back()
                    }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Get.back()
                  },
                ),
              ],
            ),
          );
        });
  }
  onSubmitPressed() async {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
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
    // Map<String, dynamic> otpForm = {
    //   "grant_type": "password",
    //   "username": Get.arguments,
    //   "password": smsOTP,
    //   "client_id": "barnabas"
    // };
    createAnnouncementAPI(
            AnnouncementCreateRequest(
                title: announceTitle, description: announcedesc),
            file: selectedFile)
        .then((value) {
        _btnController.success();
        EasyLoading.dismiss();
        Get.offNamed('/announcementCreate');

    }).catchError((error) {
      debugPrint("Error : $error");
      _btnController.error();
      EasyLoading.dismiss();
    });
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

//Custom Clipper class with Path
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
