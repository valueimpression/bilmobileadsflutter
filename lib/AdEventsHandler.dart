import 'package:flutter/services.dart';

import 'Ultil.dart';

abstract class AdEventsHandler {
  final Function(BilAdEvents, Map<String, dynamic>) _listener;

  AdEventsHandler(Function(BilAdEvents, Map<String, dynamic>) listener)
      : _listener = listener;

  Future<dynamic> handleEvent(MethodCall call) async {
    switch (call.method) {
      case 'loaded':
        _listener(BilAdEvents.loaded, null);
        break;
      case 'opened':
        _listener(BilAdEvents.opened, null);
        break;
      case 'closed':
        _listener(BilAdEvents.closed, null);
        break;
      case 'clicked':
        _listener(BilAdEvents.clicked, null);
        break;
      case 'leftApplication':
        _listener(BilAdEvents.leftApplication, null);
        break;
      case 'rewarded':
        _listener(
            BilAdEvents.rewarded, Map<String, dynamic>.from(call.arguments));
        break;
      case 'failedToLoad':
        _listener(BilAdEvents.failedToLoad,
            Map<String, dynamic>.from(call.arguments));
        break;
      case 'failedToShow':
        _listener(BilAdEvents.failedToShow,
            Map<String, dynamic>.from(call.arguments));
        break;
    }

    return null;
  }
}
