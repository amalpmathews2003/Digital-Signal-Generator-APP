import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:signal_generator/services/bluetooth.dart';

class PicoData extends StatefulWidget {
  const PicoData({super.key});

  @override
  State<PicoData> createState() => _PicoDataState();
}

class _PicoDataState extends State<PicoData> {
  BluetoothUtilService blue = BluetoothUtilService();

  @override
  void initState() {
    blue
        .connect(const DeviceIdentifier('28:CD:C1:06:F6:2F'))
        .then((value) => print('success'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pico Data')),
      body: Column(
        children: [
          blue.readCharecteristic != null
              ? StreamBuilder(
                  stream: blue.readCharecteristic?.onValueReceived,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data);
                      return Text(snapshot.data.toString());
                    } else {
                      return const Text('No data');
                    }
                  },
                )
              : const Text('No characteristic'),
          ElevatedButton(
            onPressed: () async {
              await blue.writeData('Hello');
            },
            child: const Text('Send'),
          ),
          ElevatedButton(
            onPressed: () async {
              await blue.connect(const DeviceIdentifier('28:CD:C1:06:F6:2F'));
            },
            child: const Text('Connect'),
          ),
          ElevatedButton(
            onPressed: () async {
              await blue.disconnect();
            },
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }
}
