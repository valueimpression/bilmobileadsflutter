# BilMobileAdsFlutter

A flutter plugin for integrate ValueImpressionSDK.

## Getting Started
[[pub.dev]](https://pub.dartlang.org/packages/bilmobileadsflutter)

A Flutter plugin that uses native platform views to show Banner ads!. This plugin also has support for Interstitial and Reward ads.

# Installation

- Add this to your package's pubspec.yaml file:

```yaml
dependencies:
  bilmobileadsflutter: "LATEST_VERSION"

```

- And you can install packages from the command line:

```sh
flutter pub get
```

## iOS Specific Setup
Update your `Info.plist`.
```xml
<key>GADIsAdManagerApp</key>
<true/>
```

## Android Specific Setup

### Initialize the plugin

First thing to do before attempting to show any ads is to initialize the plugin. You can do this in the earliest starting point of your app, your `main` or `initState` function:

```dart
import 'package:bilmobileadsflutter/PBMobileAds.dart';

@override
void initState() {
    super.initState();

    // Initialize SDK: testMode = true for test ads
    PBMobileAds.initialize(testMode: false);
}
```

### Supported Platforms
- iOS: >= `9.0`
- Android >= `19`

### Supported Ads for ValueImpressionSDK
- Banner Ads
- Interstitial Ads
- Reward Ads
