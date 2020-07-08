import 'package:flutter/material.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/menu.dart';
import 'package:srs_restaurant/bloc/queue.dart';
import 'package:srs_restaurant/entities/menu.dart';

class OrderView extends StatefulWidget {
  OrderView({Key key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends BlocState<OrderView, QueueBloc> {
  MenuBloc get menuBloc => Provider.of(context, listen: false);
  List<Menu> get menus => menuBloc.menu;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Map<String, int>>(
          stream: bloc.stream,
          builder: (context, s) {
            return buildMainContainer(context);
          }),
    );
  }

  Column buildMainContainer(BuildContext context) {
    double totalAmount = 0;
    List<TableRow> list = [];
    Map order = bloc.orders;
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
    return Column(
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
      ],
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
                                  bloc.minus(menu.id);
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
                                  bloc.add(menu.id);
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
