import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/providers/user_stream_provider.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/user_list_tile.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authStateProvider).value?.uid;
    final usersList = ref.watch(userStreamProvider);

    if (currentUserId == null) {
      return const Scaffold(
        body: Center(
          child: Text('You are signed out,'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      drawer: const CustomDrawer(),
      body: usersList.when(
        data: (snapshot) {
          if (snapshot.docs.isEmpty) {
            return const Center(child: Text('No users available.'));
          }
          final users = snapshot.docs.where((doc) => doc.id != currentUserId).toList();
          
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return UserListTile(
                currentUserId: currentUserId,
                user: user,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
