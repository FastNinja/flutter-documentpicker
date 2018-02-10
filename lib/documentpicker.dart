import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class Documentpicker {
  static const MethodChannel _channel = const MethodChannel('documentpicker');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion');

  static Future<Null> viewDocument(String documentUrl) async {
    if (documentUrl == null || documentUrl == "") {
      throw new ArgumentError.value(
          documentUrl, 'docUrl can\'t be null or empty');
    }

    await _channel.invokeMethod(
      'viewDocument',
      <String, dynamic>{
        'documentUrl': documentUrl,
      },
    );
  }

  static Future<File> pickDocument() async {
    // if (maxWidth != null && maxWidth < 0) {
    //   throw new ArgumentError.value(maxWidth, 'maxWidth can\'t be negative');
    // }

    // if (maxHeight != null && maxHeight < 0) {
    //   throw new ArgumentError.value(maxHeight, 'maxHeight can\'t be negative');
    // }

    final String path = await _channel.invokeMethod(
      'pickDocument',
      <String, dynamic>{
        'source': "from",
      },
    );

    return new File(path);
  }
}
