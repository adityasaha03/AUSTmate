import 'package:flutter/material.dart';

class CgCalculatorPage extends StatefulWidget {
  const CgCalculatorPage({super.key});

  @override
  State<CgCalculatorPage> createState() => _CgCalculatorPageState();
}

class _CgCalculatorPageState extends State<CgCalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Cgpa Calculator Page")));
  }
}
