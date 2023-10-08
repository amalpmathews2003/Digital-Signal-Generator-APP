import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PicoView extends StatefulWidget {
  const PicoView({super.key});

  @override
  State<PicoView> createState() => _PicoViewState();
}

class _PicoViewState extends State<PicoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configuration'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SleekCircularSlider(
              min: 1,
              max: 10,
              initialValue: 1,
              appearance: CircularSliderAppearance(
                size: 180,
                startAngle: 90,
                angleRange: 360,
                customWidths: CustomSliderWidths(
                  progressBarWidth: 28,
                  handlerSize: 8,
                ),
                customColors: CustomSliderColors(
                  dynamicGradient: false,
                  progressBarColor:
                      Theme.of(context).colorScheme.inversePrimary,
                  trackColor: Theme.of(context).colorScheme.background,
                  hideShadow: true,
                ),
                infoProperties: InfoProperties(
                    mainLabelStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                    modifier: percentageModifier),
              ),
              onChange: (double value) {
                //write code here bro
                print(value * 10);
              },
            ),
          ),
        ],
      ),
    );
  }
}

String percentageModifier(double value) {
  int roundedValue = value.ceil();
  return '$roundedValue Hz';
}
