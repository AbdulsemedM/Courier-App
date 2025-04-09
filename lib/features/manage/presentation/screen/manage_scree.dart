import 'package:flutter/material.dart';

class ManageScree extends StatefulWidget {
  const ManageScree({super.key});

  @override
  State<ManageScree> createState() => _ManageScreeState();
}

class _ManageScreeState extends State<ManageScree> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage'),
      ),
      body: const Center(
        child: Text('Manage'),
      ),
    );
  }
}
