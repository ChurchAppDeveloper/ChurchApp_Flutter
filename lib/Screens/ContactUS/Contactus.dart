import 'dart:async';
import 'dart:io';

import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mailto/mailto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUS extends StatefulWidget {
  @override
  State<ContactUS> createState() => ContactUSState();
}

class ContactUSState extends State<ContactUS> {
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.83104, -118.17676),
    zoom: 16.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(33.83104, -118.17676),
      tilt: 59.440717697143555,
      zoom: 51.151926040649414);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child: GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: true,
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: MediaQuery
              .of(context)
              .size
              .height / 8,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'For more details about the app please contact \n Maryam Tech LLC',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  )),
            ),
          ),
        ),
      ]),
      floatingActionButton: FabCircularMenu(
        ringWidth: 100,
        ringColor: Color.fromARGB(255, 219, 69, 71),
        fabCloseColor: Color.fromARGB(255, 219, 69, 71),
        fabOpenColor: Color.fromARGB(255, 219, 69, 71),
        fabColor: Color.fromARGB(255, 219, 69, 71),
        alignment: Alignment.bottomLeft,
        children: [
          IconButton(
              alignment: Alignment.topLeft,
              iconSize: 0,
              color: Colors.white,
              icon: Icon(Icons.home),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller
                    .animateCamera(CameraUpdate.newCameraPosition(_kLake));
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.home),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller
                    .animateCamera(CameraUpdate.newCameraPosition(_kLake));
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.call),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                launch("tel://" + prefs.getString("phoneNumber"));
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.email),
              onPressed: () async {
                openMailApp(context);
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: Icon(Icons.web),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var bulletin = WebViewLoad(
                    weburl: prefs.getString("websiteUrl"),
                    isShowAppbar: true,
                    pageTitle: "ST. Barnabas");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bulletin),
                );
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: new Image.asset("image/contactusFB.png"),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(prefs.getString("facebookUrl"));
                var bulletin = WebViewLoad(
                    weburl: prefs.getString("facebookUrl"),
                    isShowAppbar: true,
                    pageTitle: "Facebook");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bulletin),
                );
              })
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  Future<void> openMailApp(BuildContext context) async {
    final mailto = Mailto(
      to: [
        'church@stbarnabaslb.org',
      ],
      // cc: [
      //   'percentage%100@example.com',
      //   'QuestionMark?address@example.com',
      // ],
      // bcc: [
      //   'Mike&family@example.org',
      // ],
      subject: 'ST.Barnabas',
      body: 'Hello this is the Church 🤪💙👍',
    );

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 3000);
    String renderHtml(Mailto mailto) =>
        '''<html><head><title>mailto example</title></head><body><a href="$mailto">Open mail client</a></body></html>''';
    await for (HttpRequest request in server) {
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.html
        ..write(renderHtml(mailto));
      await request.response.close();
    }
  }
}
