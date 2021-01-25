import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:context/src/intent.dart';
import 'package:context/src/package_info.dart';
import 'package:context/src/resolve_info.dart';

final _broadcastReceiverController = StreamController<Intent>();

Future<dynamic> _platformCallHandler(MethodCall call) async {
  final Map<String, dynamic> json = Map.from(call.arguments);

  final intent = Intent.fromJson(json);
  _broadcastReceiverController.add(intent);
}

final packageManager = PackageManager._();
final wallpaperManager = WallpaperManager._();

final MethodChannel _channel = MethodChannel('context')
  ..setMethodCallHandler(_platformCallHandler);

Stream<Intent> get broadcastReceiver => _broadcastReceiverController.stream;

class PackageManager {
  PackageManager._();

  Future<ResolveInfo> resolveActivity(Intent intent) async {
    final result = await _channel.invokeMethod(
        'packageManager.resolveActivity', intent.toJson());
    return ResolveInfo.fromJson(Map.from(result));
  }

  Future<List<ResolveInfo>> queryIntentActivities(Intent intent) async {
    final result = await _channel.invokeMethod(
        'packageManager.queryIntentActivities', intent.toJson());

    final list = List.from(result);

    final val = list.map((e) => Map.from(e)).map(
          (e) => ResolveInfo.fromJson(
            Map<String, dynamic>.from(e),
          ),
        );

    return val.toList();
  }

  Future<List<String>> getPackagesForUid(int uid) async {
    final List<String> packages =
        await _channel.invokeMethod('packageManager.getPackagesForUid', uid);
    return packages;
  }

  Future<PackageInfo> getPackageInfo(String packageName) async {
    final packageInfo = await _channel.invokeMethod(
        'packageManager.getPackageInfo', packageName);
    return PackageInfo.fromJson(Map.from(packageInfo));
  }
}

class WallpaperManager {
  WallpaperManager._();

  Future<void> setWallpaperOffsets(double xOffset, double yOffset) async {
    final Map<String, Object> map = {'xOffset': xOffset, 'yOffset': yOffset};

    await _channel.invokeMethod('wallpaperManager.setWallpaperOffsets', map);
  }

  Future<void> setWallpaperOffsetSteps(double xStep, double yStep) async {
    final Map<String, Object> map = {'xStep': xStep, 'yStep': yStep};

    await _channel.invokeMethod(
        'wallpaperManager.setWallpaperOffsetSteps', map);
  }
}

class AppWidgetHost {
  final int hostId;
  final int reference;

  AppWidgetHost._(this.reference, this.hostId);

  static Future<AppWidgetHost> create(int hostId) async {
    final reference =
        await _channel.invokeMethod<int>('Objects.AppWidgetHost', hostId);
    return AppWidgetHost._(reference, hostId);
  }

  Future<int> allocateAppWidgetId() async {
    return _channel.invokeMethod(
        'Objects.AppWidgetHost.allocateAppWidgetId', reference);
  }

  @override
  String toString() {
    return '$hostId, $reference';
  }
}

Future<void> startActivity(Intent intent) async {
  await _channel.invokeMethod('context.startActivity', intent.toJson());
}

Future<String> getPackageName() async {
  return _channel.invokeMethod('getPackageName');
}

Future<String> getPlatformVersion() async {
  final String version = await _channel.invokeMethod('getPlatformVersion');
  return version;
}

Future<void> uninstallPackage(String packageName) async {
  await _channel.invokeMethod('uninstallPackage', packageName);
}

Future<void> openDefaultAppsSettings() async {
  await _channel.invokeMethod('openDefaultAppsSettings');
}

Future<String> getDefaultSmsPackage() async {
  return _channel.invokeMethod('getDefaultSmsPackage');
}
