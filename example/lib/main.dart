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
  static const String _bannerID = "ff76160c-5978-4171-b7a7-5cadf8fc9712";
  static const String _interstitialID = "cd228c7d-a17e-4546-bc3c-f3c4971d416e";
  static const String _rewardedID = "3590bf71-0ec3-4f49-b4ae-0720e359d4a3";

  late AdInterstitial adInterstitial;
  late AdRewarded adRewarded;

  late AdBanner _banner;
  late BannerController _bannerController;

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
        // key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            createBTN(ElevatedButton(
                onPressed: () {
                  PBMobileAds.initialize(testMode: false);
                },
                child: const Text("PBMobileAds - Init"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  PBMobileAds.enableCOPPA();
                },
                child: const Text("PBMobileAds - enableCOPPA"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  PBMobileAds.disableCOPPA();
                },
                child: const Text("PBMobileAds - disableCOPPA"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  PBMobileAds.setYearOfBirth(1991);
                },
                child: const Text("PBMobileAds - setYearOfBirth"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  PBMobileAds.setGender(BilGender.Male);
                },
                child: const Text("PBMobileAds - setGender"))),
            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),

            createBTN(ElevatedButton(
                onPressed: () {
                  _bannerController.show();
                },
                child: const Text("Banner - Show"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  _bannerController.hide();
                },
                child: const Text("Banner - Hide"))),
            createBTN(ElevatedButton(
                onPressed: () async {
                  double w = await _bannerController.widthInPixels;
                  double h = await _bannerController.heightInPixels;

                  print("BannerSize: banner: w-$w | h-$h");
                },
                child: const Text("Banner - GetSize"))),

            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),

            createBTN(ElevatedButton(
                onPressed: () {
                  adInterstitial = AdInterstitial(
                    adUnitId: _interstitialID,
                    listener: (BilAdEvents event, Map<String, dynamic> args) {
                      handleEvents(event, args, 'Interstitial');
                    },
                  );
                },
                child: const Text("Intersititial - Create"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adInterstitial.preLoad();
                },
                child: const Text("Interstitial - Preload"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adInterstitial.show();
                },
                child: const Text("Interstitial - Show"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adInterstitial.destroy();
                },
                child: const Text("Interstitial - Destroy"))),

            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),

            createBTN(ElevatedButton(
                onPressed: () {
                  adRewarded = AdRewarded(
                    adUnitId: _rewardedID,
                    listener: (BilAdEvents event, Map<String, dynamic> args) {
                      handleEvents(event, args, 'Rewarded');
                    },
                  );
                },
                child: const Text("Rewarded - Create"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adRewarded.preLoad();
                },
                child: const Text("Rewarded - Preload"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adRewarded.show();
                },
                child: const Text("Rewarded - Show"))),
            createBTN(ElevatedButton(
                onPressed: () {
                  adRewarded.destroy();
                },
                child: const Text("Rewarded - Destroy"))),

            const SizedBox(height: 10),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  showAlert(String alert) {
    final snackBar = SnackBar(
      duration: const Duration(seconds: 1),
      content: Text(alert),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // _scaffoldKey.currentState!.hidhideCurrentSnackBar();
    // _scaffoldKey.currentState!.showSnackBar(snackBar);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget createBTN(Widget widget) {
    // Function onPress
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
      ),
      width: double.infinity,
      child: widget,
      // child: RaisedButton(
      //   onPressed: _onPress,
      //   elevation: 5.0,
      //   color: Colors.white,
      //   padding: EdgeInsets.all(15.0),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      //   child: Text(txtBTN),
      // ),
    );
  }
}
