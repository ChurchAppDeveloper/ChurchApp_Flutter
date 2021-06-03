import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Confession extends StatefulWidget {
  final bool isShowAppbar;

  const Confession({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _ConfessionState createState() => _ConfessionState();
}

var isBarHide = false;

class _ConfessionState extends State<Confession> {
  var isShowAppbar;

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    isBarHide = isShowAppbar;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isShowAppbar
          ? AppBar(
              backgroundColor: Color.fromARGB(255, 219, 69, 71),
              shape: ContinuousRectangleBorder(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              title: Text('Confession'),
            )
          : null,
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/confession_bg.jpg"),
                  fit: BoxFit.fill)),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            verticalDirection: VerticalDirection.up,
            children: [
              FutureBuilder(
                  future: initEmailData(),
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (projectSnap.connectionState == ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.only(left:16.0,right:16.0,bottom: 16.0),
                        child: Text("or E-mail: ${projectSnap.data} to book your time slot. Walk-ins are now okay, but keep in mind that those who made appointments, take precedence.",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            )),
                      );
                    } else {
                      return Text("Error ${projectSnap.error}");
                    }
                  }),
              FutureBuilder(
                  future: initPhoneData(),
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (projectSnap.connectionState == ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.only(left:16.0,right:16.0),
                        child:               RichText(
                          text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                  text:"Please call the Parish Office at:",
                                  style:GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  )),
                              TextSpan(
                                  text: " ${projectSnap.data}",
                                  style:GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.red,
                                    ),
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launch(
                                          'tel:${projectSnap.data}');
                                      print('Terms of Service"');
                                    }
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Text("Error ${projectSnap.error}");
                    }
                  }),
              FutureBuilder(
                  future: initData(),
                  builder: (context, projectSnap) {
                    if (projectSnap.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (projectSnap.connectionState == ConnectionState.done) {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("By Appointment Only",
                                textAlign: TextAlign.start,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:16.0,right:16.0,bottom: 16.0),
                            child: Text(projectSnap.data,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )),
                          ),

                        ],
                      );
                    } else {
                      return Text("Error ${projectSnap.error}");
                    }
                  }),

            ],
          ),
        ),
      ]),
    );
  }

  Future initData() async {
    return SharedPref().getStringPref("confessionDetails").then((value) {
      debugPrint("confessionDetails: $value");
      return value;
    });
  }
  Future initPhoneData() async {
    return await SharedPref().getStringPref("confessionNumber").then((value) {
      debugPrint("confessionNumber: $value");
      return value;
    });
  }
  Future initEmailData() async {
    return await SharedPref().getStringPref("confessionEmail").then((value) {
      debugPrint("confessionEmail: $value");
      return value;
    });
  }
}
