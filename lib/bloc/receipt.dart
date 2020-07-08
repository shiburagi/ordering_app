import 'dart:developer';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:provider_boilerplate/provider_boilerplate.dart';
import 'package:srs_restaurant/bloc/menu.dart';
import 'package:srs_restaurant/bloc/queue.dart';
import 'package:srs_restaurant/bloc/shop_info.dart';
import 'package:srs_restaurant/entities/menu.dart';
import 'package:srs_restaurant/entities/shop_info.dart';
import 'package:srs_restaurant/entities/table.dart';

class ReceiptBloc extends BaseBloc {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _isScan = false;
  print(BuildContext context, TableNo table) async {
    if (!_isScan) {
      bluetoothPrint.startScan();
      _isScan = true;
    }
    if (!await isBluetoothConnected) {
      bluetoothPrint.state.listen((state) {
        switch (state) {
          case BluetoothPrint.CONNECTED:
            log("connected");
            break;
          case BluetoothPrint.DISCONNECTED:
            log("DISCONNECTED");

            break;
          default:
            break;
        }
      });
      {
        if (_device == null) {
          await showBluetoothDialog(context);
        }

        if (!await isBluetoothConnected &&
            _device != null &&
            _device.address != null) {
          debugPrint("device connect");

          await bluetoothPrint.connect(_device);
        } else
          return;
      }
      await Future.delayed(Duration(seconds: 3));
    }

    await startPrint(context, table);
    // if (!await bluetoothPrint.isConnected) return;

    // if (await isBluetoothConnected) ;
  }

  startPrint(context, TableNo table) async {
    ShopInfoBloc bloc = Provider.of(context, listen: false);
    MenuBloc menuBloc = Provider.of(context, listen: false);
    QueueBloc queueBloc = Provider.of(context, listen: false);
    ShopInfo shopInfo = await bloc.retrieveShopInfo();
    Map<String, dynamic> config = Map();
    List<LineText> list = List();
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: shopInfo.name,
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1));
    shopInfo.address.forEach((element) {
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: element,
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
    });
    list.add(LineText(linefeed: 1));
    double total = 0;
    queueBloc.orders.forEach((key, value) {
      Menu menu = menuBloc.menu.firstWhere((element) => element.id == key);
      total += value * menu.price;
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: menu.name,
          weight: 1,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "x$value\t\tRM ${menu.price.toStringAsFixed(2)}",
          weight: 1,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
    });
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "\t\t\t\t",
        linefeed: 1,
        underline: 1));
    list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "Total\t\tRM ${total.toStringAsFixed(2)}",
        align: LineText.ALIGN_LEFT,
        linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));
    list.add(LineText(
        linefeed: 1,
        type: LineText.TYPE_BARCODE,
        content: shopInfo.id,
        align: LineText.ALIGN_CENTER));
    list.add(LineText(linefeed: 1));
    list.add(LineText(linefeed: 1));

    await bluetoothPrint.printReceipt(config, list);
  }

  Future<bool> get isBluetoothConnected async =>
      await bluetoothPrint.isConnected;

  Future<bool> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected = await bluetoothPrint.isConnected;

    // if (!mounted) return;

    // if (isConnected) {
    //   setState(() {
    //     _connected = true;
    //   });
    // }

    return isConnected;
  }

  showBluetoothDialog(context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return Dialog(child: buildBluetoothDialog(context));
      },
    );
  }

  BluetoothDevice _device;

  Widget buildBluetoothDialog(context) {
    return StreamBuilder<List<BluetoothDevice>>(
      stream: bluetoothPrint.scanResults,
      initialData: [],
      builder: (c, snapshot) => StatefulBuilder(builder: (context, setState) {
        List<BluetoothDevice> devices = snapshot.data;

        return devices?.isEmpty ?? true
            ? Container(
                child: StreamBuilder<bool>(
                    stream: bluetoothPrint.isScanning,
                    builder: (context, snapshot) {
                      return DecorButton(
                        type: ButtonType.accent,
                        onPressed: snapshot.data ?? false
                            ? () {
                                bluetoothPrint.scan();
                              }
                            : null,
                        child: Text("Scan"),
                      );
                    }),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: snapshot.data
                    .map((d) => ListTile(
                          title: Text(d.name ?? ''),
                          subtitle: Text(d.address),
                          onTap: () async {
                            setState(() {
                              _device = d;
                            });
                            Navigator.of(context).pop();
                          },
                          trailing:
                              _device != null && _device.address == d.address
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : null,
                        ))
                    .toList(),
              );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    bluetoothPrint.disconnect();
  }
}
