import 'package:flutter/material.dart';

class CyclicScreen extends StatefulWidget {
  const CyclicScreen({super.key});

  @override
  State<CyclicScreen> createState() => _CyclicScreenState();
}

class _CyclicScreenState extends State<CyclicScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('Cyclic Screen')));
  }
}
