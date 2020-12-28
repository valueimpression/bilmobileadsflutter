import 'package:flutter/services.dart';
import 'package:bilmobileadsflutter/Ultil.dart';

class PBMobileAds {
  static const MethodChannel _channel =
      MethodChannel('bilmobileads/PBMobileAds');

  PBMobileAds.initialize({bool testMode}) {
    _channel.invokeMethod('initialize', testMode);
  }

  PBMobileAds.enableCOPPA() {
    _channel.invokeMethod("enableCOPPA");
  }

  PBMobileAds.disableCOPPA() {
    _channel.invokeMethod("disableCOPPA");
  }

  PBMobileAds.setYearOfBirth(int yearOfBirth) {
    _channel.invokeMethod("setYearOfBirth", yearOfBirth);
  }

  PBMobileAds.setGender(BilGender gender) {
    switch (gender) {
      case BilGender.Unknown:
        _channel.invokeMethod("setGender", 0);
        break;
      case BilGender.Male:
        _channel.invokeMethod("setGender", 1);
        break;
      case BilGender.Female:
        _channel.invokeMethod("setGender", 2);
        break;
    }
  }
}
