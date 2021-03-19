import 'dart:ffi';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    isShowAppbar = widget.isShowAppbar;
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
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                  // do something
                },
              ))
          : null,
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
    return Stack(children: <Widget>[
      Positioned(
          left: 70,
          bottom: 125,
          child: ScaleAnimatedTextKit(
            repeatForever: true,
            onTap: () {
              print("Tap Event");
            },
            text: ["LIVE STREAMING"],
            textStyle: TextStyle(
                fontSize: 30.0, fontFamily: "Canterbury", color: Colors.red),
            textAlign: TextAlign.start,
          )),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomHeader(),
            FlatButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var wepage = WebViewLoad(
                    weburl: prefs.getString('facebookUrl'),
                    isShowAppbar: true,
                    pageTitle: "LIVE STREAMING");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => wepage),
                );
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('image/FFacebook.png'),
            ),
            FlatButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var wepage = WebViewLoad(
                    weburl: prefs.getString('youtubeUrl'),
                    isShowAppbar: true,
                    pageTitle: "LIVE STREAMING");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => wepage),
                );
              },
              padding: EdgeInsets.all(0.0),
              child: Image.asset('image/Youtube.png'),
            ),
            // IconButton(
            //   color: Colors.red,
            //   icon: Image.asset('image/FFacebook.png'),
            //   iconSize: 150,
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var wepage = WebViewLoad(
            //         weburl: prefs.getString('facebookUrl'),
            //         isShowAppbar: true,
            //         pageTitle: "LIVE STREAMING");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => wepage),
            //     );
            //   },
            // ),
            // IconButton(
            //   icon: Image.asset('image/Youtube.png'),
            //   iconSize: 150,
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var wepage = WebViewLoad(
            //         weburl: prefs.getString('youtubeUrl'),
            //         isShowAppbar: true,
            //         pageTitle: "LIVE STREAMING");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => wepage),
            //     );
            //   },
            // )
          ],
        ),
      )
    ]);
  }
}

class CustomHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        HeaderBackground(),
        Container(
          width: 100,
          height: 100,
          margin: EdgeInsets.only(top: 300),
          decoration: BoxDecoration(
            color: Colors.white,
            image:
                DecorationImage(image: AssetImage('image/livestreaming.png')),
            borderRadius: BorderRadius.circular(35),
          ),
        ),
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
            margin: EdgeInsets.only(top: 5),
            height: 450,
            color: Colors.white,
          ),
        ),
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 450,
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
