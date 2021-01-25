import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:context/context.dart' as appContext;

void main() {
  const MethodChannel channel = MethodChannel('context');

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
    expect(await appContext.getPlatformVersion(), '42');
  });
}
