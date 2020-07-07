import 'dart:async';

import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/table.dart';
import 'package:srs_restaurant/stores/stores.dart';

class TableBloc extends BaseBloc {
  Stream<List<TableNo>> retrieveTable() {
    return tablesStore.snapshots().map((event) {
      List<TableNo> tables =
          event.documents.map((e) => TableNo.fromJson(e.data)).toList();
      return tables;
    });
  }
}
