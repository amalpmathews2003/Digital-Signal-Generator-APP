import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:signal_generator/components/slider.dart';
import 'package:signal_generator/services/bluetooth.dart';

enum SignalShape {
  sine,
  square,
  triangle,
}

enum FrequencyUnit { hz, khz, mhz }

enum VoltageUnit { v, kv, mv }

class PicoData extends StatefulWidget {
  final DeviceIdentifier remoteID;
  const PicoData({super.key, required this.remoteID});

  @override
  State<PicoData> createState() => _PicoDataState();
}

class _PicoDataState extends State<PicoData> {
  BluetoothUtilService blue = BluetoothUtilService();
  TextEditingController textEditingController = TextEditingController();

  TextEditingController freqController = TextEditingController();
  TextEditingController voltageController = TextEditingController();
  TextEditingController dutyController = TextEditingController();

  var shape = SignalShape.sine;
  var frequencyUnit = FrequencyUnit.hz;
  var voltageUnit = VoltageUnit.v;
  var frequency = 1000 * 1000;
  var voltage = 0;
  var dutyRatio = 100;

  var shapes = ['Sine', 'Triangle', 'Square'];
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

  sendParams() {
    var actualFrequency = frequency * pow(1000, frequencyUnit.index);
    var actualVoltage = voltage * pow(1000, voltageUnit.index);
    var actualDutyRatio = dutyRatio;
    //shape value is S for sine and Q for square and like that first letter

    var shapeValue = shape == SignalShape.sine
        ? 'S'
        : shape == SignalShape.square
            ? 'P'
            : 'T';
    var data = '$shapeValue|$actualFrequency|$actualDutyRatio';
    print(data);
    blue.writeData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Signal Generator Interface')),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var shapeT in shapes)
                  Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      backgroundBlendMode: BlendMode.colorDodge,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: ClipOval(
                      child: TextButton(
                        onPressed: () {
                          if (shapeT == "Sine") {
                            shape = SignalShape.sine;
                          } else if (shapeT == "Square") {
                            shape = SignalShape.square;
                          } else {
                            shape = SignalShape.triangle;
                          }

                          setState(() {});
                          sendParams();
                        },
                        child: Text(shapeT),
                      ),
                    ),
                  ),
              ]),
            ),
            SizedBox(
              height: 200,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                        hintText: 'Enter Frequency',
                        labelText: 'Frequency',
                      ),
                      keyboardType: TextInputType.number,
                      controller: freqController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        setState(() {
                          frequency = int.parse(value);
                        });
                        sendParams();
                      },
                    ),
                  ),
                ),
                DropdownButton(
                    value: 'Hz',
                    items: ['Hz', 'KHz', 'MHz'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        frequencyUnit = FrequencyUnit.values.firstWhere(
                            (element) => element.toString() == value);
                        sendParams();
                      });
                    }),
              ]),
            ),
            SizedBox(
              height: 200,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                        hintText: 'Enter Voltage',
                        labelText: 'Voltage',
                      ),
                      keyboardType: TextInputType.number,
                      controller: voltageController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        setState(() {
                          voltage = int.parse(value);
                        });
                        sendParams();
                      },
                    ),
                  ),
                ),
                DropdownButton(
                    value: 'V',
                    items: ['V', 'KV', 'MV'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {}),
              ]),
            ),
            SizedBox(
              height: 200,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                  child: SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(),
                        ),
                        //fillColor: Colors.green
                        hintText: 'Enter Duty Ratio',
                        labelText: 'Duty Ratio',
                      ),
                      keyboardType: TextInputType.number,
                      controller: dutyController,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (value) {
                        setState(() {
                          dutyRatio = int.parse(value);
                        });
                        sendParams();
                      },
                    ),
                  ),
                ),
                DropdownButton(
                    value: '%',
                    items: ['%'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {}),
              ]),
            ),
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
                await blue.writeData(textEditingController.text);
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
