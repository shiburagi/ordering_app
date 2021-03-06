import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/menu.dart';
import 'package:srs_restaurant/stores/stores.dart';

class MenuBloc extends BaseBloc {
  List<Menu> _menu = [];
  List<Menu> get menu => _menu;
  Stream<List<Menu>> retrieveMenu() {
    return menusStore
        .orderBy("category")
        .orderBy("name")
        .snapshots()
        .map((event) {
      debugPrint(event.documents[0].data.toString());
      List<Menu> tables = event.documents.map((e) {
        Menu menu = Menu.fromJson(e.data);
        menu.id = e.documentID;
        return menu;
      }).toList();

      return tables;
    })
          ..listen((event) {
            _menu = event;
          });
  }
}
