import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/table.dart';
import 'package:srs_restaurant/stores/stores.dart';

class QueueBloc extends BaseBloc<Map<String, int>> {
  Stream<Map<String, int>> retrieveQueue(String code) {
    return queueStore.document(code).snapshots().map((event) =>
        event.data.map((key, value) => MapEntry(key, value.toInt())));
  }

  submit(
    context,
    TableNo table,
  ) async {
    orders["millis"] = DateTime.now().millisecondsSinceEpoch;
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
