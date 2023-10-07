import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothService {
  Future<Set<DeviceIdentifier>> scan() async {
    debugPrint('1');
    print(1);
    if (await Permission.bluetooth.isDenied) {
      await Permission.bluetooth.request();
    }
    if (await FlutterBluePlus.isAvailable == false) {
      throw Exception('Bluetooth is not available');
    }
    debugPrint('1');
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) async {
      if (state == BluetoothAdapterState.on) {
        // usually start scanning, connecting, etc
        print('scan');
      } else {
        if (Platform.isAndroid) {
          debugPrint('333');
          await FlutterBluePlus.turnOn();
          debugPrint(FlutterBluePlus.adapterState.toString());
          debugPrint('333');
        }
      }
    });

    Set<DeviceIdentifier> seen = {};
    FlutterBluePlus.setLogLevel(LogLevel.verbose, color: false);

    FlutterBluePlus.scanResults.listen(
      (results) {
        for (ScanResult r in results) {
          if (seen.contains(r.device.remoteId) == false) {
            if (kDebugMode) {
              print(
                  '${r.device.remoteId}: "${r.advertisementData.localName}" found! rssi: ${r.rssi}');
            }
            seen.add(r.device.remoteId);
          }
        }
      },
    );
    debugPrint('1');

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    debugPrint('2');
    await FlutterBluePlus.stopScan();
    debugPrint('3');
    return seen;
  }

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(DeviceIdentifier remoteId) async {
    try {
      BluetoothDevice device = BluetoothDevice(remoteId: remoteId);
      await device.connect();
      List<BluetoothService> services =
          (await device.discoverServices()).cast<BluetoothService>();
      if (kDebugMode) {
        print('services: $services');
      }
    } catch (e) {
      throw Exception('Failed to connect to $remoteId');
    }
  }

  Future<void> disconnect(DeviceIdentifier remoteId) async {
    return await BluetoothDevice(remoteId: remoteId).disconnect();
  }
}
