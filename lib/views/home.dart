import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:signal_generator/services/bluetooth.dart';
import 'package:signal_generator/views/data.dart';

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
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FlutterBluePlus.scanResults,
            builder: (BuildContext context,
                AsyncSnapshot<List<ScanResult>> snapshot) {
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PicoData(
                                remoteID: result.device.remoteId,
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.all(15.0),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Made with',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              SizedBox(width: 5),
              Text(
                'by AAAA',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scan,
        child: scanning
            ? const CircularProgressIndicator()
            : const Icon(Icons.refresh),
      ),
    );
  }
}
