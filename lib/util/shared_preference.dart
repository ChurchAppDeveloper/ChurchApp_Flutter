/*
 * *
 *  Created by Gayathri , Kanmalai Technologies Pvt. Ltd on 4/2/21 6:30 PM.
 *  Copyright (c) 2021. All rights reserved.
 *  Last modified 4/2/21 2:36 PM by welcome.
 * /
 */
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  var token = "TOKEN";
  var role = "ROLE";
  var deviceId="DEVICEID";

  setStringPref(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
    return true;
  }
  getStringPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? "";
  }

  setIntegerPref(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
    return true;
  }

  getIntegerPref(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? "";
  }

// setboolPref(String key, bool value) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setBool(key, value);
//   return true;
// }
//
// getboolPref(String key) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   return prefs.getBool(key) ?? false;
// }
}
