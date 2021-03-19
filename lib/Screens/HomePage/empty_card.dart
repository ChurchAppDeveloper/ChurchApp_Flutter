import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String imagename;

  const EmptyCard({
    Key key,
    this.width,
    this.height,
    this.title,
    this.imagename,
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
            child: Image.asset(imagename, width: 300, height: 300),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                title.toUpperCase(),
                style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0),
              )),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(70),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.red[100].withOpacity(0.75),
            // offset: Offset(1.0, 6.0), //(x,y)
            // spreadRadius: 20,
            blurRadius: 20.0,
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
            colors: [Colors.white, Colors.white70]),
      ),
    );
  }
}
