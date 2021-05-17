import 'dart:async';

import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  TextEditingController textEditingController;
  TextEditingController _passwordController;

  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  StreamController<ErrorAnimationType> errorController;

  @override
  void initState() {
    _passwordController=TextEditingController();
    errorController = StreamController<ErrorAnimationType>();
    textEditingController = TextEditingController();
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
          backgroundColor: Color.fromARGB(255, 219, 69, 71),
          resizeToAvoidBottomInset: false,
          body: Stack(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'image/church_colored.svg',
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2.8,
                  )),
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
                      SizedBox(
                        height: screenHeight * .50,
                      ),
                      Text('VERIFICATION',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            'Enter Your Admin Password',
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
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 219, 69, 71),
                                ),
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left:8.0,bottom: 2),
                                child: TextField(
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  inputFormatters: [LengthLimitingTextInputFormatter(16)],
                                ),
                              ),
                            ),
                            /*Container(
                                margin: EdgeInsets.only(
                                  top: screenHeight * 0.020,
                                    left: screenWidth * 0.020,
                                    right: screenWidth * 0.020),
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
                                )),*/
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RoundedLoadingButton(
                                animateOnTap: true,
                                child: Text(next,
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
                            ),
                           /* TextButton(
                              onPressed: () {
                                setState(() {
                                  loginAPI(LoginRequest(
                                      contactNumber: Get.arguments));
                                });
                              },
                              child: Text(
                                resendOTP,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400),
                              ),
                            )*/
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                splashColor: Colors.white,
                onTap: () {
                  Get.back();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ])),
    );
  }

  onSubmitPressed() async {
    debugPrint("Password:${_passwordController.text.toString()}");
    Map<String, dynamic> otpForm = {
      "grant_type": "password",
      "username": Get.arguments,
      "password": _passwordController.text,
      "client_id": "barnabas"
    };
    _btnController.stop();
    verifyOTPAPI(otpForm);
  }
}
