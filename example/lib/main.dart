import 'package:flutter/material.dart';
import 'package:inactive_secure_box/inactive_secure_box.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.teal),
      builder: (_, child) => InactiveSecureBox(child: child!),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inactive secure box')),
      body: const Center(
        child: InactiveSecureBox(child: Text('Secret content')),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showAboutDialog(context: context);
        },
      ),
    );
  }
}
