import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_cdn_web_flutter/util/key_controller.dart';
import 'package:go_cdn_web_flutter/util/trans.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'app/routes/app_pages.dart';

void main() async {
  Get.put(KeyController());
  WidgetsFlutterBinding.ensureInitialized();
  configLoading();
  // Загрузка переводов
  final translations = await loadTranslations();

  // Инициализация GetX для локализации
  runApp(MyApp(translations));

}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> translations;

  const MyApp(this.translations);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: MyTranslations(translations),
      // locale: Get.deviceLocale ?? Locale('zh', 'CN'), // Локаль по умолчанию
      locale: Locale('en', 'US'), // Локаль по умолчанию
      // locale: Locale('zh', 'CN'), // Локаль по умолчанию
      fallbackLocale: Locale('zh', 'CN'),
      getPages: AppPages.routes, // Определяем маршруты
      initialRoute: '/home', // Начальный маршрут

      builder: EasyLoading.init(), // Добавляем инициализацию EasyLoading
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withOpacity(0.5)
    ..dismissOnTap = false;
}