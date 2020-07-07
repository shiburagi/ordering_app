import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/queue.dart';
import 'package:srs_restaurant/bloc/table.dart';
import 'package:srs_restaurant/entities/table.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BlocState<HomePage, TableBloc> {
  QueueBloc get queueBloc => Provider.of(context);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<List<TableNo>>(
          stream: bloc.retrieveTable(),
          builder: (context, snapshot) {
            return GridView.count(
              childAspectRatio: 2,
              crossAxisCount: 2,
              children: List.generate(snapshot.data?.length ?? 0, (index) {
                TableNo table = snapshot.data[index];
                return StreamBuilder<Map<String, int>>(
                    stream: queueBloc.retrieveQueue(table.code),
                    builder: (context, snapshot) {
                      bool isOccupant = snapshot.data != null;
                      return InkWell(
                        onTap: () => Navigator.of(context).pushNamed("/menus",
                            arguments: [table, snapshot.data]),
                        child: Container(
                          alignment: Alignment.center,
                          margin:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: isOccupant
                                  ? Theme.of(context).accentColor
                                  : null,
                              border: Border.all(
                                  color: Theme.of(context).accentColor)),
                          child: Text(
                            table.code,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(
                                    color: isOccupant ? Colors.white : null),
                          ),
                        ),
                      );
                    });
              }),
            );
          }),
    );
  }
}
