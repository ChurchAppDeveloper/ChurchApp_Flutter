import 'package:churchapp/Screens/Announcement/AnnouncementCreation.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/AnnouncemetService.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as math;

class AnnouncementList extends StatefulWidget {

  const AnnouncementList({Key key}) : super(key: key);

  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  bool isShowAppbar = true;
  bool _fetching;
  List<AnnouncementListItem> menus;
  var random = new math.Random();
  final List<Color> _colors = Colors.primaries;
  var role;

  @override
  void initState() {
    _fetching = true;
    isShowAppbar = Get.arguments;

    initData();
    debugPrint("Role: ${role.toString()}");
    super.initState();
    AnnouncementService().getAnnouncementModel().then((announcemets) {
      setState(() {
        menus = announcemets;
        print("object $announcemets");
        _fetching = false;
      });
    });
  }

  List<Color> colours = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("Announcement"),
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
        body: (_fetching)
            ? Container(
                child: Center(
                  child: Loading(
                    indicator: BallPulseIndicator(),
                    size: 80.0,
                    color: Colors.red,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      height: 100,
                      margin: EdgeInsets.only(left:15, right: 15, top: 10),
                      decoration: new BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(15.0)),
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
                      child: Center(
                        child:Text(menus[index].title.toString(),
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            )),
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
                      var bulletin = WebViewLoad(
                          weburl: menus[index].mediaUrl,
                          isShowAppbar: true,
                          pageTitle: "ANNOUNCEMENT DETAIL");
                      var content = menus[index].content;
                      if (content == null) {
                        content = "";
                      }
                      bulletin.contentDesc = content;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => bulletin),
                      );
                    },
                  );
                },
              ),
        floatingActionButtonLocation:
           role =='Admin' ? FloatingActionButtonLocation.endFloat : null,
        floatingActionButton: role =='Admin'
            ? FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          type: PageTransitionType.bottomToTop,
                          child: AnnouncemetCreation()));
                },
                child: new Icon(Icons.add),
              )
            : null);
  }

  void initData() async{
   role = await SharedPref().getStringPref(SharedPref().role).then((value) {
     debugPrint("role: $value");
     return value;
   } );

  }
}
