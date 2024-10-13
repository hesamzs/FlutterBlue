import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:permission_handler/permission_handler.dart';


class BT extends StatefulWidget {
  Function callback;

  BT({required Key key, required this.callback}) : super(key: key);

  @override
  State<BT> createState() => _BTState();
}

class _BTState extends State<BT> {



  void Perm() async {
    var status = await Permission.location.status;
    Map<Permission, PermissionStatus> statuses = await [Permission.bluetoothScan, Permission.bluetoothAdvertise, Permission.bluetoothConnect].request();
    if (statuses[Permission.bluetoothScan]!.isGranted && statuses[Permission.bluetoothAdvertise]!.isGranted && statuses[Permission.bluetoothConnect]!.isGranted) {
      // startScan();
    } else {
      // startScan();
    }
  }

  @override
  void initState() {
    super.initState();
    enableBT();
    Perm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(),
      ),
    );
  }
}

Future<void> enableBT() async {

  FlutterBlue.instance.state.listen((event) {
    if (event == BluetoothState.turningOff) {
      // Turning Off
    } else if (event == BluetoothState.turningOn) {
      // Turning On
    }
  });

}