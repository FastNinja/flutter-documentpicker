import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:documentpicker/documentpicker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _docUrl;
  String _fileContent = "";
  @override
  initState() {
    super.initState();
  }

  Future<Null> _pickDocument() async {
    File file = await Documentpicker.pickDocument();

    debugPrint(file.path);
    try {
      // example how to read selected file content
      List<int> contents = await file.readAsBytes();
      setState(() {
        _docUrl = file.path;
        _fileContent = contents.take(20).join("");
      });
      debugPrint("Managed to read file content!");
    } on FileSystemException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<Null> _viewDocument() async {
    await Documentpicker.viewDocument(_docUrl);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Plugin example app'),
            ),
            body: new Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  new RaisedButton(
                      child: new Text("Pick a file"), onPressed: _pickDocument),
                  new Padding(
                      child: new Divider(
                        color: Colors.black,
                        height: 1.0,
                      ),
                      padding: const EdgeInsets.all(16.0)),
                  _docUrl != null ? new Text(_docUrl) : new Container(),
                  new Padding(
                      child: new Divider(
                        color: Colors.black,
                        height: 1.0,
                      ),
                      padding: const EdgeInsets.all(16.0)),
                  new RaisedButton(
                      child: new Text("View Selected"),
                      onPressed: _docUrl == null ? null : _viewDocument),
                ]))));
  }
}
