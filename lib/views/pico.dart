import 'package:flutter/material.dart';
import 'package:signal_generator/components/slider.dart';

class PicoView extends StatefulWidget {
  const PicoView({super.key});

  @override
  State<PicoView> createState() => _PicoViewState();
}

class _PicoViewState extends State<PicoView> {
  @override
  Widget build(BuildContext context) {
    onChange(data) {
      print(data);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configuration'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SliderCustomFrequency(
              onChangeCustom: onChange,
            ),
          ),
        ],
      ),
    );
  }
}
