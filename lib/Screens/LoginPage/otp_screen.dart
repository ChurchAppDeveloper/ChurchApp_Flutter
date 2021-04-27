import 'dart:async';

import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/model_request/otp_request.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  bool _isInit = true;
  var _contact = '';

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer _timer;
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  //this is method is used to initialize data

  /* @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load data only once after screen load
    if (widget._isInit) {
      widget._contact =
          '${ModalRoute.of(context).settings.arguments as String}';
      generateOtp(widget._contact);
      widget._isInit = false;
    }
  }*/

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();

    super.initState();
  }

  //dispose controllers
  @override
  void dispose() {
    errorController.close();
    textEditingController.dispose();
    super.dispose();
  }

  //build method for UI
  @override
  Widget build(BuildContext context) {
    //Getting screen height width
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("image/Loginbg.png"),
                      fit: BoxFit.fill)),
            ),
            SingleChildScrollView(
              reverse: true,
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          child: SizedBox(
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          splashColor: Colors.white,
                          onTap: () {
                            Get.back();
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .50,
                      ),
                      Text('VERIFICATION',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            'Enter the 5 digit numbers that was sent to ${Get.arguments}',
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                screenWidth > 600 ? screenWidth * 0.2 : 16),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            // ignore: prefer_const_literals_to_create_immutables
                            boxShadow: [
                              const BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0.0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(16.0)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.only(
                                    left: screenWidth * 0.025,
                                    right: screenWidth * 0.025),
                                child: PinCodeTextField(
                                  length: 5,
                                  obscureText: false,
                                  animationType: AnimationType.fade,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(5),
                                    fieldHeight: 50,
                                    inactiveFillColor: Colors.white,
                                    selectedFillColor: Colors.white,
                                    fieldWidth: 40,
                                    activeFillColor: Colors.white,
                                  ),
                                  animationDuration:
                                      Duration(milliseconds: 300),
                                  enableActiveFill: true,
                                  keyboardType: TextInputType.number,
                                  autoDismissKeyboard: true,
                                  useHapticFeedback: true,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(5)
                                  ],
                                  errorAnimationController: errorController,
                                  controller: textEditingController,
                                  onCompleted: (v) {
                                    print("Completed");
                                  },
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      smsOTP = value;
                                    });
                                  },
                                  beforeTextPaste: (text) {
                                    print("Allowing to paste $text");
                                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                                    return true;
                                  },
                                  appContext: context,
                                )),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            InkWell(
                              splashColor: Colors.white,
                              onTap: () {
                                Map<String, dynamic> otpForm = {
                                  "grant_type": "password",
                                  "username": Get.arguments,
                                  "password": smsOTP,
                                  "client_id": "barnabas"
                                };
                                verifyOTPAPI(otpForm);
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8),
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 219, 69, 71),
                                  borderRadius: BorderRadius.circular(36),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  verify,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
