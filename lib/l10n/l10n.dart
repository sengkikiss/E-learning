import 'package:flutter/material.dart';

class L10n {
  static const all = [
    Locale('en'),
    Locale('km'),
  ];

  static String getLanguageName(String code) {
    switch (code) {
      case 'km':
        return 'ភាសាខ្មែរ (Khmer)';
      case 'en':
      default:
        return 'English';
    }
  }
}
