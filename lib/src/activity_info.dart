import 'dart:convert';

import 'dart:typed_data';

class ActivityInfo {
  final String label;
  final String name;
  final String packageName;
  final bool enabled;
  final bool exported;
  final Uint8List icon;

  ActivityInfo({
    this.label,
    this.packageName,
    this.name,
    this.enabled,
    this.exported,
    this.icon,
  });

  factory ActivityInfo.fromJson(Map<String, dynamic> json) {
    final String label = json['label'];
    final String icon = json['icon'];
    final String packageName = json['packageName'];
    final String name = json['name'];
    final bool enabled = json['enabled'];
    final bool exported = json['exported'];

    final activityInfo = ActivityInfo(
      label: label,
      icon: base64.decode(icon),
      packageName: packageName,
      name: name,
      enabled: enabled,
      exported: exported,
    );

    return activityInfo;
  }
}
