import 'package:flutter_test/flutter_test.dart';
import 'package:dynamic_launch_icon/dynamic_launch_icon.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDynamicLaunchIconPlatform
    with MockPlatformInterfaceMixin
    implements DynamicLaunchIconPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DynamicLaunchIconPlatform initialPlatform = DynamicLaunchIconPlatform.instance;

  test('$MethodChannelDynamicLaunchIcon is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDynamicLaunchIcon>());
  });

  test('getPlatformVersion', () async {
    DynamicLaunchIcon dynamicLaunchIconPlugin = DynamicLaunchIcon();
    MockDynamicLaunchIconPlatform fakePlatform = MockDynamicLaunchIconPlatform();
    DynamicLaunchIconPlatform.instance = fakePlatform;

    expect(await dynamicLaunchIconPlugin.getPlatformVersion(), '42');
  });
}
