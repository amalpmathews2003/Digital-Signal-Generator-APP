import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class SliderCustomFrequency extends StatefulWidget {
  final Function onChangeCustom;
  const SliderCustomFrequency({
    super.key,
    required this.onChangeCustom,
  });

  @override
  State<SliderCustomFrequency> createState() => _SliderStateFrequency();
}

class _SliderStateFrequency extends State<SliderCustomFrequency> {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 1,
      max: 1000,
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
          progressBarColor: Theme.of(context).colorScheme.inversePrimary,
          trackColor: Theme.of(context).colorScheme.background,
          hideShadow: true,
        ),
        infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 32),
            modifier: percentageModifierFrequency),
      ),
      onChangeEnd: (double value) {
        // print(value);
        widget.onChangeCustom(value * 1000);
      },
    );
  }
}

String percentageModifierFrequency(double value) {
  int roundedValue = value.floor();
  return '$roundedValue kHz';
}

String percentageModifierAmplitude(double value) {
  int roundedValue = value.floor();
  return '$roundedValue V';
}

class SliderCustomAmplitude extends StatefulWidget {
  final Function onChangeCustom;
  const SliderCustomAmplitude({super.key, required this.onChangeCustom});

  @override
  State<SliderCustomAmplitude> createState() => _SliderStateAmplitude();
}

class _SliderStateAmplitude extends State<SliderCustomAmplitude> {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
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
          progressBarColor: Theme.of(context).colorScheme.inversePrimary,
          trackColor: Theme.of(context).colorScheme.background,
          hideShadow: true,
        ),
        infoProperties: InfoProperties(
            mainLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
            modifier: percentageModifierAmplitude),
      ),
      onChangeEnd: (double value) {
        // print(value);
        widget.onChangeCustom(value);
      },
    );
  }
}
