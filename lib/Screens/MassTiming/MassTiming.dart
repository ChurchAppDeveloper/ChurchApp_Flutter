import 'package:churchapp/Screens/MassTiming/WeekdayPicker.dart';
import 'package:churchapp/api/mass_api.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/common_fun.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MassTiming extends StatefulWidget {
  final bool isShowAppbar;

  const MassTiming({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _MassTimingState createState() => _MassTimingState();
}

class _MassTimingState extends State<MassTiming> with TickerProviderStateMixin {
  var isShowAppbar;
  String role;
  Future getRole;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();
  List<String> _choices;
  int _choiceIndex;

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    getRole = initData();
    _choiceIndex = 0;
    _choices = ["Mass Timing", "Eucharistic", "Rosary"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Timings"),
                shape: ContinuousRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 219, 69, 71))
            : null,
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: WeekdayPicker(),
          ),
        ),
        floatingActionButton: FutureBuilder(
            future: getRole,
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (projectSnap.connectionState == ConnectionState.done) {
                return (projectSnap.data == 'Admin')
                    ? FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Column(
                                        children: [
                                          Text("Create Schedule",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                ),
                                              )),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                10,
                                            child: ListView.builder(
                                              itemCount: _choices.length,
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          top: 8.0,
                                                          bottom: 8.0),
                                                  child: ChoiceChip(
                                                    label: Text(_choices[index],
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                          ),
                                                        )),
                                                    selected:
                                                        _choiceIndex == index,
                                                    selectedColor: Colors.red,
                                                    onSelected:
                                                        (bool selected) {
                                                      setState(() {
                                                        _choiceIndex = selected
                                                            ? index
                                                            : 0;
                                                      });
                                                    },
                                                    elevation: 4.0,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    labelStyle: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 24.0),
                                            child: InkWell(
                                              onTap: () {
                                                _selectDate(context, setState);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons
                                                      .calendar_today_outlined),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text("Date :",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      DateFormat("MMM d, yyyy")
                                                          .format(selectedDate),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 24.0),
                                            child: InkWell(
                                              onTap: () {
                                                _selectStartTime(
                                                    context, setState);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons
                                                      .watch_later_outlined),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text("Start Time :",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      DateFormat("HH:mm a")
                                                          .format(
                                                        DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            selectedStartTime
                                                                .hourOfPeriod,
                                                            selectedStartTime
                                                                .minute),
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 24.0),
                                            child: InkWell(
                                              onTap: () {
                                                _selectEndTime(
                                                    context, setState);
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons
                                                      .watch_later_outlined),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8.0),
                                                    child: Text("End Time :",
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: Colors.black,
                                                          ),
                                                        )),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                      DateFormat("HH:mm a")
                                                          .format(
                                                        DateTime(
                                                            DateTime.now().year,
                                                            DateTime.now()
                                                                .month,
                                                            DateTime.now().day,
                                                            selectedEndTime
                                                                .hourOfPeriod,
                                                            selectedEndTime
                                                                .minute),
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: GoogleFonts.lato(
                                                        textStyle: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black,
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: RoundedLoadingButton(
                                              animateOnTap: true,
                                              child: Text('Schedule',
                                                  textAlign: TextAlign.start,
                                                  style: GoogleFonts.lato(
                                                    textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                              color: Colors.red,
                                              successColor: Colors.red,
                                              controller: _btnController,
                                              onPressed: onSubmitPressed,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: new Icon(Icons.add),
                      )
                    : Container();
              } else {
                return Text("Error ${projectSnap.error}");
              }
            }));
  }

  onSubmitPressed() async {

    Map<String, dynamic> timingForm = {
      "schedule_type": _choices[_choiceIndex],
      "date": "${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(selectedDate)}",
      "start_time":
          "${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedStartTime.hour, selectedStartTime.minute))}",
      "end_time":
          "${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, selectedEndTime.hour, selectedEndTime.minute))}",
    };

    debugPrint(timingForm.toString());
    createTimingAPI(timingForm);
  }

  _selectDate(context, setState) async {
    DateTime datePicker = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (datePicker != null && datePicker != selectedDate) {
      setState(() {
        selectedDate = datePicker;
      });
    }
  }

  _selectStartTime(context, setState) async {
    TimeOfDay startPicker = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if (startPicker != null && startPicker != selectedStartTime) {
      setState(() {
        selectedStartTime = startPicker;
      });
    }
  }

  _selectEndTime(context, setState) async {
    TimeOfDay endPicker = await showTimePicker(
      context: context,
      initialTime: selectedEndTime,
    );
    if (endPicker != null && endPicker != selectedEndTime) {
      setState(() {
        selectedEndTime = endPicker;
      });
    }
  }

  Future initData() async {
    return role =
        await SharedPref().getStringPref(SharedPref().role).then((value) {
      debugPrint("role: $value");

      return value;
    });
  }
}
