import 'package:context/src/activity_info.dart';

class PackageInfo {
  List<ActivityInfo> activities;

  PackageInfo({this.activities});

  factory PackageInfo.fromJson(Map<String, dynamic> json) {
    final actList = List.from(json['activities']);
    final activities = actList
        .map((e) => Map<String, dynamic>.from(e))
        .map((e) => ActivityInfo.fromJson(e));

    return PackageInfo(activities: activities.toList());
  }
}
