import 'package:flutter/material.dart';

class TripListScreen extends StatelessWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
      ),
      body: const Center(
        child: Text('Trip list will be implemented here'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create trip screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}