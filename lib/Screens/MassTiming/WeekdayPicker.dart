import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/MasstimingService.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeekdayPicker extends StatefulWidget {
  @override
  _WeekdayPickerState createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  double _height;
  double _width;
  List<MassTiming> masstimings;
  bool _fetching;

  // PushNotificationService notification;

  @override
  void initState() {
    super.initState();
    _fetching = true;
    /* final FirebaseMessaging fcm = FirebaseMessaging.instance;
    notification = PushNotificationService(fcm);
    notification.notificationPluginInitilization();
    notification.context = context;*/
    // notification.cancelAllNotifications();
    MassTimingService.getTimings().then((masstimig) {
      setState(() {
        _fetching = false;
        Comparator<MassTiming> priceComparator =
            (a, b) => a.massId.compareTo(b.massId);
        masstimig.sort(priceComparator);
        masstimings = masstimig;
        print("masstimings $masstimings");

        // masstimings.forEach((MassTiming item) {
        //   print('${item.massId} - ${item.days}');
        // });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    if (_fetching) {
      return Container(
        child: Center(
          child: Loading(
            indicator: BallPulseIndicator(),
            size: 100.0,
            color: Colors.red,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: SfCalendar(
          view: CalendarView.month,
          allowedViews: <CalendarView>
          [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month,
          ],
          viewNavigationMode: ViewNavigationMode.snap,
          dataSource: MeetingDataSource(_getDataSource()),
          showCurrentTimeIndicator: true,
          appointmentTextStyle: TextStyle(fontSize: 16),
          todayTextStyle: TextStyle(fontSize: 18),
          showDatePickerButton: true,
          minDate: DateTime.now(),
          allowViewNavigation: true,
          maxDate: DateTime.now().add(Duration(days: 30)),
          todayHighlightColor: Colors.red,
          timeSlotViewSettings:
          TimeSlotViewSettings(timeInterval: Duration(hours: 2)),
          selectionDecoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.red, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            shape: BoxShape.rectangle,
          ),
          monthViewSettings: MonthViewSettings(
              showTrailingAndLeadingDates: true,
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator),
        ),
      );
    }
  }
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      'Conference', startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

class DayTimeWidget extends StatefulWidget {
  // final MassTiming masstime;
  // final PushNotificationService notification;
  // const DayTimeWidget({Key key, this.masstime, this.notification})
  //     : super(key: key);
  @override
  _DayTimeWidgetState createState() => _DayTimeWidgetState();
}

String convertTimeStampToHumanHour(int timeStamp) {
  var dateToTimeStamp = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return DateFormat.jm().format(dateToTimeStamp);
}

DateTime convertTimeStampToDateTime(int timeStamp) {
  return DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
}

int constructDateAndHourToTimeStamp(DateTime dateTime, TimeOfDay time) {
  final constructDateTimeRdv = DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute)
      .millisecondsSinceEpoch;
  return constructDateTimeRdv;
}

class _DayTimeWidgetState extends State<DayTimeWidget> {
  double _height;
  double _width;
  MassTiming masstime;
  String _hour, _minute, _time, day, dateStr;
  String dateTime, _setTime;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 14, minute: 00);
  TimeOfDay selectedSecondTime = TimeOfDay(hour: 14, minute: 00);
  TextEditingController _timeController = TextEditingController();
  TextEditingController _secondTimeController = TextEditingController();

  // PushNotificationService notification;
  bool isFirstAlaramSwitched = false;
  bool isSecondAlaramSwitched = false;
  int firstAlaramNotificationid = 0;
  int secondAlaramNotificationid = 0;
  var daysArr = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  void initState() {
    // _timeController.text = formatDate(
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    //     [hh, ':', nn, " ", am]).toString();
    // masstime = widget.masstime;
    // notification = widget.notification;
    isFirstAlaramSwitched = masstime.startReminder;
    isSecondAlaramSwitched = masstime.endReminder;

    _timeController.text = convertTimeStampToHumanHour(masstime.startTime);
    _secondTimeController.text = convertTimeStampToHumanHour(masstime.endTime);

    var time = convertTimeStampToDateTime(masstime.startTime);
    selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);

    var secondtime = convertTimeStampToDateTime(masstime.endTime);
    selectedSecondTime =
        TimeOfDay(hour: secondtime.hour, minute: secondtime.minute);
    // TimeOfDay(hour: 13, minute: 43);
    day = masstime.days;

    //Schedule Local notification
    print("days ${masstime.days}");
    int notifficationday = daysArr.indexOf(day);
    firstAlaramNotificationid = notifficationday + 500;
    secondAlaramNotificationid = notifficationday + 600;
    // updateFirstNotification();
    // updateSecondNottfication();
    // // First Alaram
    // notification.scheduleWeeklyNotificationForRespectiveDays(selectedTime.hour,
    //     selectedTime.minute, notifficationday, firstAlaramNotificationid);
    // // Second Alaram
    // notification.scheduleWeeklyNotificationForRespectiveDays(
    //     selectedSecondTime.hour,
    //     selectedSecondTime.minute,
    //     notifficationday,
    //     secondAlaramNotificationid);

    super.initState();
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
        _timeController.text = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();
        // updateFirstNotification();
      });
  }

  Future<Null> _selectSecondTime(BuildContext context) async {
    if (!Singleton().isAdmin) {
      return;
    }
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedSecondTime,
    );
    if (picked != null)
      setState(() {
        selectedSecondTime = picked;
        _hour = selectedSecondTime.hour.toString();
        _minute = selectedSecondTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _secondTimeController.text = _time;
        _secondTimeController.text = formatDate(
            DateTime(2019, 08, 1, selectedSecondTime.hour,
                selectedSecondTime.minute),
            [hh, ':', nn, " ", am]).toString();
        // updateSecondNottfication();
      });
  }

  @override
  Widget build(BuildContext context) {
    dateTime = convertTimeStampToHumanHour(
        masstime.startTime); //DateFormat.yMd().format(DateTime.now());
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Column(children: <Widget>[
      Container(
          // width: 110,
          margin: EdgeInsets.only(left: 20, top: 10),
          child: ColorizeAnimatedTextKit(
            repeatForever: true,
            text: [day],
            textStyle: TextStyle(fontSize: 20.0, fontFamily: "Horizon"),
            colors: [
              Colors.purple,
              Colors.blue,
              Colors.yellow,
              Colors.red,
            ],
            textAlign: TextAlign.start,
          )),
      SizedBox(
        width: 15,
      ),
      Row(children: <Widget>[
        Text(
          "\tMASS TIMING:\t",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        InkWell(
          focusColor: Colors.red,
          onTap: () {
            _selectTime(context);
          },
          child: Container(
            // margin: EdgeInsets.only(top: 30),
            width: _width / 2.5,
            height: _height / 18,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: TextFormField(
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
              onSaved: (String val) {
                _setTime = val;
              },
              enabled: false,
              keyboardType: TextInputType.text,
              controller: _timeController,
              decoration: InputDecoration(
                  disabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  // labelText: 'Time',
                  contentPadding: EdgeInsets.all(5)),
            ),
          ),
        ),
        Switch(
          value: isFirstAlaramSwitched,
          onChanged: (value) {
            setState(() {
              isFirstAlaramSwitched = value;
              // updateFirstNotification();
              print(isFirstAlaramSwitched);
            });
          },
          activeTrackColor: Colors.red,
          activeColor: Colors.white,
        )
      ]),
      Row(children: <Widget>[
        Text(
          "\tMASS TIMING:\t",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        InkWell(
          focusColor: Colors.red,
          onTap: () {
            _selectSecondTime(context);
          },
          child: Container(
            // margin: EdgeInsets.only(top: 30),
            width: _width / 2.5,
            height: _height / 18,
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(100),
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: TextFormField(
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
              onSaved: (String val) {
                _setTime = val;
              },
              enabled: false,
              keyboardType: TextInputType.text,
              controller: _secondTimeController,
              decoration: InputDecoration(
                  disabledBorder:
                      UnderlineInputBorder(borderSide: BorderSide.none),
                  // labelText: 'Time',
                  contentPadding: EdgeInsets.all(5)),
            ),
          ),
        ),
        Switch(
          value: isSecondAlaramSwitched,
          onChanged: (value) {
            setState(() {
              isSecondAlaramSwitched = value;
              // updateSecondNottfication();
              print(isSecondAlaramSwitched);
            });
          },
          activeTrackColor: Colors.red,
          activeColor: Colors.white,
        )
      ]),
    ]);
  }

/*updateSecondNottfication() {
    if (isSecondAlaramSwitched) {
      //Cancel the existing notification
      notification.cancelNotification(secondAlaramNotificationid);
      //Schedule Notification with New Time
      DateTime notifficationday = DateTime(daysArr.indexOf(masstime.days));
      // notification.displayNotification1();
      notification.scheduleWeeklyNotificationForRespectiveDays(
          selectedSecondTime.hour,
          selectedSecondTime.minute,
          notifficationday,
          secondAlaramNotificationid);
    } else {
      //Cancel the existing notification
      notification.cancelNotification(secondAlaramNotificationid);
    }

    var masstiming = MassTiming(
        phoneNumber: masstime.phoneNumber,
        startTime:
            constructDateAndHourToTimeStamp(DateTime.now(), selectedTime),
        massId: masstime.massId,
        endTime:
            constructDateAndHourToTimeStamp(DateTime.now(), selectedSecondTime),
        days: masstime.days,
        endReminder: isSecondAlaramSwitched,
        startReminder: isFirstAlaramSwitched);

    MassTimingService().updateWeelyMassTiming(masstiming);
  }

  updateFirstNotification() {
    if (isFirstAlaramSwitched) {
      //Cancel the existing notification
      notification.cancelNotification(firstAlaramNotificationid);
      //Schedule Notification with New Time
      DateTime notifficationday = DateTime(daysArr.indexOf(masstime.days));
      notification.scheduleWeeklyNotificationForRespectiveDays(
          selectedTime.hour,
          selectedTime.minute,
          notifficationday,
          firstAlaramNotificationid);
    } else {
      //Cancel the existing notification
      notification.cancelNotification(firstAlaramNotificationid);
    }
    var masstiming = MassTiming(
        phoneNumber: masstime.phoneNumber,
        startTime:
            constructDateAndHourToTimeStamp(DateTime.now(), selectedTime),
        massId: masstime.massId,
        endTime:
            constructDateAndHourToTimeStamp(DateTime.now(), selectedSecondTime),
        days: masstime.days,
        endReminder: isSecondAlaramSwitched,
        startReminder: isFirstAlaramSwitched);

    MassTimingService().updateWeelyMassTiming(masstiming);
  }*/
}
