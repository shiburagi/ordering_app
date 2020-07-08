import 'package:flutter/material.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/menu.dart';
import 'package:srs_restaurant/bloc/queue.dart';
import 'package:srs_restaurant/bloc/receipt.dart';
import 'package:srs_restaurant/bloc/shop_info.dart';
import 'package:srs_restaurant/bloc/table.dart';
import 'package:srs_restaurant/pages/home.dart';
import 'package:srs_restaurant/pages/menus.dart';

void main() {
  runApp(MyApp());
}

Map<String, WidgetBuilder> routes = {
  "/": (context) => HomePage(),
  "/menus": (context) => MenusPage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderBoilerplate(
      providers: [
        registerProvider(TableBloc()),
        registerProvider(QueueBloc()),
        registerProvider(MenuBloc()),
        registerProvider(ReceiptBloc()),
        registerProvider(ShopInfoBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: routes,
      ),
    );
  }
}
