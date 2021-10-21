import 'package:churchapp/api/mass_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class WeekdayPicker extends StatefulWidget {
  @override
  _WeekdayPickerState createState() => _WeekdayPickerState();
}

class _WeekdayPickerState extends State<WeekdayPicker> {
  Future apiTiming;
  CalendarController _calendarController = CalendarController();

  // _AppointmentDataSource events;
  // List<Content> contentTiming = List.empty();
  // List<Appointment> appointments ;

  @override
  void initState() {
    super.initState();
    apiTiming = getMass();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FutureBuilder<List<Appointment>>(
                future: getMass(),
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (projectSnap.connectionState ==
                      ConnectionState.done) {
                    List<Appointment> appointments = projectSnap.data;



                    if (projectSnap.hasData) {
                      _MeetingDataSource events =
                          _MeetingDataSource(projectSnap.data);
                      /* Future.delayed(Duration(seconds: 2)).then((value) {
                        events.notifyListeners(CalendarDataSourceAction.add, projectSnap.data);
                      });*/
                      return Container(
                        child: SfCalendar(
                          view: CalendarView.month,
                          allowedViews: <CalendarView>[
                            CalendarView.day,
                            CalendarView.week,
                            CalendarView.month,
                          ],
                          viewNavigationMode: ViewNavigationMode.snap,
                          dataSource: events,
                          // dataSource: MeetingDataSource(_getDataSource()),
                          showCurrentTimeIndicator: true,
                          appointmentTextStyle: TextStyle(fontSize: 16),
                          todayTextStyle: TextStyle(fontSize: 18),
                          showDatePickerButton: true,
                          minDate: DateTime.now(),
                          allowViewNavigation: true,
                          maxDate: DateTime.now().add(Duration(days: 30)),
                          todayHighlightColor: Colors.red.shade200,
                          timeSlotViewSettings: TimeSlotViewSettings(
                              timeInterval: Duration(hours: 2)),
                          selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.red, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            shape: BoxShape.rectangle,
                          ),
                          controller: _calendarController,
                          monthViewSettings: MonthViewSettings(
                              showTrailingAndLeadingDates: true,
                              showAgenda: true,
                              appointmentDisplayMode:
                                  MonthAppointmentDisplayMode.indicator),
                        ),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  } else {
                    return Text("Error ${projectSnap.error}");
                  }
                }),
          ),
        ),
      ],
    );
  }
}

class _MeetingDataSource extends CalendarDataSource {
  _MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  void addListener(CalendarDataSourceCallback listener) {}

  @override
  String getRecurrenceRule(int index) {
    return appointments[index].recurrenceRule;
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
}
