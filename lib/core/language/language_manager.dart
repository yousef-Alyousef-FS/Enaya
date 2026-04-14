import 'package:flutter/material.dart';

enum LanguageType { english, arabic }

const String arabic = 'ar';
const String english = 'en';
const String assetPathLocalizations = 'assets/translations';

const Locale arabicLocale = Locale('ar', 'SA');
const Locale englishLocale = Locale('en', 'US');

extension LanguageTypeExtension on LanguageType {
  String getValue() {
    switch (this) {
      case LanguageType.english:
        return english;
      case LanguageType.arabic:
        return arabic;
    }
  }
}
