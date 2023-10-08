import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:signal_generator/services/bluetooth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool scanning = false;
  BluetoothUtilService blue = BluetoothUtilService();
  Set<DeviceIdentifier> devices = {};
  Future<void> scan() async {
    setState(() {
      scanning = true;
    });
    await blue.scan();

    setState(() {
      scanning = false;
    });
  }

  @override
  void initState() {
    scan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Signal Generator Interface'),
      ),
      body: StreamBuilder(
          stream: FlutterBluePlus.scanResults,
          builder:
              (BuildContext context, AsyncSnapshot<List<ScanResult>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  for (ScanResult result in snapshot.data!)
                    ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(result.device.platformName == ''
                          ? 'Unknown'
                          : result.device.platformName),
                      subtitle: Text(result.device.remoteId.toString()),
                      trailing: Text(result.rssi.toString()),
                      onTap: () async {
                        await blue.connect(result.device.remoteId);
                      },
                    ),
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) async {
          switch (index) {
            case 0:
              await blue.send();
              break;
            case 1:
              await blue.disconnect();
              break;
            case 2:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stop),
            label: 'Stop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Disconnect',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: scanning
            ? const CircularProgressIndicator()
            : const Icon(Icons.bluetooth),
      ),
    );
  }
}
