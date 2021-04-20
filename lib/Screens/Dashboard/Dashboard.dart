import 'package:churchapp/Screens/Announcemet/AnnouncemetList.dart';
import 'package:churchapp/Screens/Classifields/ClassiieldList.dart';
import 'package:churchapp/Screens/Confession/Confession.dart';
import 'package:churchapp/Screens/ContactUS/Contactus.dart';
import 'package:churchapp/Screens/Hamburger/MenuPage.dart';
import 'package:churchapp/Screens/HomePage/home_screen.dart';
import 'package:churchapp/Screens/LiveStream/LiveStream.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/MassTiming/MassTiming.dart';
import 'package:churchapp/Screens/PrayerRequest/PrayerRequest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/simple_hidden_drawer/simple_hidden_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
      return "ST. BARNABAS CHURCH";
    case MenuList.parishannouncement:
      return "PARISH ANNOUNCEMENT";
    case MenuList.livestream:
      return "Live Stream";
    case MenuList.masstiming:
      return "Mass Timing";
    case MenuList.confession:
      return "Confession";
    case MenuList.classifields:
      return "CLASSIFIED";
    case MenuList.contactus:
      return "Contact us";
    case MenuList.aboutus:
      return "About us";
    case MenuList.logout:
      return "Logout";
    case MenuList.bulletin:
      return "Bulletin";
    case MenuList.prayerrequest:
      return "PrayerRequest";
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
  SharedPreferences prefs;
  @override
  initState() {
    allocatePreference();

    super.initState();
  }

  allocatePreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  build(BuildContext context) {
    var bgColor = Color.fromARGB(255, 219, 69, 71);
    var menuposition = MenuList.values[0];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Barnabas',
      home: SimpleHiddenDrawer(
        menu: Menu(),
        screenSelectedBuilder: (position, controller) {
          Widget screenCurrent;
          menuposition = MenuList.values[position];
          switch (menuposition) {
            case MenuList.dashboard:
              screenCurrent = HomeScreen();
              break;
            case MenuList.parishannouncement:
              screenCurrent = AnnouncemetList(isShowAppbar: false);
              break;
            case MenuList.livestream:
              screenCurrent = LiveStream(isShowAppbar: false);
              break;
            case MenuList.masstiming:
              screenCurrent = MassTiming(isShowAppbar: false);
              break;
            case MenuList.confession:
              screenCurrent = Confession(isShowAppbar: false);
              break;
            case MenuList.classifields:
              screenCurrent = ClassiieldList(isShowAppbar: false);
              break;
            case MenuList.contactus:
              screenCurrent = ContactUS();
              break;
            case MenuList.aboutus:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('aboutUs'),
                  isShowAppbar: false,
                  pageTitle: "ABOUT US");
              break;
            case MenuList.logout:
              clearCredentials();

              // Navigator.pushNamedAndRemoveUntil(
              //     context, '/login', ModalRoute.withName('/login'));
              Future.delayed(Duration.zero, () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                );
              });

              break;
            case MenuList.bulletin:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('bulletinUrl'),
                  isShowAppbar: false,
                  pageTitle: "BULLETIN");
              break;
            case MenuList.prayerrequest:
              screenCurrent = PrayerRequest(isShowAppbar: false);
              // screenCurrent = WebViewLoad(
              //     weburl: prefs.getString('prayerRequestUtl'),
              //     isShowAppbar: false,
              //     pageTitle: "PRAYER REQUEEST");
              break;
            case MenuList.donate:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('donateUrl'),
                  isShowAppbar: false,
                  pageTitle: "DONATE");
              break;
            case MenuList.readings:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('onlieReadingUrl'),
                  isShowAppbar: false,
                  pageTitle: "READINGS");
              break;
            case MenuList.ministers:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('ministersUrl'),
                  isShowAppbar: false,
                  pageTitle: "MINISTERS");
              break;
            case MenuList.school:
              screenCurrent = WebViewLoad(
                  weburl: prefs.getString('schoolUrl'),
                  isShowAppbar: false,
                  pageTitle: "SCHOOL");
              break;
          }

          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: bgColor,
              // toolbarHeight: 50.0,
              title: Text(_titleForSelectedModule(menuposition)),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  controller.toggle();
                  // do something
                },
              ),
              // title: Text('Welcome to Flutter'),
              // actions: <Widget>[
              //   IconButton(
              //     iconSize: 50.0,
              //     icon: new Image.asset('image/background.png'),
              //     onPressed: () {
              //       // do something
              //     },
              //   )
              // ],
            ),
            // appBar: AppBar(
            //   leading: IconButton(
            //       icon: Icon(Icons.menu),
            //       onPressed: () {
            //         controller.toggle();
            //       }),
            // ),

            body: screenCurrent,
          );
        },
      ),
    );
  }

  clearCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString('phone', "");
    prefs.remove("phone");
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
