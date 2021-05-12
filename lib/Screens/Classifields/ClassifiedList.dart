import 'dart:math' as math;

import 'package:churchapp/Model/ClassifiedModel.dart';
import 'package:churchapp/api/classified_api.dart';
import 'package:churchapp/model_response/get_classified_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
  String role;
  Future apiClassified, getRole;

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    apiClassified = getClassifiedAPI();
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
                  ),
                ),
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
        body: FutureBuilder<ClassifiedResponse>(
          future: apiClassified,
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (projectSnap.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: projectSnap.data.content.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (projectSnap.data.content.isNotEmpty) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: Container(
                        color: Colors.white,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 219, 69, 71)
                                    .withOpacity(0.1),
                                spreadRadius: 15,
                                blurRadius: 10,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              // colors: [
                              //   _colors[random.nextInt(15)],
                              //   _colors[random.nextInt(15)]
                              // ],
                              colors: [
                                HexColor("#FB8085"),
                                HexColor("#F9C1B1")
                              ],
                              // colors: [HexColor("##FF928B"), HexColor("#FFAC81")]),
                              // colors: [HexColor("#864BA2"), HexColor("#BF3A30")],
                            ),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    projectSnap.data.content[index].businessName
                                        .toString(),
                                    textAlign: TextAlign.start,
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    )),
                                subtitle: Text(
                                    projectSnap
                                        .data.content[index].businessTypeName
                                        .toString(),
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
                                    text: projectSnap
                                        .data.content[index].phoneNumber
                                        .toString(),
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'tel:${projectSnap.data.content[index].phoneNumber.toString()}');
                                      },
                                  ),
                                ),
                              ),
                              Image(
                                image: NetworkImage(baseUrl +
                                    projectSnap
                                        .data.content[index].imagename),
                                // image: AssetImage('image/bg1.jpg'),
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.high,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                        child: SvgPicture.asset("image/nodata.svg",
                            semanticsLabel: appName));
                  }
                },
              );
            } else {
              return Text("Error ${projectSnap.error}");
            }
          },
        ),
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
