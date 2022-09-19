import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dynamic_launch_icon_model.dart';
import 'dynamic_launch_icon_platform_interface.dart';

/// An implementation of [DynamicLaunchIconPlatform] that uses method channels.
class MethodChannelDynamicIcon extends DynamicLaunchIconPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('dynamic_icon');

  final _eventController = StreamController<String?>.broadcast();

  @override
  Future<List<DynamicLaunchIconModel>?> getAvailableIcons() async {
    return (await methodChannel
            .invokeListMethod<Map>('getAvailableDynamicIcons'))
        ?.map((e) => DynamicLaunchIconModel.fromMap(e))
        .toList();
  }

  @override
  Future<String?> getActiveIconId() {
    return methodChannel.invokeMethod<String>('getActiveDynamicIcon');
  }

  @override
  Future<void> setActiveIcon(String id) async {
    await methodChannel.invokeMethod('setActiveDynamicIcon', id);
    _eventController.sink.add(id);
  }

  @override
  Stream<String?> getActiveIconIdStream() {
    getActiveIconId().then((value) {
      _eventController.sink.add(value);
    });
    return _eventController.stream;
  }

  @override
  Future<bool> isAvailable() async {
    return (await methodChannel
            .invokeMethod<bool>('getDynamicIconsAvailableState')) ??
        false;
  }
}
