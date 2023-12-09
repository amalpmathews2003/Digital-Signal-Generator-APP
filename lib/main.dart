import 'package:flutter/material.dart';
import 'package:signal_generator/views/home.dart';

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
      theme: ThemeData(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}
