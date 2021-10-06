import 'dart:convert';
import 'dart:io';

import 'package:churchapp/api/announcement_api.dart';
import 'package:churchapp/model_request/read_notification_request.dart';
import 'package:churchapp/model_response/get_announcement_response.dart';
import 'package:churchapp/util/api_constants.dart';
import 'package:churchapp/util/color_constants.dart';
import 'package:churchapp/util/shared_preference.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AnnouncementList extends StatefulWidget {
  const AnnouncementList({Key key}) : super(key: key);

  @override
  _AnnouncementListState createState() => _AnnouncementListState();
}

class _AnnouncementListState extends State<AnnouncementList> {
  bool isShowAppbar = true;
  String role;
  Future apiAnnouncement, getRole;
  ReadNotificationRequest readNotificationRequest;
  final RefreshController refreshController =
      RefreshController(initialRefresh: true);
  List<Content> announcementList = [];

  @override
  void initState() {
    isShowAppbar = Get.arguments;
    readNotificationRequest = ReadNotificationRequest();
    // apiAnnouncement = getAnnouncementAPI();
    getRole = initData();
    super.initState();
  }

  Future<bool> getAnnouncementAPI({bool keyRefresh = false}) async {
    String deviceId = await SharedPref().getStringPref(SharedPref().deviceId);
    debugPrint("deviceId: $deviceId");

    String url = "$baseUrl/getAnnouncementListMobile?deviceId=$deviceId";
    Map<String, String> requestHeaders = {
      HttpHeaders.contentTypeHeader: 'application/json',
      // HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    try {
      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      debugPrint("Announcement_response: ${response.request}");

      var data = AnnouncementResponse.fromJson(json.decode(response.body));

      debugPrint("profile_response: ${response.body}");
      if (response.statusCode == 200) {
        if (keyRefresh) {
          setState(() {
            announcementList = data.content;
            return true;
          });
        }
      } else {
        return false;
      }
    } catch (e) {
      print("error $e");
      return false;
    }
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
                  ),
                ),
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
        body:
            /* FutureBuilder<AnnouncementResponse>(
          future: apiAnnouncement,
          builder: (context, projectSnap) {
            if (projectSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (projectSnap.connectionState == ConnectionState.done) {*/
            SmartRefresher(
          controller: refreshController,
          enablePullUp: true,
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus status) {
              Widget body;
              if (status == LoadStatus.idle) {
                body = Text("pull up load");
              } else if (status == LoadStatus.loading) {
                body = CupertinoActivityIndicator(
                  animating: true,
                );
              } else if (status == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 55.0,
                child: Center(child: body),
              );
            },
          ),
          onRefresh: () async {
            final result = await getAnnouncementAPI(keyRefresh: true);
            if (result != null) {
              debugPrint("onRefresh$result");

              refreshController.refreshCompleted();
            } else {
              refreshController.refreshFailed();
            }
          },
          onLoading: () async {
            final result = await getAnnouncementAPI();
            if (result != null) {
              debugPrint("onLoading$result");
              refreshController.loadComplete();
            } else {
              refreshController.loadFailed();
            }
          },
          child: ListView.builder(
            itemCount: announcementList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              if (announcementList.isNotEmpty) {
                var uri = Uri.parse(announcementList[index].description);
                debugPrint("URL :$uri");
                return GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 15, top: 10),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color:
                              Color.fromARGB(255, 219, 69, 71).withOpacity(0.1),
                          spreadRadius: 15,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      // gradient: LinearGradient(
                      //     begin: Alignment.centerLeft,
                      //     end: Alignment.centerRight,
                      //     colors: [Colors.white, Colors.white]),
                    ),
                    child: ListTile(
                      leading: announcementList[index].readStatus == true
                          ? Icon(
                              Icons.mark_email_read,
                              size: 40,
                            )
                          : Icon(Icons.mark_email_unread,
                              size: 40, color: errorColor),
                      title: Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8.0, top: 8.0),
                        child: Text(
                            announcementList[index]
                                .title
                                .toString()
                                .capitalizeFirst,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            )),
                      ),
                      subtitle: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Linkify(
                            /*onOpen: (link) async {
                                        if (await canLaunch(link.url)) {
                                          await launch(link.url);
                                        } else {
                                          throw 'Could not launch $link';
                                        }
                                      },*/
                            text: uri.toString(),
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                            linkStyle: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.blue,
                              ),
                            ),
                          )
/*                              child:Text(
                                      projectSnap.data.content[index].description
                                          .toString(),
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ))*/
                          ),
                    ),
                  ),
                  onTap: () async {
                    readNotificationRequest.announcementId =
                        announcementList[index].id;
                    readNotificationRequest.status = true;
                    // announcementList[index].readStatus = true;
                    readNotificationAPI(
                        readNotificationRequest, refreshController);
                    getAnnouncementImageAPI(context, announcementList[index].id,
                        announcementList[index].filename, uri);
                  },
                );
              } else {
                return Center(
                    child: SvgPicture.asset("image/nodata.svg",
                        semanticsLabel: appName));
              }
            },
          ),
        ),
        /*     } else {
              return Text("Error ${projectSnap.error}");
            }
          },
        ),*/

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
