import 'package:churchapp/Screens/Classifields/ClassifiedCreate.dart';
import 'package:churchapp/Screens/Classifields/ImageZoomView.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/ClassifieldService.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ClassifiedList extends StatefulWidget {
  final bool isShowAppbar;

  ClassifiedList({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _ClassifiedListState createState() => _ClassifiedListState();
}

class _ClassifiedListState extends State<ClassifiedList> {
  var isShowAppbar;
  List<Classifield> classifields = [];
  StackedList stackedlist;
  bool _fetching;
  String role;
  Future apiClassified, getRole;

  @override
  void initState() {
    _fetching = true;
    isShowAppbar = Get.arguments;
    ClassifieldService().getClassifieldList().then((classifields) {
      setState(() {
        classifields = classifields;
        stackedlist = StackedList(
          classifields: classifields,
        );
        _fetching = false;
      });
    });
    // apiClassified = getClassifiedAPI();
    getRole = initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Classifieds"),
                backgroundColor: Color.fromARGB(255, 219, 69, 71),
            shape: ContinuousRectangleBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),),
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
        body: (_fetching)
            ? Container(
                child: Center(
                  child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 100.0,
                    color: Colors.red,
                  ),
                ),
              )
            : stackedlist,
        floatingActionButton: FutureBuilder(
            future: getRole,
            builder: (context, projectSnap) {
              if (projectSnap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (projectSnap.connectionState == ConnectionState.done) {
                return (projectSnap.data == 'Admin')
                    ? FloatingActionButton(
                        backgroundColor: Colors.red,
                        onPressed: () {
                          Get.toNamed("/classifiedCreate");
                        },
                        child: new Icon(Icons.add),
                      )
                    : Container();
              } else {
                return Text("Error ${projectSnap.error}");
              }
            }));
  }

  Future initData() async {
    return role =
        await SharedPref().getStringPref(SharedPref().role).then((value) {
      debugPrint("role: $value");

      return value;
    });
  }
}

class StackedList extends StatefulWidget {
  List<Classifield> classifields;

  StackedList({Key key, this.classifields}) : super(key: key);

  @override
  _StackedListState createState() => _StackedListState();
}

class _StackedListState extends State<StackedList>
    with TickerProviderStateMixin {
  List<Classifield> classifields;

  @override
  void initState() {
    super.initState();
    classifields = widget.classifields;
  }

  final List<Color> _colors = Colors.primaries;
  static const _minHeight = 16.0;
  static const _maxHeight = 70.0;
  static const _dynamicheight = 300.0;
  var selectedIndex = 0;
  var random = new math.Random();

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: classifields
            .map(
              (classifieldData) => StackedListChild(
                minHeight: _minHeight,
                maxHeight:
                    classifields.indexOf(classifieldData) == selectedIndex
                        ? _dynamicheight
                        : _maxHeight,
                child: Container(
                  color: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.circular(_minHeight)),
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(255, 219, 69, 71).withOpacity(0.1),
                          spreadRadius: 15,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        // colors: [
                        //   _colors[random.nextInt(15)],
                        //   _colors[random.nextInt(15)]
                        // ],
                        colors: [HexColor("#FB8085"), HexColor("#F9C1B1")],
                        // colors: [HexColor("##FF928B"), HexColor("#FFAC81")]),
                        // colors: [HexColor("#864BA2"), HexColor("#BF3A30")],
                      ),

                      // image: DecorationImage(
                      //   fit: BoxFit
                      //       .cover, //I assumed you want to occupy the entire space of the card
                      //   image: NetworkImage(classifieldData.imageName),
                      // ),
                    ),
                    child: Stack(
                      children: [
                        ListTile(
                          title: Text(classifieldData.name.toString(),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              )),
                          subtitle:
                              Text(classifieldData.businesstype.toString(),
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  )),
                          trailing: RichText(
                            text: TextSpan(
                              text: classifieldData.phonenumber.toString(),
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  launch(
                                      'tel:${classifieldData.phonenumber.toString()}');
                                },
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedIndex =
                                  classifields.indexOf(classifieldData);
                            });
                          },
                        ),
                        Positioned(
                            left: 100,
                            bottom: 80,
                            // alignment: Alignment.centerLeft,
                            // padding: EdgeInsets.all(48.0),
                            height: 150.0,
                            width: 200.0,
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     PageTransition(
                                //         alignment: Alignment.bottomCenter,
                                //         curve: Curves.easeInOut,
                                //         duration: Duration(milliseconds: 300),
                                //         reverseDuration:
                                //             Duration(milliseconds: 300),
                                //         type: PageTransitionType.bottomToTop,
                                //         child: ImageZoomView(
                                //             imageurl:
                                //                 classifieldData.imageName)));
                              },
                              child: Image(
                                image: NetworkImage(classifieldData.imageName),
                                // image: AssetImage('image/bg1.jpg'),
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      );
}

class StackedListChild extends StatelessWidget {
  final double minHeight;
  final double maxHeight;
  final bool pinned;
  final bool floating;
  final Widget child;

  SliverPersistentHeaderDelegate get _delegate => _StackedListDelegate(
      minHeight: minHeight, maxHeight: maxHeight, child: child);

  const StackedListChild({
    Key key,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
    this.pinned = false,
    this.floating = false,
  })  : assert(child != null),
        assert(minHeight != null),
        assert(maxHeight != null),
        assert(pinned != null),
        assert(floating != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => SliverPersistentHeader(
      key: key, pinned: pinned, floating: floating, delegate: _delegate);
}

class _StackedListDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StackedListDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StackedListDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
