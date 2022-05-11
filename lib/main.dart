// ignore_for_file: prefer_const_constructors

import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/services/theme_services.dart';

import 'ui/pages/home_page.dart';
import 'ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDB();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme, //geter so we create object from class
      title: '2 Do',
      debugShowCheckedModeBanner: false,
      home: Spalshscreen(),
    );
  }
}

class Spalshscreen extends StatefulWidget {
  const Spalshscreen({Key? key}) : super(key: key);

  @override
  State<Spalshscreen> createState() => _SpalshscreenState();
}

class _SpalshscreenState extends State<Spalshscreen> {
  //Future<Widget> futureCall() async => await Future.value(HomePage());

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('images/logo.png'),
      title: Text('To Do', style: titleStyle),
      showLoader: true,
      loadingText: Text('Loading...'),
      navigator: HomePage(),
    );
  }
}
