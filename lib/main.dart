import 'package:flutter/material.dart';
import 'package:trezvii_24_driver/presentation/app.dart';
import 'presentation/utils/app_color_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(milliseconds: 1000));
  AppColor.initColors();
  runApp(const App());
}
