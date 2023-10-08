import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothUtilService {
  late BluetoothDevice device;
  BluetoothCharacteristic? writeCharecteristic, readCharecteristic;

  Future<void> scan() async {
    await FlutterBluePlus.turnOn();
    FlutterBluePlus.setLogLevel(LogLevel.none, color: false);
    await FlutterBluePlus.stopScan();
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    await Future.delayed(const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
  }

  Future<void> connect(DeviceIdentifier remoteId) async {
    device = BluetoothDevice(remoteId: remoteId);
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write == true) {
          writeCharecteristic = characteristic;
        }
        if (characteristic.properties.read == true) {
          readCharecteristic = characteristic;
          characteristic.onValueReceived.listen((value) {
            print(value);
          });
          await readCharecteristic?.setNotifyValue(true);
        }
      }
    }
  }

  Future<void> disconnect() async {
    return await device.disconnect();
  }

  Future<void> send() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  writeData(String data) async {
    List<int> bytes = utf8.encode(data);
    await writeCharecteristic?.write(bytes);
  }
}
