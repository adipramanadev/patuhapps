import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:patuhapps/pages/appSplash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SIPATUH',
      home: AppSplash(),
    );
  }
}
