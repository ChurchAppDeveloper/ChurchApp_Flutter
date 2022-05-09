import 'package:churchapp/Screens/HomePage/home_screen.dart';
import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    print("called:");
    profileDashAPI();
    super.initState();
  }

  @override
  build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, title: appName, home: HomeScreen());
  }
}
