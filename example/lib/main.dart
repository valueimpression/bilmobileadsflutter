import 'dart:math';

import 'package:flutter/material.dart';

import 'package:bilmobileadsflutter/Ultil.dart';
import 'package:bilmobileadsflutter/PBMobileAds.dart';
import 'package:bilmobileadsflutter/AdBanner.dart';
import 'package:bilmobileadsflutter/AdInterstitial.dart';
import 'package:bilmobileadsflutter/AdRewarded.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AdInterstitial adInterstitial;
  AdRewarded adRewarded;

  AdBanner _smartbanner;
  AdBanner _banner320x50;

  BannerController _smartbannerController;
  BannerController _banner320x50Controller;

  @override
  void initState() {
    super.initState();

    PBMobileAds.initialize(testMode: false);

    _smartbanner = AdBanner(
      adUnitId: "13b7495e-1e87-414a-afcd-ef8a9034bd22",
      listener: (BilAdEvents event, Map<String, dynamic> args) {
        handleEvents(event, args, 'SmartBanner');
      },
      onBannerCreated: (BannerController controller) {
        _smartbannerController = controller;
      },
    );
    _banner320x50 = AdBanner(
      adUnitId: "2d0c7a48-792e-4e77-adef-c5220d947432",
      listener: (BilAdEvents event, Map<String, dynamic> args) {
        handleEvents(event, args, 'Banner320x50');
      },
      onBannerCreated: (BannerController controller) {
        _banner320x50Controller = controller;
      },
    );
  }

  void handleEvents(
      BilAdEvents event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case BilAdEvents.loaded:
        print('*** $adType Ad loaded!');
        showAlert('*** $adType Ad loaded!');
        break;
      case BilAdEvents.opened:
        print('*** $adType Ad opened!');
        showAlert('*** $adType Ad opened!');
        break;
      case BilAdEvents.closed:
        // adInterstitial.preLoad();
        print('*** $adType Ad closed!');
        showAlert('*** $adType Ad closed!');
        break;
      case BilAdEvents.clicked:
        print('*** $adType Ad clicked!');
        break;
      case BilAdEvents.leftApplication:
        print('*** $adType Ad left Application!');
        break;
      case BilAdEvents.failedToLoad:
        print('*** $adType Ad failed to load. :(');
        break;
      case BilAdEvents.failedToShow:
        print('*** $adType Ad failed to show. :(');
        break;
      case BilAdEvents.rewarded:
        print(
            '*** $adType Ad rewarded: type - ${args["type"]} | coin - ${args["coin"]}');
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            createBTN("PBMobileAds - Init", () {
              PBMobileAds.initialize(testMode: false);
            }),
            createBTN("PBMobileAds - enableCOPPA", () {
              PBMobileAds.enableCOPPA();
            }),
            createBTN("PBMobileAds - disableCOPPA", () {
              PBMobileAds.disableCOPPA();
            }),
            createBTN("PBMobileAds - setYearOfBirth", () {
              PBMobileAds.setYearOfBirth(1991);
            }),
            createBTN("PBMobileAds - setGender", () {
              PBMobileAds.setGender(BilGender.Male);
            }),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            Builder(
              builder: (BuildContext context) {
                final size = MediaQuery.of(context).size;
                final height = max(size.height * .05, 50.0);
                return Container(
                  width: size.width,
                  height: height,
                  color: Colors.amber,
                  child: _smartbanner,
                );
              },
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            Builder(
              builder: (BuildContext context) {
                final size = MediaQuery.of(context).size;
                return Container(
                  width: size.width,
                  height: 250,
                  color: Colors.amber,
                  child: _banner320x50,
                );
              },
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            createBTN("Banner - Show", () {
              _smartbannerController.show();
              _banner320x50Controller.show();
            }),
            createBTN("Banner - Hide", () {
              _smartbannerController.hide();
              _banner320x50Controller.hide();
            }),
            createBTN("Banner - GetSize", () async {
              double w = await _smartbannerController.widthInPixels;
              double h = await _smartbannerController.heightInPixels;

              double w2 = await _banner320x50Controller.widthInPixels;
              double h2 = await _banner320x50Controller.heightInPixels;

              print(
                  "BannerSize: smart: w-$w | h-$h && banner: w2-$w2 | h2-$h2");
            }),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            createBTN("Intersititial - Create", () {
              adInterstitial = new AdInterstitial(
                adUnitId: "3bad632c-26f8-4137-ae27-05325ee1b30c",
                listener: (BilAdEvents event, Map<String, dynamic> args) {
                  handleEvents(event, args, 'Interstitial');
                },
              );
            }),
            createBTN("Intersititial - Preload", () {
              adInterstitial.preLoad();
            }),
            createBTN("Intersititial - Show", () {
              adInterstitial.show();
            }),
            createBTN("Intersititial - Destroy", () {
              adInterstitial.destroy();
            }),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            createBTN("Rewarded - Create", () {
              adRewarded = new AdRewarded(
                adUnitId: "d4aa579a-1655-452b-9502-b16ed31d2a99",
                listener: (BilAdEvents event, Map<String, dynamic> args) {
                  handleEvents(event, args, 'Rewarded');
                },
              );
            }),
            createBTN("Rewarded - Preload", () {
              adRewarded.preLoad();
            }),
            createBTN("Rewarded - Show", () {
              adRewarded.show();
            }),
            createBTN("Rewarded - Destroy", () {
              adRewarded.destroy();
            }),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  showAlert(String alert) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 1),
      content: Text(alert),
      action: SnackBarAction(
        label: 'Đóng',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget createBTN(String txtBTN, Function _onPress) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      width: double.infinity,
      child: RaisedButton(
        onPressed: _onPress,
        elevation: 5.0,
        color: Colors.white,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(txtBTN),
      ),
    );
  }
}
