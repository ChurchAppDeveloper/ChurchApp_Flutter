import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SimpleHiddenDrawerController controller;

  List<MenuItem> menus = <MenuItem>[
    MenuItem("Home", Image.asset('image/h_home.png')),
    MenuItem("Parish Announncement", Image.asset('image/h_announcement.png')),
    MenuItem("LiveStream", Image.asset('image/h_livestream.png')),
    MenuItem("Bulletins", Image.asset('image/h_bulletin.png')),
    MenuItem("Mass Timings", Image.asset('image/h_masstiming.png')),
    MenuItem("Prayer Request", Image.asset('image/h_prayerrequest.png')),
    MenuItem("Donate", Image.asset('image/h_school.png')),
    MenuItem("Confession", Image.asset('image/h_confession.png')),
    MenuItem("Classified", Image.asset('image/h_classifields.png')),
    MenuItem("Readings", Image.asset('image/h_reading.png')),
    MenuItem("Ministers", Image.asset('image/h_ministries.png')),
    MenuItem("School", Image.asset('image/h_donate.png')),
    MenuItem("Contact us", Image.asset('image/h_contact.png')),
    MenuItem("About us", Image.asset('image/h_aboutus.png')),
    MenuItem("Logout", Image.asset('image/h_logout.png')),
  ];

  @override
  void didChangeDependencies() {
    controller = SimpleHiddenDrawerController.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          // top: 0.0,
          color: Color.fromARGB(255, 219, 69, 71),
          // child: Image.asset(
          //   "image/background.png",
          //   fit: BoxFit.fill,
          // ),
        ),
        Container(
          // top: 0.0,
          // color: Colors.red,
          child: Image.asset(
            "image/background.png",
            fit: BoxFit.fill,
          ),
        ),
        Material(
          color: Colors.transparent,
          child: ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) => ListTile(
                  leading: Container(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    alignment: Alignment.center,
                    child: menus[index].imageName,
                  ),
                  title: Text(menus[index].title.toString(),
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    controller.setSelectedMenuPosition(index);
                  })),
        ),
      ],
    );
  }
}

class MenuItem {
  final String title;
  final Image imageName;
  MenuItem(this.title, this.imageName);
}
