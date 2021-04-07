/*import 'dart:math';

import 'package:churchapp/Screens/MassTiming/ArcChooser.dart';
import 'package:churchapp/Screens/MassTiming/DateTimePicker.dart';
import 'package:churchapp/Screens/MassTiming/Eucharistic.dart';
import 'package:churchapp/Screens/MassTiming/Rosary.dart';
import 'package:churchapp/Screens/MassTiming/SmilePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MassTiming extends StatefulWidget {
  MassTiming({Key key}) : super(key: key);

  @override
  _MassTimingState createState() => new _MassTimingState();
}

class _MassTimingState extends State<MassTiming> with TickerProviderStateMixin {
  final PageController pageControl = new PageController(
    initialPage: 0,
    keepPage: false,
    viewportFraction: 0.2,
  );

  int slideValue = 200;
  int lastAnimPosition = 2;

  AnimationController animation;

  List<ArcItem> arcItems = List<ArcItem>();

  ArcItem badArcItem;
  ArcItem ughArcItem;
  ArcItem okArcItem;
  ArcItem goodArcItem;

  Color startColor;
  Color endColor;

  @override
  void initState() {
    super.initState();

    badArcItem = ArcItem("WWW", [Color(0xFFfe0944), Color(0xFFfeae96)], 0.0);
    ughArcItem = ArcItem("111", [Color(0xFFF9D976), Color(0xfff39f86)], 0.0);
    okArcItem = ArcItem("sdas", [Color(0xFF21e1fa), Color(0xff3bb8fd)], 0.0);
    goodArcItem = ArcItem("dsaa", [Color(0xFF3ee98a), Color(0xFF41f7c7)], 0.0);

    arcItems.add(badArcItem);
    arcItems.add(ughArcItem);
    arcItems.add(okArcItem);
    arcItems.add(goodArcItem);

    startColor = Color(0xFF21e1fa);
    endColor = Color(0xff3bb8fd);

    animation = new AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 400.0,
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..addListener(() {
        setState(() {
          slideValue = animation.value.toInt();

          double ratio;

          if (slideValue <= 100) {
            ratio = animation.value / 100;
            startColor =
                Color.lerp(badArcItem.colors[0], ughArcItem.colors[0], ratio);
            endColor =
                Color.lerp(badArcItem.colors[1], ughArcItem.colors[1], ratio);
          } else if (slideValue <= 200) {
            ratio = (animation.value - 100) / 100;
            startColor =
                Color.lerp(ughArcItem.colors[0], okArcItem.colors[0], ratio);
            endColor =
                Color.lerp(ughArcItem.colors[1], okArcItem.colors[1], ratio);
          } else if (slideValue <= 300) {
            ratio = (animation.value - 200) / 100;
            startColor =
                Color.lerp(okArcItem.colors[0], goodArcItem.colors[0], ratio);
            endColor =
                Color.lerp(okArcItem.colors[1], goodArcItem.colors[1], ratio);
          } else if (slideValue <= 400) {
            ratio = (animation.value - 300) / 100;
            startColor =
                Color.lerp(goodArcItem.colors[0], badArcItem.colors[0], ratio);
            endColor =
                Color.lerp(goodArcItem.colors[1], badArcItem.colors[1], ratio);
          }
        });
      });

    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = new TextStyle(
        color: Colors.white, fontSize: 24.00, fontWeight: FontWeight.bold);

    return Container(
      margin: MediaQuery.of(context).padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
              // child: Rosary(),
              ),
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.width / 2) + 60),
            painter: SmilePainter(slideValue),
          ),
          Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                ArcChooser()
                  ..arcSelectedCallback = (int pos, ArcItem item) {
                    int animPosition = pos - 2;
                    if (animPosition > 3) {
                      animPosition = animPosition - 4;
                    }

                    if (animPosition < 0) {
                      animPosition = 4 + animPosition;
                    }

                    if (lastAnimPosition == 3 && animPosition == 0) {
                      animation.animateTo(4 * 100.0);
                    } else if (lastAnimPosition == 0 && animPosition == 3) {
                      animation.forward(from: 4 * 100.0);
                      animation.animateTo(animPosition * 100.0);
                    } else if (lastAnimPosition == 0 && animPosition == 1) {
                      animation.forward(from: 0.0);
                      animation.animateTo(animPosition * 100.0);
                    } else {
                      animation.animateTo(animPosition * 100.0);
                    }

                    lastAnimPosition = animPosition;
                  },
                Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    elevation: 8.0,
                    child: Container(
                        width: 150.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [startColor, endColor]),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'SUBMIT',
                          style: textStyle,
                        )),
                  ),
                )
              ]),
        ],
      ),
    );
  }
}
*/

import 'dart:math';
import 'package:churchapp/Screens/MassTiming/Eucharistic.dart';
import 'package:churchapp/Screens/MassTiming/Rosary.dart';
import 'package:churchapp/Screens/MassTiming/WeekdayPicker.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class MassTiming extends StatefulWidget {
  final bool isShowAppbar;
  const MassTiming({Key key, this.isShowAppbar}) : super(key: key);
  @override
  _MassTimingState createState() => _MassTimingState();
}

class _MassTimingState extends State<MassTiming> with TickerProviderStateMixin {
  var isShowAppbar;
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isShowAppbar = widget.isShowAppbar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("MASS TIMING"),
                backgroundColor: Color.fromARGB(255, 219, 69, 71))
            : null,
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
            child: _getPage(currentPage),
          ),
        ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(
              iconData: Icons.weekend,
              title: "Daily",
            ),
            TabData(iconData: Icons.weekend, title: "Eucharistic"),
            TabData(iconData: Icons.weekend, title: "Rosary")
          ],
          circleColor: Colors.white,
          barBackgroundColor: Color.fromARGB(255, 219, 69, 71),
          activeIconColor: Color.fromARGB(255, 219, 69, 71),
          inactiveIconColor: Colors.white,
          textColor: Colors.white,
          initialSelection: 0,
          key: bottomNavigationKey,
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ));
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return WeekdayPicker();
      case 1:
        return Eucharistic();
      case 2:
        return Rosary();
    }
  }
}

class CurvedBottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final roundingHeight = size.height * 3 / 5;
    final filledRectangle =
        Rect.fromLTRB(0, 0, size.width, size.height - roundingHeight);
    final roundingRectangle = Rect.fromLTRB(
        -5, size.height - roundingHeight * 2, size.width + 5, size.height);
    final path = Path();
    path.addRect(filledRectangle);
    path.arcTo(roundingRectangle, pi, -pi, true);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
