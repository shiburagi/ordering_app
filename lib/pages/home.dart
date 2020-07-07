import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/bloc_state.dart';
import 'package:srs_restaurant/bloc/table.dart';
import 'package:srs_restaurant/entities/table.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BlocState<HomePage, TableBloc> {
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
                return InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed("/menus", arguments: table),
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor)),
                    child: Text(table.code),
                  ),
                );
              }),
            );
          }),
    );
  }
}
