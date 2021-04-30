import 'package:churchapp/Screens/Announcement/AnnouncementList.dart';
import 'package:churchapp/Screens/Classifields/ClassiieldList.dart';
import 'package:churchapp/Screens/Confession/Confession.dart';
import 'package:churchapp/Screens/ContactUS/Contactus.dart';
import 'package:churchapp/Screens/Hamburger/MenuPage.dart';
import 'package:churchapp/Screens/HomePage/home_screen.dart';
import 'package:churchapp/Screens/LiveStream/LiveStream.dart';
import 'package:churchapp/Screens/MassTiming/MassTiming.dart';
import 'package:churchapp/Screens/PrayerRequest/PrayerRequest.dart';
import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../WebViewLoad.dart';

enum MenuList {
  dashboard,
  parishannouncement,
  livestream,
  bulletin,
  masstiming,
  prayerrequest,
  donate,
  confession,
  classifields,
  readings,
  ministers,
  school,
  contactus,
  aboutus,
  logout
}

_titleForSelectedModule(MenuList title) {
  switch (title) {
    case MenuList.dashboard:
      return "St. Barnabas Church";
    case MenuList.parishannouncement:
      return "Parish Announcement";
    case MenuList.livestream:
      return "Live Stream";
    case MenuList.masstiming:
      return "Mass Timing";
    case MenuList.confession:
      return "Confession";
    case MenuList.classifields:
      return "Classified";
    case MenuList.contactus:
      return "Contact us";
    case MenuList.aboutus:
      return "About us";
    case MenuList.logout:
      return "Logout";
    case MenuList.bulletin:
      return "Bulletin";
    case MenuList.prayerrequest:
      return "Prayer Request";
    case MenuList.donate:
      return "Donate";
    case MenuList.readings:
      return "Readings";
    case MenuList.ministers:
      return "Ministers";
    case MenuList.school:
      return "School";
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
@override
  void initState() {
  profileDashAPI();
    super.initState();
  }
  @override
  build(BuildContext context) {
    var bgColor = Color.fromARGB(255, 219, 69, 71);
    var menuposition = MenuList.values[0];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      home: HomeScreen()
      // home: SimpleHiddenDrawer(
      //   enableCornerAnimation: true,
      //   menu: Menu(),
      //   screenSelectedBuilder: (position, controller) {
      //     Widget screenCurrent;
      //     menuposition = MenuList.values[position];
      //     switch (menuposition) {
      //       case MenuList.dashboard:
      //         screenCurrent = HomeScreen();
      //         break;
      //       case MenuList.parishannouncement:
      //         screenCurrent = AnnouncementList();
      //         break;
      //       case MenuList.livestream:
      //         screenCurrent = LiveStream(isShowAppbar: false);
      //         break;
      //       case MenuList.masstiming:
      //         screenCurrent = MassTiming(isShowAppbar: false);
      //         break;
      //       case MenuList.confession:
      //         screenCurrent = Confession(isShowAppbar: false);
      //         break;
      //       case MenuList.classifields:
      //         screenCurrent = ClassiieldList(isShowAppbar: false);
      //         break;
      //       case MenuList.contactus:
      //         screenCurrent = ContactUS();
      //         break;
      //       case MenuList.aboutus:
      //         screenCurrent = WebViewLoad(
      //             weburl: prefs.getString('aboutUs'), isShowAppbar: false, pageTitle: "About us");
      //         break;
      //       case MenuList.logout:
      //         clearCredentials();
      //         break;
      //       case MenuList.bulletin:
      //         screenCurrent = WebViewLoad(
      //             weburl:prefs.getString('bulletinUrl'),
      //             isShowAppbar: false,
      //             pageTitle: "Bulletins");
      //         break;
      //       case MenuList.prayerrequest:
      //         screenCurrent = PrayerRequest(isShowAppbar: false);
      //         break;
      //       case MenuList.donate:
      //         screenCurrent = WebViewLoad(
      //             weburl: prefs.getString('donateUrl'),
      //             isShowAppbar: false,
      //             pageTitle: "Donate");
      //         break;
      //       case MenuList.readings:
      //         screenCurrent = WebViewLoad(
      //             weburl: prefs.getString('onlieReadingUrl'),
      //             isShowAppbar: false,
      //             pageTitle: "Readings");
      //         break;
      //       case MenuList.ministers:
      //         screenCurrent = WebViewLoad(
      //             weburl: prefs.getString('ministersUrl'),
      //             isShowAppbar: false,
      //             pageTitle: "Ministers");
      //         break;
      //       case MenuList.school:
      //         screenCurrent = WebViewLoad(
      //             weburl: prefs.getString('schoolUrl'),
      //             isShowAppbar: false,
      //             pageTitle: "School");
      //         break;
      //     }
      //
      //     return Scaffold(
      //       appBar: AppBar(
      //         elevation: 0.0,
      //         backgroundColor: bgColor,
      //         // toolbarHeight: 50.0,
      //         title: Text(_titleForSelectedModule(menuposition),
      //             textAlign: TextAlign.start,
      //             style: GoogleFonts.lato(
      //               textStyle: TextStyle(
      //                 fontSize: 22,
      //                 fontWeight: FontWeight.w600,
      //                 color: Colors.white,
      //               ),
      //             )),
      //         leading: IconButton(
      //           icon: Icon(Icons.menu),
      //           onPressed: () {
      //             controller.toggle();
      //             // do something
      //           },
      //         ),
      //       ),
      //       body: screenCurrent,resizeToAvoidBottomInset: true,
      //     );
      //   },
      // ),
    );
  }
}
