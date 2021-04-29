import 'package:flutter/material.dart';
import 'package:flutter_filereader/flutter_filereader.dart';

class FileReaderPage extends StatefulWidget {
  final String filePath;

  FileReaderPage({Key: Key, this.filePath});

  @override
  _FileReaderPageState createState() => _FileReaderPageState();
}

class _FileReaderPageState extends State<FileReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
        backgroundColor: Color.fromARGB(255, 219, 69, 71),
      ),
      body: FileReaderView(
        filePath: widget.filePath,
      ),
    );
  }
}
