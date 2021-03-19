import 'dart:convert';

import 'package:churchapp/Screens/Dashboard/Dashboard.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/LoginService.dart';
import 'package:churchapp/Screens/RestService/PushTokenService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  String _username = "";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  loadAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newPhone = prefs.getString("phone");
    var loginservice = LoginService();
    loginservice.getProfileDetails().then((userdata) {
      var contain =
          userdata.where((element) => element.phoneNumber == newPhone);

      if (contain.isNotEmpty) {
        print("No Neeed to create");
        var isAdmin = (contain.first.userRole != "Contributor");
        Singleton().isAdmin = isAdmin;
      } else {
        print(" Neeed to create");
        Singleton().isAdmin = false;
      }
    });
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = (prefs.getString('phone') ?? "");

    if (_username == "") {
      // Navigator.pushNamedAndRemoveUntil(
      //     context, '/login', ModalRoute.withName('/login'));
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => true,
      );
    } else {
      //Compare and send token to server
      PushTokenService().deleteToken();
      // PushTokenService().sendupdatedToken();

      loadAdminStatus();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
