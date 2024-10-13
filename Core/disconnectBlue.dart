import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:permission_handler/permission_handler.dart';

class disconnectPage extends StatefulWidget {
  Function callback;

  disconnectPage({required Key key, required this.callback}) : super(key: key);

  @override
  State<disconnectPage> createState() => _disconnectPageState();
}

class _disconnectPageState extends State<disconnectPage> {
  final String CHARACTERISTIC_ID = "XX:XX:XX:XX:XX";
  final String TARGET_DEVICE_NAME = "Name..";
  FlutterBlue flutterBlue = FlutterBlue.instance; // * Instance de FlutterBlue
  late StreamSubscription<ScanResult> scanSubScription; // * StreamSubscription
  late BluetoothDevice targetDevice; // * Device
  late BluetoothCharacteristic targetCharacteristic;
  Map<Guid, List<int>> readValues = <Guid, List<int>>{};

  startScan() {
    print("Starting Scan...");
    stopScan();
    scanSubScription = flutterBlue.scan().listen((scanResult) {
      print(scanResult.device.name.toString()); // ! TEST
      if (scanResult.device.name == TARGET_DEVICE_NAME) {
        print('DEVICE Found');
        stopScan();
        targetDevice = scanResult.device;
        disconnectFromDevice(targetDevice);
      }
    }, onDone: () => stopScan());
  }

  stopScan() {
    flutterBlue.stopScan();
    scanSubScription.cancel();
  }

  @override
  void dispose() {
    stopScan();
    super.dispose();
  }

  void Perm() async {
    var status = await Permission.location.status;
    Map<Permission, PermissionStatus> statuses = await [Permission.bluetoothScan, Permission.bluetoothAdvertise, Permission.bluetoothConnect].request();
    if (statuses[Permission.bluetoothScan]!.isGranted && statuses[Permission.bluetoothAdvertise]!.isGranted && statuses[Permission.bluetoothConnect]!.isGranted) {
      startScan();
    } else {
      startScan();
    }
  }

  @override
  void initState() {
    super.initState();

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

void disconnectFromDevice(targetDevice) {
  if (targetDevice == null) return;
  targetDevice.disconnect();
}
