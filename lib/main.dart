import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xigua_read/app/splash_screen.dart';
import 'package:xigua_read/provider_setup.dart';

import 'base/structure/provider/config_provider.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: providers,
        child: Consumer<ConfigProvider>(builder:
            (BuildContext context, ConfigProvider appInfo, Widget child) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,

              title: 'Flutter Novel Reader',
              theme: ThemeData(primaryColor:Colors.white,),
              home: SplashScreen());
        }));
  }
}
