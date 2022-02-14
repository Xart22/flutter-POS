import 'dart:async';

import 'package:bigsam_pos/models/printer.dart';
import 'package:bigsam_pos/utils/database.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:bigsam_pos/global/printer.dart';

class PrinterPage extends StatefulWidget {
  const PrinterPage({Key? key}) : super(key: key);

  @override
  _PrinterPageState createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            isConnected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected!) {
      setState(() {
        isConnected = true;
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer'),
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name ?? ''),
                            subtitle: Text(d.address!),
                            onTap: () async {
                              setState(() {
                                _device = d;
                              });
                            },
                            trailing:
                                _device != null && _device!.address == d.address
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                          ))
                      .toList(),
                ),
              ),
              Divider(),
              Container(
                padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: const Text('Connect'),
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    isConnected = true;
                                    await bluetoothPrint.connect(_device!);
                                    await DatabaseHelper.instance
                                        .insertPrinter(PrinterModel(
                                      name: _device!.name,
                                      address: _device!.address,
                                      type: _device!.type,
                                    ));
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                  }
                                },
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          child: const Text('Disconnect'),
                          onPressed: _connected
                              ? () async {
                                  await bluetoothPrint.disconnect();
                                  await DatabaseHelper.instance
                                      .deletePrinter(1);
                                }
                              : null,
                        ),
                      ],
                    ),
                    OutlinedButton(
                      child: const Text('Print Test'),
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              List<LineText> list = [];
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'Test Printer',
                                  weight: 1,
                                  align: LineText.ALIGN_CENTER,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'this is conent left',
                                  weight: 0,
                                  align: LineText.ALIGN_LEFT,
                                  linefeed: 1));
                              list.add(LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: 'this is conent right',
                                  align: LineText.ALIGN_RIGHT,
                                  linefeed: 1));
                              list.add(LineText(linefeed: 1));

                              await bluetoothPrint.printReceipt(config, list);
                            }
                          : null,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => bluetoothPrint.startScan(
                    timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}
