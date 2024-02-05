import 'package:flutter/services.dart';

import 'Ultil.dart';

abstract class AdEventsHandler {
  final Function(BilAdEvents, Map<String, dynamic>) _listener;

  AdEventsHandler(Function(BilAdEvents, Map<String, dynamic>) listener)
      : _listener = listener;

  Future<dynamic> handleEvent(MethodCall call) async {
    Map<String, dynamic> data = Map<String, dynamic>.from(call.arguments);
    switch (call.method) {
      case 'loaded':
        _listener(BilAdEvents.loaded, data);
        break;
      case 'opened':
        _listener(BilAdEvents.opened, data);
        break;
      case 'closed':
        _listener(BilAdEvents.closed, data);
        break;
      case 'clicked':
        _listener(BilAdEvents.clicked, data);
        break;
      case 'leftApplication':
        _listener(BilAdEvents.leftApplication, data);
        break;
      case 'rewarded':
        _listener(BilAdEvents.rewarded, data);
        break;
      case 'failedToLoad':
        _listener(BilAdEvents.failedToLoad, data);
        break;
      case 'failedToShow':
        _listener(BilAdEvents.failedToShow, data);
        break;
    }
    return null;
  }
}
