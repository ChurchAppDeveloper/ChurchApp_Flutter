import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Singleton {
  Singleton._privateConstructor();

  static Singleton _instance = Singleton._privateConstructor();
  bool isAdmin = false;

  factory Singleton() {
    return _instance;
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _contactEditingController;
  var _dialCode = '';

  @override
  void initState() {
    _contactEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _contactEditingController.dispose();
    super.dispose();
  }

  //build method for UI Representation
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appName,
        home: SafeArea(
          maintainBottomViewPadding: true,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("image/background.png"),
                          fit: BoxFit.fill)),
                ),
                Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.0, bottom: 20.0, top: 30.0),
                      height: 300,
                      alignment: Alignment.topCenter,
                      child: Image.asset("image/churchLogo.png"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // width: 350.0,
                      child: Text(
                          churchAddress,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ],
                ),
                SingleChildScrollView(
                  reverse: true,
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      // padding: const EdgeInsets.all(16.0),
                      // width: double.infinity,
                      color: Colors.transparent,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.7),
                          // Text(
                          //   'LOGIN',
                          //   style: TextStyle(
                          //       fontSize: 28,
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.w700),
                          // ),
                          // SizedBox(
                          //   height: screenHeight * 0.04,
                          // ),
                          // const Text(
                          //   'St. Barnabas Pray For Us!\n\n 3955 Orange Avenue \n Long Beach, CA 90807 \n 562-424-8595',
                          //   textAlign: TextAlign.center,
                          //   style: TextStyle(
                          //     fontSize: 25,
                          //     color: Colors.white,
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: screenHeight * 0.04,
                          // ),
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
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                /* Text('Phone number',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.black87,
                              ),
                            )),*/
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 219, 69, 71),
                                    ),
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  child: Row(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      // CountryPicker(
                                      //   callBackFunction: _callBackFunction,
                                      //   headerText: 'Select Country',
                                      //   headerBackgroundColor:
                                      //       Theme.of(context).primaryColor,
                                      //   headerTextColor: Colors.red,
                                      // ),
                                      // SizedBox(
                                      //   width: screenWidth * 0.1,
                                      // ),

                                      Expanded(
                                        child: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Contact Number',
                                            border: InputBorder.none,
                                            alignLabelWithHint: true,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 13.5),
                                          ),
                                          controller: _contactEditingController,
                                          keyboardType: TextInputType.phone,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(13)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                InkWell(
                                  splashColor: Colors.white,
                                  onTap: () {
                                    loginAPI(LoginRequest(
                                        contactNumber: _contactEditingController
                                            .text
                                            .toString()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(8),
                                    height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 219, 69, 71),
                                      borderRadius: BorderRadius.circular(36),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      'LOGIN',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                // CustomButton(clickOnLogin),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ])),
        ));
  }

//Login click with contact number validation
/*Future<void> clickOnLogin(BuildContext context) async {
    if (_contactEditingController.text.isEmpty) {
      showErrorDialog(context, 'Contact number can\'t be empty.');
    } else {
      // firebaseSetUP();
      // final responseMessage = await Navigator.pushNamed(context, '/otpScreen',
      //     arguments: '$_dialCode${_contactEditingController.text}');
      // if (responseMessage != null) {
      //   showErrorDialog(context, responseMessage as String);
      // }
      var newPhone = _contactEditingController.text.trim();

      var loginservice = LoginService();
      loginservice.getProfileDetails().then((userdata) {
        var contain =
            userdata.where((element) => element.phoneNumber == newPhone);

        if (contain.isNotEmpty) {
          print("No Need to create");
          var isAdmin = (contain.first.userRole != "Contributor");
          Singleton._instance.isAdmin = isAdmin;
        } else {
          print(" Need to create");
          Singleton._instance.isAdmin = false;
          //Call Reistration API
          loginservice.createNewUser(newPhone);
        }
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('phone', newPhone);

      //Compare and send token to server
      // PushTokenService().deleteToken();
      // PushTokenService().sendupdatedToken();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false,
      );

      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  Future<bool> login() async {
    // Simulate a future for response after 2 second.
    return await new Future<bool>.delayed(new Duration(seconds: 2), () => true);
  }
*/
/*  firebaseSetUP() async {
    // Map<String, dynamic> userAttributes = {
    //   'email': 'dineshprasanna1987@gmail.com',
    //   // Note: phone_number requires country code
    //   'phone_number': '+919994490142',
    // };
    // try {
    //   SignUpResult res = await Amplify.Auth.signUp(
    //       username: '+919994490142',
    //       password: 'mysupersecurepassword',
    //       options: CognitoSignUpOptions(userAttributes: userAttributes));
    //   print("login response $res");
    // } on AuthException catch (e) {
    //   print(e.exception);
    // } on AuthError catch (e) {
    //   print(e.exceptionList[0].exception);
    //   if (e.exceptionList[1].exception == "USERNAME_EXISTS") {
    //     signin();
    //   }
    //   // print(e.exceptionList[0].detail);
    //   // print(e.exceptionList[0].exception);
    //   // print("Second");
    //   // print(e.exceptionList[1].detail);
    //   // print(e.exceptionList[1].exception);
    // }
    // signin();
  }*/

//Alert dialogue to show error and response
/*  void showErrorDialog(BuildContext context, String message) {
    // set up the AlertDialog
    final CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const Text('Error'),
      content: Text('\n$message'),
      actions: <Widget>[
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Yes'),
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
  }*/
}
