import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:provider_boilerplate/components/button.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/menu.dart';
import 'package:srs_restaurant/bloc/queue.dart';
import 'package:srs_restaurant/bloc/receipt.dart';
import 'package:srs_restaurant/entities/menu.dart';
import 'package:srs_restaurant/entities/table.dart';
import 'package:srs_restaurant/views/order.dart';

class MenusPage extends StatefulWidget {
  MenusPage({Key key}) : super(key: key);

  @override
  _MenusPageState createState() => _MenusPageState();
}

class _MenusPageState extends BlocState<MenusPage, MenuBloc> {
  QueueBloc get queueBloc => Provider.of(context, listen: false);
  ReceiptBloc get receiptBloc => Provider.of(context, listen: false);
  List get arguments => ModalRoute.of(context).settings.arguments;
  TableNo get table => arguments[0];
  Map<String, int> get orders => arguments[1];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (queueBloc.data == null && orders != null) {
      queueBloc.sink.add(orders);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table: ${table.code}"),
      ),
      body: StreamBuilder<List<Menu>>(
          stream: bloc.retrieveMenu(),
          builder: (context, snapshot) {
            debugPrint("${snapshot.data}");
            return OrientationBuilder(builder: (context, orientation) {
              return orientation == Orientation.portrait
                  ? Column(
                      children: [
                        Expanded(
                          child: buildMenuList(snapshot),
                        ),
                        buildSummary(snapshot.data, false),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: buildMenuList(snapshot),
                        ),
                        Expanded(
                          child: StreamBuilder<Map<String, int>>(
                              stream: queueBloc.stream,
                              builder: (context, s) {
                                return buildSummary(snapshot.data, true);
                              }),
                        ),
                      ],
                    );
            });
          }),
    );
  }

  ListView buildMenuList(AsyncSnapshot<List<Menu>> snapshot) {
    return ListView.builder(
      itemBuilder: (context, index) {
        Menu menu = snapshot.data[index];
        return InkWell(
          onTap: () {
            queueBloc.add(menu.id);
          },
          child: ListTile(
            dense: true,
            title: Text(menu.name),
            subtitle: Text("RM ${menu.price.toStringAsFixed(2)}"),
          ),
        );
      },
      itemCount: snapshot.data?.length ?? 0,
    );
  }

  Widget buildSummary(List<Menu> menus, bool showOrder) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          showOrder ? Expanded(child: OrderView()) : Container(),
          Row(
            children: [
              Expanded(
                child: DecorButton(
                  type: ButtonType.accent,
                  fullWidth: true,
                  onPressed: () {
                    queueBloc.submit(context, table);
                  },
                  child: Text("Done"),
                ),
              ),
              ...orders == null
                  ? []
                  : [
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: DecorButton(
                          type: ButtonType.success,
                          fullWidth: true,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed("/order", arguments: table);
                          },
                          child: Text("View"),
                        ),
                      ),
                    ]
            ],
          )
        ],
      ),
    );
  }
}
