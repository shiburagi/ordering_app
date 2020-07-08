import 'package:flutter/material.dart';
import 'package:provider_boilerplate/components/button.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/receipt.dart';
import 'package:srs_restaurant/entities/table.dart';
import 'package:srs_restaurant/views/order.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  TableNo get table => ModalRoute.of(context).settings.arguments;
  ReceiptBloc get receiptBloc => Provider.of(context, listen: false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Table: ${table.code}"),
      ),
      body: Column(
        children: [
          Expanded(child: OrderView()),
          Row(
            children: [
              Expanded(
                child: DecorButton(
                  fullWidth: true,
                  type: ButtonType.accent,
                  onPressed: () {
                    receiptBloc.print(context, table);
                  },
                  child: Text("Receipt"),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
