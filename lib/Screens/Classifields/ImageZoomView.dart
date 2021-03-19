import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';

class ImageZoomView extends StatefulWidget {
  final String imageurl;
  ImageZoomView({Key key, this.imageurl}) : super(key: key);

  @override
  _ImageZoomViewState createState() => _ImageZoomViewState();
}

class _ImageZoomViewState extends State<ImageZoomView> {
  String imageurl;

  @override
  void initState() {
    super.initState();
    imageurl = widget.imageurl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DetailView'),
        backgroundColor: Color.fromARGB(255, 219, 69, 71),
      ),
      body: PinchZoom(
        image: Image.network(imageurl),
        zoomedBackgroundColor: Colors.black.withOpacity(0.5),
        resetDuration: const Duration(milliseconds: 100),
        maxScale: 2.5,
        onZoomStart: () {
          print('Start zooming');
        },
        onZoomEnd: () {
          print('Stop zooming');
        },
      ),
    );
  }
}
