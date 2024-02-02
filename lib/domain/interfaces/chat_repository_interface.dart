import 'package:firebase/domain/entities/chat_message.dart';

abstract class ChatRepositoryInterface {
  Stream<List<Message>> getMessages();
  Future<void> sendMessage(Message message);
  Future<void> pickAndUploadImage();
}
