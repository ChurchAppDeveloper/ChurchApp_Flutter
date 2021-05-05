import 'dart:async';
import 'dart:io';

import 'package:churchapp/Screens/RestService/ClassifieldService.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;
import 'package:rounded_loading_button/rounded_loading_button.dart';

class CreateClassifield extends StatefulWidget {
  CreateClassifield({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _CreateClassifieldState createState() => _CreateClassifieldState();
}

// class to draw the profile screen
String codeDialog;
String valueText;

class _CreateClassifieldState extends State<CreateClassifield> {
  var countriesKey = GlobalKey<FindDropdownState>();
  PickedFile imageFile = null;
  String name = "";
  String phonenumer = "";
  String businesstype = "";
  TextEditingController _textFieldController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: EasyLoading.init(),
        home: SafeArea(
          child: Scaffold(
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor: const Color(0xffea5d49),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    iconSize: 50.0,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'CreateClassifield',
                        style: TextStyle(
                          fontSize: 35.0,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _settingModalBottomSheet(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
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
                    TextField(
                        decoration: InputDecoration(hintText: 'Enter a Name'),
                        onChanged: (text) {
                          name = text;
                        }),
                    TextField(
                        decoration:
                            InputDecoration(hintText: 'Enter a Phone Number'),
                        keyboardType: TextInputType.number,
                        inputFormatters: [LengthLimitingTextInputFormatter(10)],
                        onChanged: (text) {
                          phonenumer = text;
                        }),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),

                        // dropdown below..
                        child: FindDropdown<BusinessModel>(
                          label: "Business Type",
                          // onFind: (String filter) => getData(filter),
                          onFind: (String filter) =>
                              ClassifieldService().getBusinessType(filter),
                          searchBoxDecoration: InputDecoration(
                            hintText: "Search",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (BusinessModel data) {
                            businesstype = data.name;
                          },
                        )),
                    RoundedLoadingButton(
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)),
                      color: Colors.red,
                      successColor: Colors.red,
                      controller: _btnController,
                      onPressed: onSubmitPressed,
                    )
                  ],
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
            title: Text('Create Business Type'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter business name"),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('SUBMIT'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    ClassifieldService().createNewBusiness(valueText);
                    Navigator.pop(context);
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
        break;

      case "camera": // CAMERA CAPTURE CODE
        imageFile = await ImagePicker()
            .getImage(source: ImageSource.camera, imageQuality: 90);
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
                          Navigator.pop(context),
                        }),
                new ListTile(
                  title: new Text('Camera'),
                  onTap: () => {
                    imageSelector(context, "camera"),
                    Navigator.pop(context)
                  },
                ),
              ],
            ),
          );
        });
  }

  onSubmitPressed() async {
    await EasyLoading.instance
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
    ClassifieldService service = ClassifieldService();
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
    });
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
