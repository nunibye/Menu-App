import 'dart:io';

String get getAdUnitId{
  if (Platform.isAndroid) {
      return 'ca-app-pub-1893777311600512/8265461657';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1893777311600512/1538409384';
    }
    throw UnsupportedError("Unsupported platform");
  }