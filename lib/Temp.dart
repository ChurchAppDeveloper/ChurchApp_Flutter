import 'dart:developer';

import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class Temp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Base64 String',
      theme: ThemeData(

        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}


class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State {
   String _base64="";

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(Uri.parse("http://3.208.178.159:9876/barnabas/getannouncementImage?announcementid=148&fileName=img_announcement.png"),
      );
      if (mounted) {
        setState(() {
          Map map=json.decode(response.body);
          log("base 64 is ${ map['content']}");
          _base64 = map['content'];//Base64Encoder().convert(response.bodyBytes);

        });
      }
    })();
  }

  @override
  Widget build(BuildContext context) {
    if (_base64 == null||_base64.isEmpty)
      return new Container();
    Uint8List bytes = Base64Codec().decode(_base64);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Base64 String'),
        backgroundColor: Colors.orange,),
      body: Container(
          child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    child: Image.memory(bytes,fit: BoxFit.cover,)),
              ))),


    );
  }
}