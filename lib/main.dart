import 'package:flutter/material.dart';
import 'package:srs_restaurant/pages/home.dart';

void main() {
  runApp(MyApp());
}

Map<String, WidgetBuilder> routes = {
  "/": (context) => HomePage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
