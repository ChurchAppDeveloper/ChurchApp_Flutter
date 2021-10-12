import 'package:churchapp/Screens/WebViewPdfLoad.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:photo_view/photo_view.dart';

class ViewEmpty extends StatelessWidget {
  const ViewEmpty({
    Key key, this.url,
  }) : super(key: key);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SvgPicture.asset("image/404.svg", semanticsLabel: appName)
    );
  }
}
