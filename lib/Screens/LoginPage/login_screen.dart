import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/model_request/login_request.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:country_pickers/country_pickers.dart';
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
  String _dialCode = "1";

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

    Widget _buildDropdownItem(Country country) => Container(
          child: Row(
            children: <Widget>[
              CountryPickerUtils.getDefaultFlagImage(country),
              SizedBox(
                width: 8.0,
              ),
              Text("+${country.phoneCode}(${country.isoCode})"),
            ],
          ),
        );

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
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.7),
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
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
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
                                      CountryPickerDropdown(
                                        initialValue: 'US',

                                        itemBuilder: _buildDropdownItem,
                                        // itemFilter: (c) =>
                                        //     ['AR', 'DE', 'GB', 'CN'].contains(
                                        //         c.isoCode),
                                        // priorityList: [
                                        //   CountryPickerUtils
                                        //       .getCountryByIsoCode('GB'),
                                        //   CountryPickerUtils
                                        //       .getCountryByIsoCode('CN'),
                                        // ],
                                        sortComparator:
                                            (Country a, Country b) =>
                                                a.isoCode.compareTo(b.isoCode),
                                        onValuePicked: (Country country) {
                                          print("Country ${country.phoneCode}");
                                          _dialCode = country.phoneCode;
                                        },
                                      ),
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
                                    debugPrint(
                                        "Dial Code $_dialCode${_contactEditingController.text}");
                                    loginAPI(LoginRequest(
                                        contactNumber:
                                            "+$_dialCode${_contactEditingController.text.toString()}"));
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
                                      login,
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
}
