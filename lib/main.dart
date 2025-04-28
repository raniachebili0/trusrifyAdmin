import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trastify_back_office/presentaions/screens/home.dart';
import 'package:trastify_back_office/presentaions/screens/loginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1920 , 1080),
    builder:(context, _)  => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home:  HomePage(), // HomePage()
    ));
  }
}

