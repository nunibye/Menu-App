import 'dart:io';

String get getAdUnitId{
  if (Platform.isAndroid) {
      return '18ab7cc35';
    } else if (Platform.isIOS) {
      return '18ab9d1fd';
    }
    throw UnsupportedError("Unsupported platform");
  }