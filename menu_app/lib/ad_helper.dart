import 'dart:io';

String get getAdUnitId{
  if (Platform.isAndroid) {
      return 'e1fa1a7321d6419f';
    } else if (Platform.isIOS) {
      return '0de5490ded2e98f7';
    }
    throw UnsupportedError("Unsupported platform");
  }