import 'package:flutter/material.dart';
import 'package:imc_calc/ui/pages/imc_calc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/imc': (context) => const IMCCalculator(),
      },
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const IMCCalculator(),
    );
  }
}
