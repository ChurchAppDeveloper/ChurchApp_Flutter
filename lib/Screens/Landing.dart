
import 'package:churchapp/api/authentication_api.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    profileAPI();
    super.initState();
  }

  /* loadAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var newPhone = prefs.getString("phone");
    var loginService = LoginService();
    loginService.getProfileDetails().then((userdata) {
      var contain =
          userdata.where((element) => element.phoneNumber == newPhone);

      if (contain.isNotEmpty) {
        debugPrint("No Neeed to create");
        var isAdmin = (contain.first.userRole != "Contributor");
        Singleton().isAdmin = isAdmin;
      } else {
        print(" Neeed to create");
        Singleton().isAdmin = false;
      }
    });
  }*/

  /* _loadUserInfo() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children:[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("image/background.png"),
                      fit: BoxFit.fill)),
            ),
            Column(
              children: [
                Container(
                  margin:
                  EdgeInsets.only(left: 20.0, bottom: 20.0, top: 90.0),
                  height: 300,
                  alignment: Alignment.topCenter,
                  child: Image.asset("image/churchLogo.png"),
                ),
                Container(
                  alignment: Alignment.center,
                  // width: 350.0,
                  child: Text(appName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 30,
                           fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )),
                ),
              ],
            ),
          ]
        ));
  }
}
