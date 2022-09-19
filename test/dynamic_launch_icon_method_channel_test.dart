import 'package:dynamic_launch_icon/dynamic_launch_icon.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DynamicLaunchIconPlatform platform = DynamicLaunchIconPlatform.instance;
  const MethodChannel channel = MethodChannel('dynamic_launch_icon');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
