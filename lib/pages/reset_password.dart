import 'package:counter_test/pages/login_page.dart';
import 'package:flutter/material.dart';

class RecordarPassword extends StatefulWidget {
  const RecordarPassword({super.key});

  @override
  State<RecordarPassword> createState() => _RecordarPasswordState();
}

class _RecordarPasswordState extends State<RecordarPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recupera tu password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: const Stack(
        children: [
          Fondo(),
          Center(
            child: Text(
              'Recupera tu password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
