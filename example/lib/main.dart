import 'dart:math';

import 'package:flutter/material.dart';
import 'package:bilmobileadsflutter/bilmobileadsflutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

	static final String _bannerID = "1001";
	static final String _interstitialID = "1002";
	static final String _rewardedID = "1003";

  AdInterstitial adInterstitial;
  AdRewarded adRewarded;

  AdBanner _banner;
  BannerController _bannerController;

  @override
  void initState() {
    super.initState();

    PBMobileAds.initialize(testMode: false);

    _banner = AdBanner(
      adUnitId: _bannerID,
      listener: (BilAdEvents event, Map<String, dynamic> args) {
        handleEvents(event, args, 'Banner');
      },
      onBannerCreated: (BannerController controller) {
        _bannerController = controller;
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
                  child: _banner,
                );
              },
            ),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            createBTN("Banner - Show", () {
              _bannerController.show();
            }),
            createBTN("Banner - Hide", () {
              _bannerController.hide();
            }),
            createBTN("Banner - GetSize", () async {
              double w = await _bannerController.widthInPixels;
              double h = await _bannerController.heightInPixels;

              print(
                  "BannerSize: banner: w-$w | h-$h");
            }),
            SizedBox(height: 10),
            Divider(color: Colors.black),
            SizedBox(height: 10),
            createBTN("Intersititial - Create", () {
              adInterstitial = new AdInterstitial(
                adUnitId: _interstitialID,
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
                adUnitId: _rewardedID,
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
