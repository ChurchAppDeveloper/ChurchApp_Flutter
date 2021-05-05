import 'dart:ffi';

import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LiveStream extends StatefulWidget {
  final bool isShowAppbar;

  const LiveStream({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _LiveStreamState createState() => _LiveStreamState();
}

class _LiveStreamState extends State<LiveStream> {
  var isShowAppbar;

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isShowAppbar
          ? AppBar(
              title: Text("Live Streaming"),
              backgroundColor: Color.fromARGB(255, 219, 69, 71),
              leading: IconButton(
                // iconSize: 50.0,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  // do something
                },
              ))
          : Container(),
      body: Container(
        child: Stack(
          children: <Widget>[
            CustomBody(),
          ],
        ),
      ),
    );
  }
}

class CustomBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double listheight = (45 * songs.length).toDouble();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          CustomHeader(),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              var wepage = WebViewLoad(
                  weburl: prefs.getString('facebookUrl'),
                  isShowAppbar: true,
                  pageTitle: "Live Streaming");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => wepage),
              );
            },
            child: Row(
              children: [
                SvgPicture.asset('image/facebook.svg',width: 70,height: 70,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Watch in Facebook",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )),
                ),
                Spacer(),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              debugPrint("LiveStream: ${prefs.getString('youtubeUrl')}");
              var wepage = WebViewLoad(
                  weburl: prefs.getString('youtubeUrl'),
                  isShowAppbar: true,
                  pageTitle: "Live Streaming in Youtube");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => wepage),
              );
            },
            child: Row(
              children: [
                Spacer(),
                SvgPicture.asset('image/youtube.svg',width: 70,height: 70,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Watch in Youtube",
                      textAlign: TextAlign.start,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        HeaderBackground(),
        // Container(
        //   width: 100,
        //   height: 100,
        //   margin: EdgeInsets.only(top: 300),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     image:
        //         DecorationImage(image: AssetImage('image/livestreaming.png')),
        //     borderRadius: BorderRadius.circular(35),
        //   ),
        // ),
      ],
    );
  }
}

class HeaderBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 275),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('image/LiveStreamBG.png'),
                  fit: BoxFit.cover)
              // boxShadow: [
              //   BoxShadow(blurRadius: 100, spreadRadius: 20, color: Colors.red)
              // ],
              ),
        ),
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height/3,
            color: Colors.white,
          ),
        ),
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: MediaQuery.of(context).size.height/2,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('image/bg2.jpg'), fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.cubicTo(sw, sh * 0.7, 0, sh * 0.8, 0, sh * 0.55);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BottomBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.lineTo(4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 5, 6 * sw / 12, 2 * sh / 5);
    path.cubicTo(7 * sw / 12, 2 * sh / 5, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.lineTo(sw, 0);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
