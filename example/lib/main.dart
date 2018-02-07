import 'dart:io';

import 'package:flutter/material.dart';
import 'package:documentpicker/documentpicker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _fileContent = '';

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body: new Center(
                child: new Column(children: <Widget>[
              new RaisedButton(
                  child: new Text("Pick a file"),
                  onPressed: () async {
                    File file = await Documentpicker.pickDocument();
                    debugPrint(file.path);
                    try {
                      List<int> contents = await file.readAsBytes();

                      setState(() {
                        _fileContent = contents.take(20).join("");
                      });
                      debugPrint("Managed to read file content!");
                    } on FileSystemException catch (e) {
                      debugPrint(e.message);
                      debugPrint(e.path);
                    }
                  }),
              new Text(_fileContent)
            ]))));
  }
}
