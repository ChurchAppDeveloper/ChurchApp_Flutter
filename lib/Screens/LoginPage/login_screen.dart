import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  String _dialCode = "1";
int toggleSelected = 0;
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
                      height: MediaQuery.of(context).size.height / 2.5,
                      alignment: Alignment.topCenter,
                      child: Image.asset("image/churchLogo.png"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      // width: 350.0,
                      child: Text(churchAddress,
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
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.6),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  screenWidth > 600 ? screenWidth * 0.2 : 16),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16.0)),
                          child: cardAdmin(),
                        )
                      ],
                    ),
                  ),
                ),
              ])),
        ));
  }

  Widget cardAdmin() {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width/2.7,
          cornerRadius: 5.0,
          activeBgColor: Colors.red,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          labels: ['Admin'.toUpperCase(), 'Contributor'.toUpperCase()],
          icons: [Icons.admin_panel_settings_outlined, Icons.people_alt_outlined],
          onToggle: (index) {
            print('switched to: $index');
            toggleSelected = index;
          },
        ),
        SizedBox(
          height: 10,
        ),
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
          child: Row(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              CountryListPick(
                  appBar: AppBar(
                    backgroundColor: Colors.red,
                    title: Text('Pick your country'),
                  ),
                  pickerBuilder: (context, CountryCode countryCode) {
                    return Row(
                      children: [
                        Image.asset(
                          countryCode.flagUri,
                          package: 'country_list_pick',
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(countryCode.code),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, right: 8.0, bottom: 8.0),
                          child: Text(countryCode.dialCode),
                        ),
                      ],
                    );
                  },
                  // To disable option set to false
                  theme: CountryTheme(
                    isShowFlag: true,
                    isShowCode: true,
                    isShowTitle: false,
                    isDownIcon: true,
                    alphabetSelectedBackgroundColor: Colors.red,
                    showEnglishName: true,
                  ),
                  // Set default value
                  initialSelection: 'US',
                  // or
                  // initialSelection: 'US'
                  onChanged: (CountryCode code) {
                    print(code.name);
                    print(code.code);
                    print(code.dialCode);
                    print(code.flagUri);

                    _dialCode = code.dialCode.substring(1);
                  },
                  // Whether to allow the widget to set a custom UI overlay
                  useUiOverlay: true,
                  // Whether the country list should be wrapped in a SafeArea
                  useSafeArea: true),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Contact Number',
                    border: InputBorder.none,
                    alignLabelWithHint: true,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  controller: _contactEditingController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [LengthLimitingTextInputFormatter(13)],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          splashColor: Colors.white,
          onTap: () {
            if (_contactEditingController.text.isNotEmpty) {
              debugPrint(
                  "Dial Code $_dialCode${_contactEditingController.text}");
              loginAPI(LoginRequest(
                  contactNumber:
                      "$_dialCode${_contactEditingController.text.toString()}", role: toggleSelected==0?"Admin":"Contributor"));
            } else {
              snackBarAlert(error, invalidNumber, Icon(Icons.error_outline),
                  errorColor, whiteColor);
            }
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
              login,
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ],
    );
  }
}
