import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:signal_generator/components/slider.dart';
import 'package:signal_generator/services/bluetooth.dart';

enum SignalShape { sine, square }

class PicoData extends StatefulWidget {
  final DeviceIdentifier remoteID;
  const PicoData({super.key, required this.remoteID});

  @override
  State<PicoData> createState() => _PicoDataState();
}

class _PicoDataState extends State<PicoData> {
  BluetoothUtilService blue = BluetoothUtilService();
  TextEditingController controller = TextEditingController();
  var shape = SignalShape.square;

  @override
  void initState() {
    blue.connect(widget.remoteID).then((value) => print('success'));
    super.initState();
  }

  onChangeCustomFrequency(double value) {
    blue.writeData(value.floor().toString());
  }

  onChangeCustomAmplitude(double value) {
    blue.writeData(value.floor().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pico Data')),
      body: SingleChildScrollView(
        child: Column(
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
            TextFormField(
              decoration: InputDecoration(
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              controller: controller,
            ),
            ElevatedButton(
              onPressed: () async {
                await blue.writeData(controller.text);
              },
              child: const Text('Send'),
            ),
            ElevatedButton(
              onPressed: () async {
                await blue.connect(widget.remoteID);
              },
              child: const Text('Connect'),
            ),
            ElevatedButton(
              onPressed: () async {
                await blue.disconnect();
              },
              child: const Text('Disconnect'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SliderCustomFrequency(onChangeCustom: onChangeCustomFrequency),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SliderCustomAmplitude(onChangeCustom: onChangeCustomAmplitude),
              ],
            ),
            Column(
              children: [
                ListTile(
                  title: const Text('Square'),
                  leading: Radio(
                    value: SignalShape.square,
                    groupValue: shape,
                    onChanged: (SignalShape? value) {
                      setState(() {
                        shape = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Sine'),
                  leading: Radio(
                    value: SignalShape.sine,
                    groupValue: shape,
                    onChanged: (SignalShape? value) {
                      setState(() {
                        shape = value!;
                      });
                      print(shape);
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
