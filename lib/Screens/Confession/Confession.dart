
import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
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
  final RoundedLoadingButtonController _btnController =
  new RoundedLoadingButtonController();
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
        body: Column(children: [
          Stack(
            children: [
          Opacity(
            opacity: 0.5,
            child: ClipPath(
                clipper: WaveClipper(),
                child: Container(
                    color: Colors.deepOrangeAccent,
                    height: MediaQuery.of(context).size.height / 1.7)),
          ),
          ClipPath(
            clipper: WaveClipper(),
            child: Column(children: [
              Container(
                  padding: EdgeInsets.only(bottom: 130),
                  color: Colors.red,
                  // height: 180,
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only( top: 60),
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Color(0xffFDCF09),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage('image/bg1.jpg'),
                      ),
                    ),
                  )),
            ]),
          ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('To book a Confession, contact us',
                textAlign: TextAlign.start,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedLoadingButton(
              animateOnTap: true,
              child: Text('Call',
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
          )
        ]),);
  }

  onSubmitPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    launch(
        'tel:${prefs.getString("confessionNumber").toString()}');
    _btnController.stop();
  }
}
