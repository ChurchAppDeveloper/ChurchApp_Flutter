import 'dart:async';
import 'dart:io';

import 'package:churchapp/Screens/WebViewLoad.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUS extends StatefulWidget {
  @override
  State<ContactUS> createState() => ContactUSState();
}

class ContactUSState extends State<ContactUS> {
  Completer<GoogleMapController> _controller = Completer();
  TapGestureRecognizer _myTapGestureRecognizer;

  var isShowAppbar = true;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.8309373, -118.1769412),
    zoom: 19.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(33.8309373, -118.1769412),
      tilt: 59.440717697143555,
      zoom: 19.0);

  @override
  void initState() {
    super.initState();
    _myTapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        openMailAppContact(context);
      };
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: isShowAppbar
          ? AppBar(
              title: Text("Contact Us"),
              backgroundColor: Color.fromARGB(255, 219, 69, 71),
          shape: ContinuousRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),),
              leading: IconButton(
                // iconSize: 50.0,
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.back();
                  // do something
                },
              ))
          : Container(),
      body: Stack(children: <Widget>[
        Container(
          child: GoogleMap(
            myLocationEnabled: true,
            buildingsEnabled: true,
            compassEnabled: true,
            indoorViewEnabled: true,
            rotateGesturesEnabled: true,
            zoomGesturesEnabled: true,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        Positioned(
          left: 0.0,
          bottom: MediaQuery.of(context).size.height / 6.3,
          child: FittedBox(
            fit: BoxFit.contain,
            child:Padding(
              padding: const EdgeInsets.only(top:8.0,left: 16,right: 8),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text:"For more details about the app please contact \n Maryam Tech LLC",
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        )),
                    TextSpan(
                        text: "  info@maryamtech.com",
                        recognizer: _myTapGestureRecognizer,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
      floatingActionButton: FabCircularMenu(
        ringWidth: 100,
        ringColor: Colors.redAccent.shade100,
        fabCloseColor: Color.fromARGB(255, 219, 69, 71),
        fabOpenColor: Color.fromARGB(255, 219, 69, 71),
        fabColor: Color.fromARGB(255, 219, 69, 71),
        alignment: Alignment.bottomLeft,

        children: [
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon:  SvgPicture.asset('image/church_colored.svg',width: 50,height: 50,),
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                controller
                    .animateCamera(CameraUpdate.newCameraPosition(_kLake));
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: SvgPicture.asset('image/phone_call.svg',width: 50,height: 50,),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                debugPrint("MobileNumber:${prefs.getString("phoneNumber").toString()}");
                launch(
                    'tel:${prefs.getString("phoneNumber").toString()}');
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: SvgPicture.asset('image/mail.svg',width: 50,height: 50,),
              onPressed: () async {
                openMailApp(context);
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: SvgPicture.asset('image/web.svg',width: 50,height: 50,),
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
              icon:  SvgPicture.asset('image/facebook.svg',width: 50,height: 50,),
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
              }),
          IconButton(
              iconSize: 30,
              color: Colors.white,
              icon: SvgPicture.asset('image/youtube.svg',width: 50,height: 50,),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(prefs.getString("youtubeUrl"));
                var bulletin = WebViewLoad(
                    weburl: prefs.getString("youtubeUrl"),
                    isShowAppbar: true,
                    pageTitle: "Youtube");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bulletin),
                );
              })
        ],
      ),
    );
  }

  Future<void> openMailApp(BuildContext context) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'church@stbarnabaslb.org',
        queryParameters: {
          'subject': 'ST.Barnabas'
        }

    );

    launch(_emailLaunchUri.toString());

  }

  Future<void>  openMailAppContact(BuildContext context) async{
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'info@maryamtech.com',
        queryParameters: {
          'subject': 'ST.Barnabas'
        }

    );

    launch(_emailLaunchUri.toString());


  }
}
