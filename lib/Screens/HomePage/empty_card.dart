import 'package:cached_network_image/cached_network_image.dart';
import 'package:churchapp/util/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyCard extends StatelessWidget {
  final double width;
  final double height;
  // final String title;
  final String imagename;
 final int index;
  const EmptyCard({
    Key key,
    this.width,
    this.height,
    // this.title,
    this.imagename,
    this.index
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: width,
      // height: height,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(top: 20.0),
            child: /*Image.network(
              imagename,
              key: ValueKey<int>(index),
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
            )*///Image.network(imagename, width: 150,height: 150,)
            CachedNetworkImage(
              imageUrl: imagename,
              height: 150,
              width: 150,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                   //   height: 50,width: 50,
                      margin: EdgeInsets.all(50),
                      child: CircularProgressIndicator(value: downloadProgress.progress,)),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
/*          Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Text(title.toUpperCase(),
                textAlign: TextAlign.start,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )),
          )*/
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.red[100].withOpacity(0.85),
            // offset: Offset(1.0, 6.0), //(x,y)
            // spreadRadius: 20,
            blurRadius: 10.0,
          ),
        ],
        // border: Border.all(
        //     width: 1, color: Colors.red[100], style: BorderStyle.solid),
        // boxShadow: <BoxShadow>[
        //   BoxShadow(
        //     color: Colors.white,
        //     blurRadius: 4.0,
        //     offset: const Offset(0.0, 4.0),
        //   ),
        // ],
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.red[50].withOpacity(0.5),
        //     spreadRadius: 15,
        //     blurRadius: 17,
        //     offset: Offset(0, 3), // changes position of shadow
        //   ),
        // ],
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.white, Colors.white]),
      ),
    );
  }
}
