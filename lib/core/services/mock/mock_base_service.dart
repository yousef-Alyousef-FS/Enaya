import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

abstract class MockBaseService {
  final Logger logger = Logger();
  static const String basePath = 'assets/mock_data';

  Future<Map<String, dynamic>> loadJson(String file) async {
    try {
      final jsonString = await rootBundle.loadString('$basePath/$file');
      return jsonDecode(jsonString);
    } catch (e) {
      logger.e('Error loading $file: $e');
      throw MockDataException('Failed to load $file');
    }
  }

  Future<void> delay([int min = 600, int max = 1500]) async {
    final d = min + DateTime.now().millisecond % (max - min);
    await Future.delayed(Duration(milliseconds: d));
  }
}

class MockDataException implements Exception {
  final String message;
  MockDataException(this.message);
  @override
  String toString() => 'MockDataException: $message';
}
