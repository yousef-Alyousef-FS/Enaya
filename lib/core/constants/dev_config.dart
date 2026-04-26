import 'package:flutter/foundation.dart';

class DevConfig {
  static const bool isDevMode = bool.fromEnvironment('DEV_MODE', defaultValue: kDebugMode);
}
