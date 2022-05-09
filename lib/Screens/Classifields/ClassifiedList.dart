import 'dart:developer';
import 'dart:math' as math;

import 'package:churchapp/Model/ClassifiedModel.dart';
import 'package:churchapp/api/classified_api.dart';
import 'package:churchapp/model_response/get_classified_response.dart';
import 'package:churchapp/model_response/get_classified_response.dart' as classfieldResponse;
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
  List<classfieldResponse.Content> classfieldContentList=[];
  List<classfieldResponse.Content> tempClassfieldContentList=[];
  bool isDataNotFiltering=true;
  TextEditingController dataSearchController=TextEditingController();
  @override
  void initState() {
    isShowAppbar = Get.arguments;
    apiClassified = getClassifiedAPI();
  //  listenData();
    getRole = initData();
    super.initState();
  }

  listenData()
  {
    getClassifiedAPI().then((value){
      setState(() {
        tempClassfieldContentList=value.content;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Patrons"),
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 20,bottom: 10),
              child: TextFormField(
                controller: dataSearchController,
                decoration: new InputDecoration(
                  labelText: "Search...",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (al){
                  print("test enables");
                  setState(() {
                    classfieldContentList.clear();
                  });
                  if(al.isEmpty)
                    {
                      print("entered here");
                      setState(() {

                        isDataNotFiltering=true;
                      });
                    }else
                      {

                        tempClassfieldContentList.forEach((element) {
                          if(element.businessName.isCaseInsensitiveContainsAny(al) || element.businessTypeName.isCaseInsensitiveContainsAny(al) ||element.phoneNumber.isCaseInsensitiveContainsAny(al)){
                            setState(() {
                              isDataNotFiltering=false;
                              classfieldContentList.add(element);
                            });
                          }
                        });
                      }
                },

                validator: (val) {
                  if(val.length==0) {
                    return "Email cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),

            Expanded(
              child: isDataNotFiltering?FutureBuilder<ClassifiedResponse>(
                future: apiClassified,
                builder: (context, projectSnap) {
                  if (projectSnap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (projectSnap.connectionState == ConnectionState.done) {
                   // classfieldContentList=projectSnap.data.content;
                    tempClassfieldContentList=projectSnap.data.content;
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
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
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
                                          Text(
                                              "${projectSnap
                                                  .data.content[index].businessSubTypeName??''}",
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      ),
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
                                      image: NetworkImage(baseUrl3+
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
              ):ListView.builder(
                itemCount: classfieldContentList.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (classfieldContentList.isNotEmpty) {
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
                                    classfieldContentList[index].businessName
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
                                    classfieldContentList[index].businessTypeName
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
                                    text: classfieldContentList[index].phoneNumber
                                        .toString(),
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(
                                            'tel:${classfieldContentList[index].phoneNumber.toString()}');
                                      },
                                  ),
                                ),
                              ),
                              Image(
                                image: NetworkImage(baseUrl3 +
                                    classfieldContentList[index].imagename),
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
              ),
            ),
          ],
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
