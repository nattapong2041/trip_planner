import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class TripListScreen extends ConsumerWidget {
  const TripListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Trip list will be implemented in later tasks'),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Mock data for navigation testing
                itemBuilder: (context, index) {
                  final tripId = 'trip-${index + 1}';
                  return Card(
                    child: ListTile(
                      title: Text('Trip ${index + 1}'),
                      subtitle: const Text('Trip description'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.goNamed(
                          'trip-detail',
                          pathParameters: {'tripId': tripId},
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed('trip-create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}