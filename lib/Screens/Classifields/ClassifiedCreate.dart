import 'dart:async';
import 'dart:io';

import 'package:churchapp/Screens/RestService/ClassifieldService.dart';
import 'package:churchapp/api/classified_api.dart';
import 'package:churchapp/model_request/business_create_request.dart';
import 'package:churchapp/model_request/classified_create_request.dart';
import 'package:churchapp/model_response/get_business_type_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:dio/dio.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class ClassifiedCreate extends StatefulWidget {
  ClassifiedCreate({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ClassifiedCreateState createState() => _ClassifiedCreateState();
}

// class to draw the profile screen
String codeDialog;
String valueText;

class _ClassifiedCreateState extends State<ClassifiedCreate> {
  var countriesKey = GlobalKey<FindDropdownState>();
  PickedFile imageFile;
  String name = "";
  String phonenumer = "";
  int businesstype = 0;
  TextEditingController _textFieldController = TextEditingController();
  File selectedFile;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor: const Color(0xffea5d49),
                title: Text('Create Classified'),
                leading: IconButton(
                  // iconSize: 50.0,
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                    // do something
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    iconSize: 25.0,
                    icon: Icon(Icons.add_business_rounded),
                    onPressed: () {
                      _displayTextInputDialog(context);
                    },
                  )
                ]),
            body: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: HeaderCurvedContainer(),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                            enableSuggestions: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(30)
                            ],
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              labelText: "Business Name",
                            ),
                            onChanged: (text) {
                              name = text;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextFormField(
                            enableSuggestions: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10)
                            ],
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                            ),
                            onChanged: (text) {
                              phonenumer = text;
                            }),
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),

                          // dropdown below..
                          child: FindDropdown<BusinessModel>(
                            label: "Business Type",
                            showSearchBox: true,
                            labelVisible: true,
                            selectedItem: BusinessModel(name: ""),
                            validate: (BusinessModel item) {
                              if (item.name == "")
                                return "Required field";
                              else
                                return null;
                            },
                            onFind: (String filter) =>
                                getBusinessType(filter),
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            searchBoxDecoration: InputDecoration(
                              labelText: "Search",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (BusinessModel data) {
                              businesstype = data.id;
                            },
                          )),
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
              ],
            ),
          ),
        ));
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Create Business Type",
                textAlign: TextAlign.start,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )),
            content: TextFormField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              enableSuggestions: true,
              inputFormatters: [LengthLimitingTextInputFormatter(20)],
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Business Name",
              ),
              controller: _textFieldController,
            ),
            actions: <Widget>[
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  primary: Colors.red,
                  onSurface: Colors.grey,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0),
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                  onSurface: Colors.grey,
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0),
                ),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    if (_textFieldController.text.toString().isNotEmpty) {
                      Map<String, dynamic> businessForm = {
                        "businessName": valueText,
                      };
                      createBusinessTypeAPI(businessForm);
                    } else {
                      snackBarAlert(error, invalidBusiness,
                          Icon(Icons.error_outline), errorColor, whiteColor);
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  //********************** IMAGE PICKER
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
                    onTap: () =>
                        {imageSelector(context, "gallery"), Get.back()}),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {imageSelector(context, "camera"), Get.back()},
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

    if(name.isNotEmpty && phonenumer.isNotEmpty){
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.custom,
      );
      createClassifiedAPI(
          ClassifiedCreateRequest(
              businessName: name, phoneNumber: phonenumer,businessTypeId:businesstype),
          file: selectedFile)
          .then((value) {
        // _btnController.success();
        // EasyLoading.dismiss();
        // Get.offNamed('/announcementCreate');

      }).catchError((error) {
        debugPrint("Error : $error");
        _btnController.stop();
        EasyLoading.dismiss();
      });
    }else{
      _btnController.stop();
      snackBarAlert(error, invalidClassified, Icon(Icons.error_outline),
          errorColor, whiteColor);
    }

   /* ClassifieldService service = ClassifieldService();
    service.businesstype = businesstype;
    service.contactnumber = phonenumer;
    service.name = name;
    service.uploadfile = File(imageFile.path);
    var random = new math.Random();
    var randomNum = random.nextInt(888).toString();
    String format = imageFile.path.split(".").last;
    print("objectimageFile $imageFile");
    print(imageFile.path);
    service.getMediaUpload("Classiffield1" + randomNum, imageFile.path, format);
    Timer(Duration(seconds: 10), () {
      _btnController.success();
      EasyLoading.dismiss();
      Navigator.of(context).pop();
    });*/
  }

// Future<List<BusinessModel>> getData(filter) async {
//   var response = await Dio().get(
//     "https://325p0kj62c.execute-api.us-east-2.amazonaws.com/churchapi/businessModule",
//     queryParameters: {"filter": filter},
//   );

//   var models = BusinessModel.fromJsonList(response.data);
//   return models;
// }
}

// CustomPainter class to for the header curved-container
class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = const Color(0xffea5d49);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 250.0, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.green[800];
    paint.style = PaintingStyle.fill;

    var path = Path();

    path.moveTo(0, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.875,
        size.width * 0.5, size.height * 0.9167);
    path.quadraticBezierTo(size.width * 0.75, size.height * 0.9584,
        size.width * 1.0, size.height * 0.9167);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
