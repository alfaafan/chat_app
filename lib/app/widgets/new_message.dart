//new_message
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/app/providers/chat_provider.dart';
import 'package:firebase/data/repositories/chat_repository.dart';
import 'package:firebase/domain/entities/chat_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();
  File? _pickedImageFIle;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    await ChatRepository().sendMessage(Message(
        userId: FirebaseAuth.instance.currentUser!.uid,
        text: _messageController.text,
        createdAt: DateTime.now()));

    FocusScope.of(context).unfocus();
    _messageController.clear();
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFIle = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                ChatProvider(chatRepository: ChatRepository())
                    .pickAndUploadImage();
              },
              icon: const Icon(Icons.camera_alt_outlined)),
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(
                Icons.send,
              ),
              onPressed: _submitMessage),
        ],
      ),
    );
  }
}
