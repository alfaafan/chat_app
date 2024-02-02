//chat_message

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/app/providers/chat_provider.dart';
import 'package:firebase/app/widgets/message_bubble.dart';
import 'package:firebase/data/repositories/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Consumer<ChatProvider>(builder: ((context, chatProvider, _) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages yet! Start chatting!'),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('An error occurred! Please try again later.'),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;
          print({
            'loadedMessages': loadedMessages.length,
          });

          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index];
              final nextChatMessage = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1]
                  : null;

              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId = nextChatMessage?['userId'];
              final nextUserIsSame = nextMessageUserId == currentMessageUserId;

              if (nextUserIsSame) {
                return MessageBubble.next(
                  message: chatMessage['message'] ?? '',
                  imageUrl: chatMessage['imageUrl'] ?? '',
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  userImage: chatMessage['userImage']!,
                  username: chatMessage['username'],
                  message: chatMessage['message'] ?? '',
                  imageUrl: chatMessage['imageUrl'] ?? '',
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              }
            },
          );
        },
      );
    }));
  }
}
