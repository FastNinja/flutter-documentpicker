# Dockument Picker plugin for Flutter

A Flutter plugin for iOS and Android for picking document.

_Note_: This plugin is still under development, and some APIs might not be available yet.

## Installation

First, add `documentpicker` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### iOS

Do we need add any additional permissions?

### Android

Ansdroid implementation is not completed yet

### Example

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

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

                    // the file is picked and ready for upload or for readin
                  })

            ]))));
  }
}
```
