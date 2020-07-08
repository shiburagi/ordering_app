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
                        Expanded(
                          child: StreamBuilder<Map<String, int>>(
                              stream: queueBloc.stream,
                              builder: (context, s) {
                                return buildSummary(snapshot.data);
                              }),
                        ),
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
                                return buildSummary(snapshot.data);
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

  Widget buildSummary(List<Menu> menus) {
    double totalAmount = 0;
    List<TableRow> list = [];
    Map order = queueBloc.orders;
    order.forEach((key, value) {
      Menu menu =
          menus.firstWhere((element) => element.id == key, orElse: () => null);

      if (menu != null) {
        totalAmount += menu.price * value;
        list.add(buildSummaryInfo(menu.name, menu.price,
            count: value,
            menu: menu,
            border: true,
            style: Theme.of(context).textTheme.subtitle2));
      }
    });
    return Card(
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                child: Table(
                  children: [
                    ...list,
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Table(
              children: [
                buildSummaryInfo("Total amount", totalAmount),
              ],
            ),
          ),
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
                            receiptBloc.print(context, table);
                          },
                          child: Text("Pay"),
                        ),
                      ),
                    ]
            ],
          )
        ],
      ),
    );
  }

  TableRow buildSummaryInfo(String text, double amount,
      {int count, bool border = false, TextStyle style, Menu menu}) {
    style ??= Theme.of(context).textTheme.subtitle1;
    return TableRow(
      decoration: border
          ? BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor)))
          : null,
      children: [
        TableCell(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: style),
                ...count == null
                    ? []
                    : [
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Theme.of(context).dividerColor)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                child: Icon(Icons.remove),
                                onTap: () {
                                  queueBloc.minus(menu.id);
                                },
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: Theme.of(context).dividerColor,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text("${count ?? " "}",
                                    style: style.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: Theme.of(context).dividerColor,
                              ),
                              InkWell(
                                child: Icon(Icons.add),
                                onTap: () {
                                  queueBloc.add(menu.id);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
              ],
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.bottom,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              amount == null ? "" : "RM ${amount.toStringAsFixed(2)}",
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.bottomRight,
          ),
        )
      ],
    );
  }
}
