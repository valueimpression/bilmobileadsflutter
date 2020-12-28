import 'package:bilmobileadsflutter/AdEventsHandler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'Ultil.dart';

class AdBanner extends StatefulWidget {
  final String adUnitId;
  final void Function(BilAdEvents, Map<String, dynamic>) listener;
  final void Function(BannerController) onBannerCreated;

  AdBanner({
    Key key,
    this.adUnitId,
    this.listener,
    this.onBannerCreated,
  }) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  static const String PREFIX = 'bilmobileads/AdBanner';

  final UniqueKey _uniKey = UniqueKey();
  BannerController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Size>(
      future: Future.value(Size(1, 1)),
      builder: (context, snapshot) {
        final adSize = snapshot.data;
        if (adSize == null) return SizedBox.shrink();

        if (defaultTargetPlatform == TargetPlatform.android) {
          return SizedBox.fromSize(
            size: adSize,
            child: AndroidView(
              key: _uniKey,
              viewType: PREFIX,
              creationParams: _bannerParams,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          return SizedBox.fromSize(
            size: adSize,
            child: UiKitView(
              key: _uniKey,
              viewType: PREFIX,
              creationParams: _bannerParams,
              creationParamsCodec: const StandardMessageCodec(),
              onPlatformViewCreated: _onPlatformViewCreated,
            ),
          );
        }
        return Text('$defaultTargetPlatform is not supported by the plugin.');
      },
    );
  }

  void _onPlatformViewCreated(int id) {
    _controller = BannerController(id, PREFIX, widget.listener);

    if (widget.onBannerCreated != null) {
      widget.onBannerCreated(_controller);
    }
  }

  Map<String, dynamic> get _bannerParams =>
      <String, dynamic>{"adUnitId": widget.adUnitId};
}

class BannerController extends AdEventsHandler {
  final MethodChannel _channel;

  BannerController(int id, String prefix,
      Function(BilAdEvents, Map<String, dynamic>) listener)
      : _channel = MethodChannel(prefix + '_$id'),
        super(listener) {
    if (listener != null) {
      _channel.invokeMethod('setListener');
      _channel.setMethodCallHandler(handleEvent);
    }
  }

  void show() {
		_channel.invokeMethod('show');
	}

  void hide() {
    _channel.invokeMethod('hide');
  }

  Future<double> get widthInPixels async {
    final result = await _channel.invokeMethod('widthInPixels');
    return result;
  }

  Future<double> get heightInPixels async {
    final result = await _channel.invokeMethod('heightInPixels');
    return result;
  }

  void destroy() {
    _channel.invokeMethod('destroy');
  }
}
