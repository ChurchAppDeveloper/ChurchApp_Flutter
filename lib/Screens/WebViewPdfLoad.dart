
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';


class WebViewPdfLoad extends StatefulWidget {
  final String weburl;
  final bool isShowAppbar;
  final String pageTitle;
  var contentDesc = "";
  final Uri url;
  var fileName;

  WebViewPdfLoad({Key key, this.weburl, this.isShowAppbar, this.pageTitle, this.url,this.fileName})
      : super(key: key);

  WebViewLoadUI createState() => WebViewLoadUI();
}

class WebViewLoadUI extends State<WebViewPdfLoad> {
  var isShowAppbar;
  var pageTitle;
  var loadwebview;
  var contentDesc = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isShowAppbar = widget.isShowAppbar;
    pageTitle = widget.pageTitle;
    contentDesc = widget.contentDesc;
    debugPrint("WebView:${widget.weburl}");
    loadwebview= SfPdfViewer.network(
        '${widget.weburl}',
        initialScrollOffset: Offset(0, 500),
        initialZoomLevel: 0);
/*    loadwebview = WebView(
      initialUrl: "${widget.weburl}",
      javascriptMode: JavascriptMode.unrestricted,

      onPageFinished: (finish) {
        setState(() {
          isLoading = false;
        });
      },
    );*/
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(" pdf: ${widget.weburl}   ");
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
          backgroundColor: Color.fromARGB(255, 219, 69, 71),
          title: Text(pageTitle),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.phone_in_talk,
                  color: Colors.white,
                ),
                onPressed: () {
                  launch(widget.url.toString());

                },
              )
            ],
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),),
        )
            : null,
        body: Stack(
          children: [
            widget.weburl != null
                ? loadwebview
                : SvgPicture.asset("image/404.svg", semanticsLabel: appName),
            /*isLoading
                ? Center(
              child: CircularProgressIndicator(),
            )
                : Container(),*/

/*
            widget.fileName==null?SvgPicture.asset("image/404.svg", semanticsLabel: appName):Container()
*/
          ],
        ));
  }
}
