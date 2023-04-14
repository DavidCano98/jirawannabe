import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jirawannabe/helpers/local_database.dart';
import 'package:jirawannabe/utils/app_colors.dart';
import 'package:jirawannabe/utils/translations.dart';
import 'package:jirawannabe/views/home_view.dart';

import 'bindings/home_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale locale = Locale(await LocalDatabase.instance.getLocale() ?? "en");
  runApp(MyApp(locale));
}

class MyApp extends StatelessWidget {
  final Locale locale;

  const MyApp(this.locale, {super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'jirawannabe',
      locale: locale,
      fallbackLocale: Locale('en'),
      translations: Messages(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.blue,
        ),
      ),
      initialRoute: "/home",
      getPages: [
        GetPage(
          name: "/home",
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
