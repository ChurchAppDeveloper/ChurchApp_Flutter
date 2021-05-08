import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/MasstimingService.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class Rosary extends StatefulWidget {
  @override
  _RosaryState createState() => _RosaryState();
}

final Color bgColor = Colors.white;

class _RosaryState extends State<Rosary> with TickerProviderStateMixin {
  Stopwatch stopwatch;
  double hour = 0;
  double minute = 0;
  double seconds = 0;
  DateTime now = DateTime.now();
  bool _fetching;
  List<EchurasticRosaryData> modeldata;

  int currentIndex = 0;

  String role;
  Future apiRosary, getRole;

  // PushNotificationService notification;

  @override
  void initState() {
    super.initState();
    _fetching = true;
    SystemChrome.setEnabledSystemUIOverlays([]);

    getRole = initData();

    MassTimingService().getRosaryData().then((masstiming) {
      setState(() {
        _fetching = false;
        print("masstiming $masstiming");
        modeldata = masstiming;
        if (modeldata.isNotEmpty) {
          var datetime = convertTimeStampToDateTime(modeldata.first.startTime);
          hour = datetime.hour.toDouble(); //now.hour.toDouble();
          minute = datetime.minute.toDouble(); //now.minute.toDouble();

        }
      });
    });

    stopwatch = Stopwatch();
    // var datetime = convertTimeStampToDateTime(modeldata.first.startTime);
    // hour = datetime.hour.toDouble(); //now.hour.toDouble();
    // minute = datetime.minute.toDouble(); //now.minute.toDouble();

    Timer.periodic(Duration.zero, (t) {
      if (stopwatch.elapsed.inSeconds == 60) {
        minute = DateTime.now().minute.toDouble();
        stopwatch.reset();
      } else if (stopwatch.elapsed.inMinutes == 60) {
        hour = DateTime.now().second.toDouble();
        stopwatch.reset();
      }
      // setState(() {});
    });

    stopwatch.start();
  }

  DateTime convertTimeStampToDateTime(int timeStamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    String savedDateString = DateFormat("yyyy-MM-dd hh:mm:ss").format(date);
    DateTime tempDate =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(savedDateString);
    return tempDate;
  }


  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        var date = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        _dateController.text = DateFormat.yMd().format(date);
        _selectTime(context);

      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
        var date = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        _timeController.text =
            formatDate(date, [hh, ':', nn, " ", am]).toString();
        print("RRRRRR: ${_timeController.text} ");
      });
  }

  @override
  void dispose() {
    stopwatch?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.white,
      Colors.red,
      Colors.orange,
      Colors.black,
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: bgColor,
          body: (_fetching)
              ? Container(
                  child: Center(
                    child: Loading(
                      indicator: BallPulseIndicator(),
                      size: 100.0,
                      color: Colors.red,
                    ),
                  ),
                )
              : Container(
                  decoration: new BoxDecoration(
                    // color: Colors.transparent,
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.dstATop),
                      image: AssetImage('image/rosarybg.jpg'),
                    ),
                  ),
                  child: Column(
                    verticalDirection: VerticalDirection.up,
                    children: <Widget>[
                      Center(child: Container()),
                      SizedBox(
                        height: 50,
                      ),
                      AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'ROSARY',
                            textStyle: const TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                            colors: colorizeColors,
                            speed: const Duration(milliseconds: 500),
                          ),
                        ],

                        isRepeatingAnimation: true,
                        repeatForever: true,
                        pause: const Duration(milliseconds: 500),
                        displayFullTextOnTap: true,
                        stopPauseOnTap: true,
                      ),
                      Text(
                          "${hour.round()}:${minute.round()} ${TimeOfDay.fromDateTime(now).period == DayPeriod.am ? 'AM' : 'PM'}",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              fontSize: 50,
                              color: Colors.black,
                            ),
                          )),
                    ],
                  ),
                ),
          floatingActionButton: FutureBuilder(
              future: getRole,
              builder: (context, projectSnap) {
                if (projectSnap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (projectSnap.connectionState ==
                    ConnectionState.done) {
                  return (projectSnap.data == 'Admin')
                      ? FloatingActionButton(
                          backgroundColor: Colors.red,
                          onPressed: () {
                            setState(() {

                              _selectDate(context);

                            });
                          },
                          child: new Icon(Icons.edit),
                        )
                      : Container();
                } else {
                  return Text("Error ${projectSnap.error}");
                }
              })),
    );
  }

  Future initData() async {
    return role =
        await SharedPref().getStringPref(SharedPref().role).then((value) {
      debugPrint("role: $value");

      return value;
    });
  }

}
