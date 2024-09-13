import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

class PendingRequestsTab extends ConsumerWidget {
  const PendingRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final userId = ref.read(authRepositoryProvider).currentUser?.uid;

    if (userId == null) return const Center(child: Text('No user found'));

    final requestStream = FirebaseFirestore.instance
        .collection('adoption_requests')
        .where('requesterId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: requestStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No pending requests.'));
        }

        final requests = snapshot.data!.docs.map((doc) {
          return AdoptionRequestModel.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return ListTile(
              title: Text(request.petName),
              subtitle: const Text('Request is currently being reviewed...'),
              trailing: const Icon(Icons.hourglass_empty, color: Colors.orange),
            );
          },
        );
      },
    );
  }
}
