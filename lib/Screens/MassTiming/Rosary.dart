import 'dart:async';
import 'dart:math';

import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/MasstimingService.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  // final items = ["Clock", "List", "Settings"];
  final icons = [Icons.alarm, Icons.list, Icons.settings];

  double _secondPercent() => stopwatch.elapsed.inSeconds / 60;
  double _minutesPercent() => minute / 60;
  double _hoursPercent() => hour / 24;
  // PushNotificationService notification;

  @override
  void initState() {
    super.initState();
    _fetching = true;
    SystemChrome.setEnabledSystemUIOverlays([]);
    /* final FirebaseMessaging fcm = FirebaseMessaging.instance;
    notification = PushNotificationService(fcm);
    notification.notificationPluginInitilization();
    notification.context = context;*/

    MassTimingService().getRosaryData().then((masstiming) {
      setState(() {
        _fetching = false;
        print("masstiming $masstiming");
        modeldata = masstiming;
        if (modeldata.isNotEmpty) {
          var datetime = convertTimeStampToDateTime(modeldata.first.startTime);
          hour = datetime.hour.toDouble(); //now.hour.toDouble();
          minute = datetime.minute.toDouble(); //now.minute.toDouble();

          //Schedule Local notification
          // notification.cancelNotification(999);
          // notification.scheduleNotificationForCelebrityDay(
          //     datetime, 999, "Rosary");
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

  Widget _addButton() {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
          boxShadow: [
            BoxShadow(
                color: Colors.redAccent.withOpacity(0.5),
                blurRadius: 15,
                spreadRadius: 2)
          ]),
      child: Center(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  double _height = 310.0;
  double _width = 310.0;
  DateTime selectedDate = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _setTime, _setDate;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  String _hour, _minute, _time;
  bool isEditOptionEabled = false;
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  Future<Null> _selectDate(BuildContext context) async {
    if (!Singleton().isAdmin) {
      return;
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        var date = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        _dateController.text = DateFormat.yMd().format(date);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    if (!Singleton().isAdmin) {
      return;
    }
    final TimeOfDay picked = await showTimePicker(
      context: context,
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

  onSubmitPressed() async {
    await EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.pouringHourGlass
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.red
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5)
      ..userInteractions = false;
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.custom,
    );

    //Schedule Local notification
    var date = DateTime(selectedDate.year, selectedDate.month, selectedDate.day,
        selectedTime.hour, selectedTime.minute);
    print(date);
    // notification.cancelNotification(999);
    // notification.scheduleNotificationForCelebrityDay(date, 999, "Rosary");
    Timer(Duration(seconds: 3), () {
      setState(() {
        _width = 310;
        _height = 310;
        isEditOptionEabled = false;
      });
      _btnController.success();
      EasyLoading.dismiss();
    });
  }

  Widget _editButton() {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 10)
          ]),
      child: GestureDetector(
          onTap: () {
            setState(() {
              _width = 210;
              _height = 210;
              isEditOptionEabled = true;
            });
          },
          child: Center(
            child: Icon(
              Icons.edit,
              color: Colors.redAccent,
              size: 32,
            ),
          )),
    );
  }

  @override
  void dispose() {
    stopwatch?.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          Colors.black.withOpacity(0.5), BlendMode.dstATop),
                      image: AssetImage('image/rosarybg.jpg'),
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      // Positioned(
                      //   top: 40,
                      //   child: _addButton(),
                      // ),
                      if (!Singleton().isAdmin)
                        Positioned(
                          top: 40,
                          right: 16,
                          child: _editButton(),
                        ),
                      Column(
                        children: <Widget>[
                          Center(child: Container()),
                          SizedBox(
                            height: 40,
                          ),
                          Text("ROSARY",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                              )),
                          Text(
                              "${hour.round()}:${minute.round()} ${TimeOfDay.fromDateTime(now).period == DayPeriod.am ? 'AM' : 'PM'}",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 50,
                                  color: Colors.black,
                                ),
                              )),
                          if (isEditOptionEabled)
                            Row(
                              children: <Widget>[
                                Text(
                                  'Choose Date',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                                ),
                                InkWell(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    width: _width,
                                    height: _height / 7,
                                    margin: EdgeInsets.only(top: 0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.red)),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.justify,
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _dateController,
                                      onSaved: (String val) {
                                        _setDate = val;
                                      },
                                      // decoration: InputDecoration(
                                      //     disabledBorder: UnderlineInputBorder(
                                      //         borderSide: BorderSide.none),
                                      //     contentPadding: EdgeInsets.only(top: 0.0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isEditOptionEabled)
                            Row(
                              children: <Widget>[
                                Text(
                                  'Choose Time',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5),
                                ),
                                InkWell(
                                  onTap: () {
                                    _selectTime(context);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0),
                                    width: _width,
                                    height: _height / 7,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(color: Colors.red)),
                                    child: TextFormField(
                                      style: TextStyle(fontSize: 20),
                                      textAlign: TextAlign.justify,
                                      onSaved: (String val) {
                                        _setTime = val;
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeController,
                                      // decoration: InputDecoration(
                                      //     disabledBorder: UnderlineInputBorder(
                                      //         borderSide: BorderSide.none),
                                      //     contentPadding: EdgeInsets.all(0)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isEditOptionEabled)
                            RoundedLoadingButton(
                              child: Text('Submit',
                                  style: TextStyle(color: Colors.white)),
                              color: Colors.red,
                              controller: _btnController,
                              onPressed: onSubmitPressed,
                            ),
                        ],
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget _getItem(String t, int index) {
    final selected = index == currentIndex;
    final color = selected ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            icons.elementAt(index),
            size: selected ? 40 : 32,
            color: color,
          ),
          Text(
            t,
            style: TextStyle(color: color),
          )
        ],
      ),
    );
  }
}

enum LineType { hour, minute, second }

class LinesPainter extends CustomPainter {
  final Paint linePainter;

  final double lineHeight = 8;
  final int maxLines = 30;

  LinesPainter()
      : linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;

    List.generate(maxLines, (i) {
      canvas.drawLine(Offset(0, radius), Offset(0, radius - 8), linePainter);
      canvas.rotate(2 * pi / maxLines);
    });

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class TimeLinesPainter extends CustomPainter {
  final Paint linePainter;
  final Paint hourPainter;
  final Paint minutePainter;
  final double tick;
  final LineType lineType;

  TimeLinesPainter({this.tick, this.lineType})
      : linePainter = Paint()
          ..color = Colors.redAccent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
        minutePainter = Paint()
          ..color = Colors.black38
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5,
        hourPainter = Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.5;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;

    canvas.translate(radius, radius);

    switch (lineType) {
      case LineType.hour:
        canvas.rotate(24 * pi * tick);
        canvas.drawPath(_hourPath(radius), hourPainter);
        break;
      case LineType.minute:
        canvas.rotate(2 * pi * tick);
        canvas.drawPath(_minutePath(radius), minutePainter);
        break;
      case LineType.second:
        canvas.rotate(2 * pi * tick);
        canvas.drawPath(_secondPath(radius), linePainter);
        canvas.drawShadow(_secondPath(radius), Colors.black26, 100, true);

        break;
    }
  }

  Path _hourPath(double radius) {
    return Path()
      ..lineTo(0, -((radius / 1.4) / 2))
      ..close();
  }

  Path _minutePath(double radius) {
    return Path()
      ..lineTo(0, -(radius / 1.4))
      ..close();
  }

  Path _secondPath(double radius) {
    return Path()
      ..lineTo(0, -(radius + 10))
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
