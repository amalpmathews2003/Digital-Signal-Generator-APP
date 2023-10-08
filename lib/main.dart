import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:signal_generator/services/bluetooth.dart' as service;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Signal Generator',
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Digital Signal Generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool scanning = false;
  service.BluetoothService blue = service.BluetoothService();
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
        title: Text(widget.title),
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.stop),
            label: 'Stop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Scan',
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
