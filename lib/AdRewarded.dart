import 'package:bilmobileadsflutter/AdEventsHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'Ultil.dart';

class AdRewarded extends AdEventsHandler {
  static const String PREFIX = 'bilmobileads/AdRewarded';

  static const MethodChannel _channel = MethodChannel(PREFIX);

  int id;
  final String adUnitId;
  MethodChannel _listenerChannel;
  final void Function(BilAdEvents, Map<String, dynamic>) listener;

  /// Create an Interstitial.
  ///
  /// A valid [adUnitId] is required.
  AdRewarded({
    @required this.adUnitId,
    this.listener,
  }) : super(listener) {
    id = hashCode;

    this.create();
  }

  void create() async {
    await _channel.invokeMethod('create', _channelID..['adUnitId'] = adUnitId);

    if (listener != null) {
      await _channel.invokeMethod('setListener', _channelID);

      _listenerChannel = MethodChannel(PREFIX + '_$id');
      _listenerChannel.setMethodCallHandler(handleEvent);
    }
  }

  void preLoad() async {
    if (await isReady == true) {
      print("AdRewarded '" + adUnitId + "' is ready to show.");
      return;
    }
    await _channel.invokeMethod('preLoad', _channelID);
  }

  void show() async {
    if (await isReady == false) {
      print("AdRewarded '" +
          adUnitId +
          "' currently unavailable, call preload() first.");
      return;
    }
    await _channel.invokeMethod('show', _channelID);
  }

  void destroy() async {
    await _channel.invokeMethod('destroy', _channelID);
  }

  Future<bool> get isReady async {
    final result = await _channel.invokeMethod('isReady', _channelID);
    return result;
  }

  Map<String, dynamic> get _channelID => <String, dynamic>{
        'id': id,
      };
}
