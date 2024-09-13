import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pet_adoption/presentation/screens/chat_screen.dart';
import 'package:pet_adoption/presentation/widgets/chat/new_message_indicator.dart';

class UserListTile extends StatelessWidget {
  final String currentUserId;
  final DocumentSnapshot user;

  const UserListTile({required this.currentUserId, required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(user['name'] + ' ' + user['surname']),
          const Spacer(),
          NewMessageIndicator(userId: user.id),
        ],
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              currentUserId: currentUserId,
              otherUserId: user.id,
            ),
          ),
        );
      },
    );
  }
}
