import 'package:dynamic_launch_icon/src/dynamic_launch_icon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'dynamic_launch_icon_model.dart';


abstract class DynamicLaunchIconPlatform extends PlatformInterface {
  /// Constructs a DynamicIconPlatform.
  DynamicLaunchIconPlatform() : super(token: _token);

  static final Object _token = Object();

  static DynamicLaunchIconPlatform _instance = MethodChannelDynamicIcon();

  /// The default instance of [DynamicLaunchIconPlatform] to use.
  ///
  /// Defaults to [MethodChannelDynamicIcon].
  static DynamicLaunchIconPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DynamicLaunchIconPlatform] when
  /// they register themselves.
  static set instance(DynamicLaunchIconPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<List<DynamicLaunchIconModel>?> getAvailableIcons() {
    throw UnimplementedError('getAvailableIcons() has not been implemented.');
  }

  Future<String?> getActiveIconId() {
    throw UnimplementedError('getActiveIconId() has not been implemented.');
  }

  Future<void> setActiveIcon(String id) {
    throw UnimplementedError('setActiveIcon() has not been implemented.');
  }

  Stream<String?> getActiveIconIdStream() {
    throw UnimplementedError('getActiveIconId() has not been implemented.');
  }

  //! unalailable on ios version < 10.3
  Future<bool> isAvailable() {
    throw UnimplementedError('getActiveIconId() has not been implemented.');
  }
}
