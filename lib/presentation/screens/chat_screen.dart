import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/providers/chat_repository_provider.dart';
import 'package:pet_adoption/data/providers/user_info_provider.dart';
import 'package:pet_adoption/data/services/message_service.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/chat/message_bubble.dart';
import 'package:pet_adoption/presentation/widgets/chat/message_input.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? currentUserId;
  final String otherUserId;

  const ChatScreen({required this.currentUserId, required this.otherUserId, super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final chatRepository = ref.read(chatRepositoryProvider);
    final chatRoomId = chatRepository.getChatRoomId(widget.currentUserId!, widget.otherUserId);

    ref.read(messageServiceProvider).markMessagesAsRead(chatRoomId, widget.currentUserId!);
  }

  @override
  Widget build(BuildContext context) {
    final chatRepository = ref.read(chatRepositoryProvider);
    final chatRoomId = chatRepository.getChatRoomId(widget.currentUserId!, widget.otherUserId);
    final otherUserName = ref.watch(userInfoProvider(widget.otherUserId));

    return Scaffold(
      appBar: AppBar(
        title: otherUserName.when(
          data: (userData) => Text(userData?['name'] ?? 'Chat'),
          loading: () => const CircularProgressIndicator(),
          error: (error, stackTrace) => const Text('Error'),
        ),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatRepository.getMessagesStream(chatRoomId),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] == widget.currentUserId;

                    return MessageBubble(
                      isMe: isMe,
                      text: message['text'],
                    );
                  },
                );
              },
            ),
          ),
          MessageInput(
            messageController: _messageController,
            onSend: () {
              if (_messageController.text.trim().isEmpty) return;
              chatRepository.sendMessage(
                chatRoomId: chatRoomId,
                currentUserId: widget.currentUserId!,
                otherUserId: widget.otherUserId,
                text: _messageController.text.trim(),
              );
              _messageController.clear();
              if (_scrollController.hasClients) {
                _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
