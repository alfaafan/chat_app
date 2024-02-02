import 'package:firebase/data/repositories/chat_repository.dart';
import 'package:firebase/domain/entities/chat_message.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;

  ChatProvider({required ChatRepository chatRepository})
      : _chatRepository = chatRepository;

  Stream<List<Message>> getMessages() {
    print('mengambil chat provider');
    var result = _chatRepository.getMessages();
    print('result: ${result.runtimeType}');
    return result;
  }

  Future<void> sendMessage(Message message) =>
      _chatRepository.sendMessage(message);
  Future<void> pickAndUploadImage() => _chatRepository.pickAndUploadImage();
}
