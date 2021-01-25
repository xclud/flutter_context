import 'dart:convert';

class Intent {
  String action;
  String data;
  String type;
  int flags;
  ComponentName component;
  final List<String> _categories = [];
  final Map<String, dynamic> _extras = {};

  List<String> get categories => _categories;

  Map<String, dynamic> get extras => _extras;

  set categories(List<String> cats) {
    _categories.clear();
    if (cats != null) {
      _categories.addAll(cats);
    }
  }

  set extras(Map<String, dynamic> extras) {
    _extras.clear();
    if (extras != null) {
      _extras.addAll(extras);
    }
  }

  Intent([this.action]);

  factory Intent.fromJson(Map<String, dynamic> json) {
    final String action = json['action'];
    final String data = json['data'];
    final String type = json['type'];
    final extras = json['extras'];
    final categories = json['categories'];

    final intent = Intent();

    intent.action = action;
    intent.data = data;

    intent.type = type;
    if (extras != null) {
      intent.extras = Map.from(extras);
    }

    if (categories != null) {
      intent.categories = List.from(categories);
    }

    return intent;
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (action != null) {
      json['action'] = action;
    }
    if (data != null) {
      json['data'] = data;
    }
    if (type != null) {
      json['type'] = type;
    }
    if (_categories.isNotEmpty) {
      json['categories'] = _categories;
    }
    if (_extras.isNotEmpty) {
      json['extras'] = _extras;
    }

    if (flags != null) {
      json['flags'] = flags;
    }

    if (component != null) {
      json['component'] = component.toJson();
    }

    return json;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  static const String ACTION_PACKAGE_ADDED =
      'android.intent.action.PACKAGE_ADDED';
  static const String ACTION_PACKAGE_FULLY_REMOVED =
      'android.intent.action.PACKAGE_FULLY_REMOVED';

  static const String ACTION_PACKAGE_REMOVED =
      'android.intent.action.PACKAGE_REMOVED';

  static const String ACTION_MAIN = "android.intent.action.MAIN";
  static const String ACTION_DIAL = "android.intent.action.DIAL";
  static const String ACTION_VIEW = "android.intent.action.VIEW";

  static const String CATEGORY_DEFAULT = "android.intent.category.DEFAULT";
  static const String CATEGORY_HOME = "android.intent.category.HOME";
  static const String CATEGORY_INFO = "android.intent.category.INFO";
  static const String CATEGORY_LAUNCHER = "android.intent.category.LAUNCHER";

  static const int FLAG_ACTIVITY_NEW_TASK = 0x10000000;
}

class MediaStore {
  static const ACTION_IMAGE_CAPTURE = "android.media.action.IMAGE_CAPTURE";
  static const ACTION_IMAGE_CAPTURE_SECURE =
      "android.media.action.IMAGE_CAPTURE_SECURE";
  static const ACTION_REVIEW = "android.provider.action.REVIEW";
  static const ACTION_REVIEW_SECURE = "android.provider.action.REVIEW_SECURE";
  static const ACTION_VIDEO_CAPTURE = "android.media.action.VIDEO_CAPTURE";
}

class ComponentName {
  final String packageName;
  final String className;

  ComponentName(this.packageName, this.className);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['package'] = packageName;
    json['class'] = className;

    return json;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
