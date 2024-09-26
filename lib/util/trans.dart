import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyTranslations extends Translations {
  final Map<String, Map<String, String>> _translations = {};

  MyTranslations(Map<String, Map<String, String>> translations) {
    _translations.addAll(translations);
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
}

Future<Map<String, String>> _loadJson(String path) async {
  final data = await rootBundle.loadString(path);
  final Map<String, dynamic> jsonResult = json.decode(data);
  return jsonResult.map((key, value) => MapEntry(key, value.toString()));
}

Future<Map<String, Map<String, String>>> loadTranslations() async {
  final enUS = await _loadJson('lang/en_US.json');
  final zhCN = await _loadJson('lang/zh_CN.json');
  final ruRU = await _loadJson('lang/ru_RU.json');
  return {
    'en_US': enUS,
    'zh_CN': zhCN,
    'ru_RU': ruRU,
  };
}