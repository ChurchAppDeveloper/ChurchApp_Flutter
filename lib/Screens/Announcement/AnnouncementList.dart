import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:churchapp/api/announcement_api.dart';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'dart:math' as math;

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({Key key}) : super(key: key);

  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  bool isShowAppbar = true;

  // bool _fetching;

  // List<AnnouncementResponse> menus;
  // var random = new math.Random();
  // final List<Color> _colors = Colors.primaries;
  String role;
  Future apiAnnouncement, getRole;

  @override
  void initState() {
    // _fetching = true;
    isShowAppbar = Get.arguments;
    apiAnnouncement = getAnnouncementAPI();
    getRole = initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Announcement",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )),
           shape: ContinuousRectangleBorder(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),),

            backgroundColor: Color.fromARGB(255, 219, 69, 71),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                    // do something
                  },
                ))
            : null,
        body: FutureBuilder<AnnouncementResponse>(
          future: apiAnnouncement,
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (projectSnap.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemCount: projectSnap.data.content.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (projectSnap.data.content.isNotEmpty) {
                    return GestureDetector(
                      child: Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                        decoration: new BoxDecoration(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                          color: Colors.white,
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
                          // gradient: LinearGradient(
                          //     begin: Alignment.centerLeft,
                          //     end: Alignment.centerRight,
                          //     colors: [Colors.white, Colors.white]),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:8.0,right:8.0, top:8.0),
                              child: Text(
                                  projectSnap.data.content[index].title
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  projectSnap.data.content[index].description
                                      .toString(),
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        // var fileeaderFormats = [
                        //   "docx",
                        //   "doc",
                        //   "xlsx",
                        //   "xls",
                        //   'pptx',
                        //   "ppt",
                        //   "pdf",
                        //   "txt"
                        // ];
                        // https://assets-barnabas.s3.us-east-2.amazonaws.com/ifkfkfkxk.pdf
                        // var fileurl =
                        //     "https://assets-barnabas.s3.us-east-2.amazonaws.com/Announcement374.pdf.application/pdf";
                        // var extension = fileurl.split('/').last;
                        // Dio dio = Dio();
                        // var dir = await getApplicationDocumentsDirectory();
                        // var localPath = "${dir.path}/" + extension;
                        // try {
                        //   await dio.download(fileurl, localPath,
                        //       onReceiveProgress: (rec, total) {
                        //     print(rec);
                        //     print(total);
                        //     if (total == rec) {
                        //       Navigator.of(context)
                        //           .push(MaterialPageRoute(builder: (ctx) {
                        //         return FileReaderPage(
                        //           filePath: localPath,
                        //         );
                        //       }));
                        //     }
                        //   });
                        // } catch (e) {
                        //   print(e);
                        // }

// "http://triggs.djvu.org/djvu-editions.com/BIBLES/DRV/Download.pdf"
// https://assets-barnabas.s3.us-east-2.amazonaws.com/Announcement374.pdf.application/pdf

                       getAnnouncementImageAPI(context,projectSnap.data.content[index].id,projectSnap.data.content[index].filename);
                      },
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
                          Get.toNamed("/announcementCreate");
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
