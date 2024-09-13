import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/providers/new_message_provider.dart';

class NewMessageIndicator extends ConsumerWidget {
  final String userId;

  const NewMessageIndicator({required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newMessageIndicator = ref.watch(newMessagesProvider(userId));

    return newMessageIndicator.when(
      data: (hasNewMessage) => Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: CircleAvatar(
          radius: 5,
          backgroundColor: hasNewMessage ? Colors.red : Colors.transparent,
        ),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) => const Text('Error'),
    );
  }
}
