import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit trip screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trip ID: $tripId',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const Text('Trip details will be implemented here'),
            const SizedBox(height: 24),
            const Text(
              'Activities',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Mock data
                itemBuilder: (context, index) {
                  final activityId = 'activity-${index + 1}';
                  return Card(
                    child: ListTile(
                      title: Text('Activity ${index + 1}'),
                      subtitle: const Text('Activity description'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        context.goNamed(
                          'activity-detail',
                          pathParameters: {
                            'tripId': tripId,
                            'activityId': activityId,
                          },
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
          // TODO: Navigate to create activity screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}