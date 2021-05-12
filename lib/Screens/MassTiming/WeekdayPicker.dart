import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/MasstimingService.dart';
import 'package:churchapp/api/mass_api.dart';
import 'package:churchapp/model_response/mass_response.dart';
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
  Content content;

  bool _fetching;

  // PushNotificationService notification;

  @override
  void initState() {
    super.initState();
    _fetching = true;

    getMass().then((masstimig) {
      setState(() {
        _fetching = false;
        // Comparator<MassResponse> priceComparator =
        //     (a, b) => a.content.massId.compareTo(b.massId);
        // masstimig.content.monday.sort(priceComparator);
         content = masstimig.content;
        print("masstimings $content");

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
    const colorizeColors = [
      Colors.white,
      Colors.red,
      Colors.orange,
      Colors.black,
    ];
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
      return Column(
        children: [
          Expanded(
            child: Padding(
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
                dataSource: _getCalendarDataSource(),
                // dataSource: MeetingDataSource(_getDataSource()),
                showCurrentTimeIndicator: true,
                appointmentTextStyle: TextStyle(fontSize: 16),
                todayTextStyle: TextStyle(fontSize: 18),
                showDatePickerButton: true,
                minDate: DateTime.now(),
                allowViewNavigation: true,
                maxDate: DateTime.now().add(Duration(days: 30)),
                todayHighlightColor: Colors.red.shade200,
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
            ),
          ),
        ],
      );
    }
  }
  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];

      appointments.add(Appointment(
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 2)),
          subject: 'Mass Timing',
          color: Colors.red,
          recurrenceRule:
          'FREQ=WEEKLY;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR,SA,SU;'));

    return _AppointmentDataSource(appointments);
  }

}
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  meetings.add(Meeting(
      '', startTime, endTime, const Color(0xFF0F8644), false));
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
