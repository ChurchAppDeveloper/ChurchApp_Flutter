import 'dart:typed_data';

import 'package:churchapp/Screens/WebViewPdfLoad.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhotos extends StatelessWidget {
  const ViewPhotos({
    Key key,
    @required this.url,
  }) : super(key: key);

 // final String url;
  final Uint8List url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.white),
        loadingBuilder: (context, event) {
          return Container(
            child: Center(
              child: Loading(
                indicator: BallPulseIndicator(),
                size: 100.0,
                color: Colors.red,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return SvgPicture.asset("image/404.svg", semanticsLabel: appName);
        },
        imageProvider: MemoryImage(url),
      ),
    );
  }
}
