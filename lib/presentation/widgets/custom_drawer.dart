import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/providers/unread_messages_counter_provider.dart';
import 'package:pet_adoption/data/providers/received_requests_provider.dart';
import 'package:pet_adoption/presentation/screens/chat_list_screen.dart';
import 'package:pet_adoption/presentation/screens/map_screen.dart';
import 'package:pet_adoption/presentation/screens/pre_home_screen.dart';
import 'package:pet_adoption/presentation/screens/profile_screen.dart';
import 'package:pet_adoption/presentation/screens/requests_screen.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingRequestsCount = ref.watch(pendingRequestsCounterProvider);
    final unreadMessagesCount = ref.watch(unreadMessagesCountProvider);

    print('Widget rebuilt');

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const PreHomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chat'),
            trailing: unreadMessagesCount.when(
              data: (count) {
                if (count > 0) {
                  return Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChatListScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('My Requests'),
            trailing: pendingRequestsCount.when(
              data: (count) {
                if (count > 0) {
                  return Container(
                    padding: const EdgeInsets.all(7.0),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RequestsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: const Text('Map'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () {
              ref.read(authRepositoryProvider).signOut();              
            },
          ),
        ],
      ),
    );
  }
}