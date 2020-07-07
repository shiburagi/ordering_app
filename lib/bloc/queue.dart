import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/menu.dart';
import 'package:srs_restaurant/entities/table.dart';
import 'package:srs_restaurant/stores/stores.dart';

class QueueBloc extends BaseBloc<Map<String, int>> {
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

  submit(
    context,
    TableNo table,
  ) async {
    await queueStore.document(table.code).setData(orders);
    sink.add(null);
    Navigator.of(context).pop();
  }

  Map<String, int> get orders => data ?? {};

  add(String id) {
    Map<String, int> orders = this.orders;
    orders[id] ??= 0;
    orders[id]++;
    sink.add(orders);
  }

  minus(String id) {
    Map<String, int> orders = this.orders;
    orders[id] ??= 0;
    if (orders[id] > 0) {
      orders[id]--;
    } else {
      orders.remove(id);
    }
    sink.add(orders);
  }
}
