import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerRequest extends StatefulWidget {
  final bool isShowAppbar;
  const PrayerRequest({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _PrayerRequestState createState() => _PrayerRequestState();
}

class _PrayerRequestState extends State<PrayerRequest> {
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
              title: Text("PRAYER REQUEST"),
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
        right: 70,
        bottom: 150,
        child: ScaleAnimatedTextKit(
            repeatForever: true,
            onTap: () {
              print("Tap Event");
            },
            text: ["PRAYER REQUEST"],
            textStyle: GoogleFonts.lato(
              textStyle: TextStyle(
                  fontSize: 22, color: Colors.red, fontWeight: FontWeight.w600),
            )),
      ),
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomHeader(),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var wepage = WebViewLoad(
                    weburl: prefs.getString('prayerRequestUtl'),
                    isShowAppbar: true,
                    pageTitle: "PRAYER REQUEST");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => wepage),
                );
              },
              child: Image.asset('image/prayerlist.png'),
            ),
            // IconButton(
            //   //PrayerList
            //   color: Colors.red,
            //   icon: Image.asset('image/prayerlist.png'),
            //   iconSize: 150,
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var wepage = WebViewLoad(
            //         weburl: prefs.getString('prayerRequestUtl'),
            //         isShowAppbar: true,
            //         pageTitle: "PRAYER REQUEST");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => wepage),
            //     );
            //   },
            // ),
            // IconButton(
            //   //MassIntention
            //   icon: Image.asset('image/massintention.png'),
            //   iconSize: 150,
            //   onPressed: () async {
            //     SharedPreferences prefs = await SharedPreferences.getInstance();
            //     var wepage = WebViewLoad(
            //         weburl: prefs.getString('masstimingintention'),
            //         isShowAppbar: true,
            //         pageTitle: "PRAYER REQUEST");
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => wepage),
            //     );
            //   },
            // ),
            TextButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var wepage = WebViewLoad(
                    weburl: prefs.getString('masstimingintention'),
                    isShowAppbar: true,
                    pageTitle: "PRAYER REQUEST");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => wepage),
                );
              },
              child: Image.asset(
                'image/massintention.png',
              ),
            )
          ],
        ),
      ),
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
                DecorationImage(image: AssetImage('image/prayerrequest.png')),
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
