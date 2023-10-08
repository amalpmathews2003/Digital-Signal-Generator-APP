import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  Future<void> scan() async {
    FlutterBluePlus.setLogLevel(LogLevel.none, color: false);
    await FlutterBluePlus.stopScan();
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    await Future.delayed(const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
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

      print('services: $services');
    } catch (e) {
      throw Exception('Failed to connect to $remoteId');
    }
  }

  Future<void> disconnect(DeviceIdentifier remoteId) async {
    return await BluetoothDevice(remoteId: remoteId).disconnect();
  }
}
