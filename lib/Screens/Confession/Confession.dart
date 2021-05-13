import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/foundation.dart';
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
  String prefs;
  Future getConfession;

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    isBarHide = isShowAppbar;
    getConfession = initData();
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
          child: FutureBuilder(
              future: getConfession,
              builder: (context, projectSnap) {
                if (projectSnap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (projectSnap.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(projectSnap.data,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        )),
                  );
                } else {
                  return Text("Error ${projectSnap.error}");
                }
              }),
        ),
      ]),
    );
  }

  Future initData() async {
    return prefs =
        await SharedPref().getStringPref("confessionNumber").then((value) {
      debugPrint("confessionNumber: $value");

      return value;
    });
  }
}
