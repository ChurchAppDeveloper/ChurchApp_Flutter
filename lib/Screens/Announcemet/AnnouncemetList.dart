import 'package:churchapp/Screens/Announcemet/AnnouncementCreation.dart';
import 'package:churchapp/Screens/LoginPage/login_screen.dart';
import 'package:churchapp/Screens/RestService/AnnouncemetService.dart';
import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:math' as math;

class AnnouncemetList extends StatefulWidget {
  final bool isShowAppbar;
  const AnnouncemetList({Key key, this.isShowAppbar}) : super(key: key);

  @override
  _AnnouncemetListState createState() => _AnnouncemetListState();
}

class _AnnouncemetListState extends State<AnnouncemetList> {
  var isShowAppbar;
  bool _fetching;
  List<AnnouncementListItem> menus;
  var random = new math.Random();
  final List<Color> _colors = Colors.primaries;

  @override
  void initState() {
    super.initState();
    _fetching = true;
    isShowAppbar = widget.isShowAppbar;
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
    var _instance;
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                title: Text("ANNOUNCEMENT"),
                backgroundColor: Color.fromARGB(255, 219, 69, 71),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // do something
                  },
                ))
            : null,
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
            : ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    child: GestureDetector(
                      child: Container(
                        height: 120,
                        decoration: new BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(85.0)),
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
                          child: Text(
                            menus[index].title,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
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
                    ),
                  );
                },
              ),
        floatingActionButtonLocation:
            Singleton().isAdmin ? FloatingActionButtonLocation.endFloat : null,
        floatingActionButton: Singleton().isAdmin
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
}
