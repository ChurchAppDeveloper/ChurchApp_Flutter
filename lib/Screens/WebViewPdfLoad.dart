import 'package:churchapp/util/string_constants.dart';
import 'package:churchapp/widgets/view_empty.dart';
import 'package:churchapp/widgets/view_photos.dart';
import 'package:churchapp/widgets/view_videos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:path/path.dart' as p;
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewPdfLoad extends StatefulWidget {
  final String weburl;
  final bool isShowAppbar;
  final String pageTitle;
  var contentDesc = "";
  final Uri url;
  var fileName;

  WebViewPdfLoad(
      {Key key,
      this.weburl,
      this.isShowAppbar,
      this.pageTitle,
      this.url,
      this.fileName})
      : super(key: key);

  WebViewLoadUI createState() => WebViewLoadUI();
}

class WebViewLoadUI extends State<WebViewPdfLoad> {
  var isShowAppbar;
  var pageTitle;
  var loadView;
  var contentDesc = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    isShowAppbar = widget.isShowAppbar;
    pageTitle = widget.pageTitle;
    contentDesc = widget.contentDesc;
    debugPrint("WebView:${widget.weburl}");
    if(widget.fileName!=null){
      var extension = p.extension(widget.fileName);
      debugPrint("extension:$extension");
      switch (extension) {
        case '.pdf':
          loadView = SfPdfViewer.network('${widget.weburl}',
              enableDoubleTapZooming: true,
              enableDocumentLinkAnnotation: true,
              onDocumentLoadFailed: (details) {
                return SvgPicture.asset("image/404.svg", semanticsLabel: appName);
              },
              initialScrollOffset: Offset(0, 500),
              initialZoomLevel: 0);
          break;
        case '.png':
          loadView = ViewPhotos(url: widget.weburl);
          break;
        case '.jpg':
          loadView = ViewPhotos(url: widget.weburl);
          break;
        case '.jpeg':
          loadView = ViewPhotos(url: widget.weburl);
          break;
        case '.mp4':
          loadView = ViewVideos(url: widget.weburl);
          break;
      }
    }else{
      loadView=ViewEmpty();
    }

  }

  @override
  Widget build(BuildContext context) {
    debugPrint("url: ${widget.weburl}");
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
                  ),
                ),
              )
            : null,
        body: Stack(
          children: [
            widget.weburl != null && widget.fileName!=null
                ? loadView
                : SvgPicture.asset("image/404.svg", semanticsLabel: appName),
          ],
        ));
  }
}
