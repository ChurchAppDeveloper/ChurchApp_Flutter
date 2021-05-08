import 'dart:async';

import 'package:analog_clock/analog_clock.dart';
import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/Screens/RestService/ConfessionService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Confession extends StatefulWidget {
  final bool isShowAppbar;

  const Confession({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _ConfessionState createState() => _ConfessionState();
}

var isBarHide = false;

class _ConfessionState extends State<Confession> {
  var isShowAppbar;
  String confessionData = "";
  var confessionNameArr = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M'
  ];
  bool _fetching;
  List<ConfessionItem> menus;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    super.initState();
    _fetching = true;
    isShowAppbar = Get.arguments;
    isBarHide = isShowAppbar;

    SystemChrome.setEnabledSystemUIOverlays([]);

    ConfessionService().getConfessionData().then((data) {
      setState(() {
        ConfessionData dataval = data.first;
        // int starttime = dataval.startTime;
        // if (starttime > 12) {
        //   starttime = starttime - 12;
        // }
        confessionData = "The Confession has scheduled on " +
            dataval.confessionDate +
            " at " +
            dataval.startTime.toString() +
            " to " +
            dataval.endTime.toString() +
            " and duration is " +
            dataval.slotDuration.toString() +
            " Minutes";
        // The Confession has scheduled on 01/05/2021 at 3:30 tp 4:30 PM
      });
    });

    ConfessionService().getBookedConfessionList().then((data) {
      setState(() {
        menus = data;
        _fetching = false;
      });
    });
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
          Container(
              child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                        color: Colors.deepOrangeAccent,
                        height: MediaQuery.of(context).size.height / 3)),
              ),
              ClipPath(
                clipper: WaveClipper(),
                child: Column(children: [
                  Container(
                      padding: EdgeInsets.only(bottom: 60),
                      color: Colors.red,
                      // height: 180,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 24),
                        child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Color(0xffFDCF09),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('image/bg1.jpg'),
                          ),
                        ),
                      )),

                  // Positioned(top: 0, child: Text("asdada"))
                ]),
              ),
              Container(
                margin: EdgeInsets.only(left: 120),
                // padding: EdgeInsets.only(right: 0),
                color: Colors.transparent,
                width: 250,
                height: 100,
                padding: EdgeInsets.all(8.0),
                alignment: Alignment.centerRight,
                child: Text(confessionData,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          )),
          Container(
              child: Text("Scheduled List",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ))),
          Expanded(
            child: (_fetching)
                ? Container(
                    child: Center(
                      child: Loading(
                        indicator: BallPulseIndicator(),
                        size: 100.0,
                        color: Colors.red,
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: menus.length,
                        itemBuilder: (context, index) => ListTile(
                            trailing: Icon(FontAwesomeIcons.church),
                            title:
                                Text("Parishioner " + confessionNameArr[index],
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    )),
                            subtitle: Text(
                                menus[index].startTime.toString() +
                                    " to " +
                                    menus[index].endTime.toString(),
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                )),
                            onTap: () {
                              print(index);
                            }))),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RoundedLoadingButton(
              animateOnTap: true,
              child: Text('Schedule',
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

  onSubmitPressed() {
    ConfessionService().getAvailableConfessionList().then((data) {
      if (data.length == 0) {
      } else {
        ConfessionService().createNewSlots(data.first);
      }
    });
    Timer(Duration(seconds: 3), () {
      _btnController.success();
    });
  }
}

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, 320);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        padding: EdgeInsets.only(top: 4),
        decoration: BoxDecoration(color: Colors.redAccent, boxShadow: [
          BoxShadow(color: Colors.red, blurRadius: 20, offset: Offset(0, 0))
        ]),
        child: Column(
          children: <Widget>[
            if (isBarHide)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 150,
                      width: 150,
                      child: AnalogClock(
                        decoration: BoxDecoration(
                            border:
                                Border.all(width: 10.0, color: Colors.white),
                            color: Colors.red[50],
                            shape: BoxShape.circle),
                        width: 150.0,
                        isLive: true,
                        hourHandColor: Colors.red,
                        minuteHandColor: Colors.red,
                        secondHandColor: Colors.black,
                        numberColor: Colors.red,
                        tickColor: Colors.black,
                        showSecondHand: true,
                        showNumbers: true,
                        textScaleFactor: 1.4,
                        showTicks: true,
                        showDigitalClock: false,
                        showAllNumbers: true,
                        datetime: DateTime(2019, 1, 1, 9, 12, 15),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Date",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "30/01/2021",
                      style: TextStyle(fontSize: 26, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "Time",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "3:30 PM to 4:30 PM",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
                SizedBox(
                  width: 32,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      "Duration",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text("10 mins",
                        style: TextStyle(color: Colors.white, fontSize: 18))
                  ],
                ),
                SizedBox(
                  width: 16,
                )
              ],
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = Path();

    p.lineTo(0, size.height - 70);
    p.lineTo(size.width, size.height);

    p.lineTo(size.width, 0);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
