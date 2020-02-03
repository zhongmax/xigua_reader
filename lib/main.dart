import 'package:flutter/material.dart';

import 'app/root_scene.dart';
import 'app/sq_color.dart';

void main() => runApp(MyApp());

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '西瓜阅读',
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        dividerColor: Color(0xffeeeeee),
        scaffoldBackgroundColor: SQColor.paper,
        textTheme: TextTheme(body1: TextStyle(color: SQColor.darkGray)),
      ),
      home: RootScene(),
    );
  }
}

