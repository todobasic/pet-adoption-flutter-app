import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/domain/providers/adoption_request_notifier.dart';
import 'package:pet_adoption/data/providers/pet_post_repository_provider.dart';
import 'package:pet_adoption/data/providers/received_requests_provider.dart';

class ReceivedRequestsTab extends ConsumerWidget {
   const ReceivedRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final receivedRequestsStream = ref.watch(receivedRequestsProvider);

    return Scaffold(
      body: receivedRequestsStream.when(
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text('No requests received yet.'));
          }
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              bool isAccepted = request.status == 'accepted';
              return Card(
                child: ListTile(
                  title: Text(request.requesterName),
                  subtitle: Text('Request for ${request.petName}'),
                  trailing: isAccepted
                      ? const Icon(Icons.check, color: Colors.green)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: isAccepted
                                  ? null
                                  : () {
                                    _acceptRequest(context, ref, request);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Request accepted and other requests rejected.')));
                                    }
                                  },
                              child: const Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: isAccepted
                                  ? null
                                  : () {
                                    _declineRequest(context, ref, request);
                                    if(context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Request rejected.')),
                                    );}
                                  },
                              child: const Text('Decline'),
                            ),
                          ],
                        ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Error loading requests')),
      ),
    );
  }

    Future<void> _acceptRequest(BuildContext context, WidgetRef ref, AdoptionRequestModel selectedRequest) async {
      final adoptionRequestRepository = ref.read(adoptionRequestRepositoryProvider);
      final petRepository = ref.read(petPostRepositoryProvider);
      try {
        final requestsStream = adoptionRequestRepository.getAdoptionRequestsForPost(selectedRequest.postId);
        final requests = await requestsStream.first;
        if (requests.isEmpty) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No requests found for this pet.')));
          }
          return;
        }   
        await adoptionRequestRepository.updateAdoptionRequestStatus(selectedRequest.requestId, 'accepted'); 
        for (var request in requests) {
          if (request.requestId != selectedRequest.requestId) {
            if (request.status != 'accepted') {
              try {
              await adoptionRequestRepository.updateAdoptionRequestStatus(request.requestId, 'rejected');
            } catch (e) {
              print('Error updating request ${request.requestId}: $e');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error rejecting request ${request.requestId}.')));
              }
            }}
          }
        }
        await petRepository.updatePetPostStatus(selectedRequest.postId);    
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error accepting request: $e')));
        }
      }
    }

  Future<void> _declineRequest(BuildContext context, WidgetRef ref, AdoptionRequestModel request) async {
    await ref.read(adoptionRequestRepositoryProvider).updateAdoptionRequestStatus(request.requestId, 'rejected');    
  }
}
