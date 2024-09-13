import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/domain/providers/adoption_request_notifier.dart';

class ProcessedRequestsTab extends ConsumerWidget {
  const ProcessedRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: Text('User not logged in'));

    final requestRepo = ref.watch(adoptionRequestRepositoryProvider);

    return FutureBuilder<List<AdoptionRequestModel>>(
      future: requestRepo.getDecisionHistory(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No request history found.'));
        }

        final requests = snapshot.data!;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return ListTile(
              title: Text('Request by: ${request.requesterName}'),
              subtitle: Text('Pet Name: ${request.petName}'),
              trailing: Text(request.status),
            );
          },
        );
      },
    );
  }
}
