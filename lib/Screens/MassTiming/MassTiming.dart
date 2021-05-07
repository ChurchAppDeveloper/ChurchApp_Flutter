import 'package:churchapp/Screens/MassTiming/Eucharistic.dart';
import 'package:churchapp/Screens/MassTiming/Rosary.dart';
import 'package:churchapp/Screens/MassTiming/WeekdayPicker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    isShowAppbar = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Timings"),
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
                    label: "Eucharistic",
                    icon: Icon(FontAwesomeIcons.cross)),
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
        ));
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
}
