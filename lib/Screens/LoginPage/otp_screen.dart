import 'dart:async';

import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
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
    textEditingController.clear();
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
                                )

                                /*    PinEntryTextField(
                            fields: 5,
                            onSubmit: (text) {
                              smsOTP = text as String;
                            },
                          ),*/
                                ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            GestureDetector(
                              onTap: () {
                                verifyOtp();
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
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
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

  //Method for generate otp from firebase
  Future<void> generateOtp(String contact) async {
    // final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
    //   verificationId = verId;
    // };
    // try {
    //   await _auth.verifyPhoneNumber(
    //       phoneNumber: contact,
    //       codeAutoRetrievalTimeout: (String verId) {
    //         verificationId = verId;
    //       },
    //       codeSent: smsOTPSent,
    //       timeout: const Duration(seconds: 60),
    //       verificationCompleted: (AuthCredential phoneAuthCredential) {},
    //       verificationFailed: (AuthException exception) {
    //         // Navigator.pop(context, exception.message);
    //       });
    // } catch (e) {
    //   handleError(e as PlatformException);
    //   // Navigator.pop(context, (e as PlatformException).message);
    // }
  }

  //Method for verify otp entered by user
  Future<void> verifyOtp() async {
    print("verify OTP");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', widget._contact);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));

    // if (smsOTP == null || smsOTP == '') {
    //   showAlertDialog(context, 'please enter 6 digit otp');
    //   return;
    // }
    // try {
    //   final AuthCredential credential = PhoneAuthProvider.getCredential(
    //     verificationId: verificationId,
    //     smsCode: smsOTP,
    //   );
    //   final AuthResult user = await _auth.signInWithCredential(credential);
    //   final FirebaseUser currentUser = await _auth.currentUser();
    //   assert(user.user.uid == currentUser.uid);
    //   Navigator.pushReplacementNamed(context, '/homeScreen');
    // } catch (e) {
    //   handleError(e as PlatformException);
    // }
  }

  //Method for handle the errors
  void handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        showAlertDialog(context, 'Invalid Code');
        break;
      default:
        showAlertDialog(context, error.message);
        break;
    }
  }

  //Basic alert dialogue for alert errors and confirmations
  void showAlertDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
