import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/menu.dart';
import 'package:srs_restaurant/stores/stores.dart';

class MenuBloc extends BaseBloc {
  Stream<List<Menu>> retrieveMenu() {
    return menusStore.snapshots().map((event) {
      debugPrint(event.documents[0].data.toString());
      List<Menu> tables = event.documents.map((e) {
        Menu menu = Menu.fromJson(e.data);
        menu.id = e.documentID;
        return menu;
      }).toList();

      return tables;
    });
  }
}
