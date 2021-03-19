import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewLoad extends StatefulWidget {
  final String weburl;
  final bool isShowAppbar;
  final String pageTitle;
  var contentDesc = "";
  WebViewLoad({Key key, this.weburl, this.isShowAppbar, this.pageTitle})
      : super(key: key);

  WebViewLoadUI createState() => WebViewLoadUI();
}

class WebViewLoadUI extends State<WebViewLoad> {
  var isShowAppbar;
  var pageTitle;
  var loadwebview;
  var contentDesc = "";

  @override
  void initState() {
    super.initState();
    isShowAppbar = widget.isShowAppbar;
    pageTitle = widget.pageTitle;
    contentDesc = widget.contentDesc;
    loadwebview = WebView(
      initialUrl: "${widget.weburl}",
      javascriptMode: JavascriptMode.unrestricted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isShowAppbar
            ? AppBar(
                backgroundColor: Color.fromARGB(255, 219, 69, 71),
                title: Text(pageTitle),
                actions: (contentDesc.length == 0)
                    ? []
                    : <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.add_ic_call,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // do something
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.INFO,
                              body: Center(
                                child: Linkify(
                                  onOpen: _onOpen,
                                  text: contentDesc,
                                ),
                              ),
                            )..show();
                          },
                        )
                      ])
            : null,
        body: loadwebview);
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }
}
