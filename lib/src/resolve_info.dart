import 'dart:convert';
import 'dart:typed_data';

import 'package:context/src/activity_info.dart';

class ResolveInfo {
  final ActivityInfo activityInfo;
  final Uint8List icon;

  ResolveInfo(this.activityInfo, this.icon);

  factory ResolveInfo.fromJson(Map<String, dynamic> json) {
    final String icon = json['icon'];

    final activityInfo = ActivityInfo.fromJson(Map.from(json['activityInfo']));

    return ResolveInfo(activityInfo, base64.decode(icon));
  }
}
