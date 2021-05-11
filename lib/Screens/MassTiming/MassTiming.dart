import 'package:churchapp/Screens/MassTiming/Eucharistic.dart';
import 'package:churchapp/Screens/MassTiming/Rosary.dart';
import 'package:churchapp/Screens/MassTiming/WeekdayPicker.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  String role;
  Future getRole;
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  final RoundedLoadingButtonController _btnController =
      new RoundedLoadingButtonController();

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    getRole = initData();
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
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            boxShadow: [
              BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              key: bottomNavigationKey,
              onTap: (index) {
                setState(() {
                  currentPage = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                    label: "Mass", icon: Icon(FontAwesomeIcons.bible)),
                BottomNavigationBarItem(
                    label: "Eucharistic", icon: Icon(FontAwesomeIcons.cross)),
                BottomNavigationBarItem(
                    label: "Rosary", icon: Icon(FontAwesomeIcons.ankh)),
              ],
              backgroundColor: Colors.white,
              showUnselectedLabels: true,
              selectedItemColor: Colors.red,
              currentIndex: currentPage,
              elevation: 8.0,
              showSelectedLabels: true,
            ),
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
                                String title = "Mass Timing";
                                switch (currentPage) {
                                  case 0:
                                    title = "Mass Timing";
                                    break;
                                  case 1:
                                    title = "Eucharistic Timing";
                                    break;
                                  case 2:
                                    title = "Rosary Timing";
                                    break;
                                }
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: Column(
                                        children: [
                                          Text(title,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red,
                                                ),
                                              )),
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
    /* EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
      ..loadingStyle = EasyLoadingStyle.custom
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..backgroundColor = Colors.red
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..maskColor = Colors.white.withOpacity(0.5)
      ..userInteractions = false;

    if(announceTitle.isNotEmpty && announcedesc.isNotEmpty){
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.custom,
      );
      createAnnouncementAPI(
          AnnouncementCreateRequest(
              title: announceTitle, description: announcedesc),
          file: selectedFile)
          .then((value) {
        // _btnController.success();
        // EasyLoading.dismiss();
        // Get.offNamed('/announcementCreate');

      }).catchError((error) {
        debugPrint("Error : $error");
        _btnController.stop();
        EasyLoading.dismiss();
      });
    }else{
      _btnController.stop();
      snackBarAlert(error, invalidAnnouncement, Icon(Icons.error_outline),
          errorColor, whiteColor);
    }*/
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

  _getPage(int page) {
    switch (page) {
      case 0:
        return WeekdayPicker();
      case 1:
        return Eucharistic();
      case 2:
        return Rosary();
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
