import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/domain/entities/chat_message.dart';
import 'package:firebase/domain/interfaces/chat_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ChatRepository implements ChatRepositoryInterface {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  @override
  Stream<List<Message>> getMessages() {
    print('mengambil chat');
    var chats = _firestore
        .collection('chat')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      final messages = <Message>[];
      for (final doc in snapshot.docs) {
        messages.add(Message(
          userId: doc['userId'],
          userImage: doc['userImage'],
          username: doc['username'],
          text: doc['message'],
          imageUrl: doc['imageUrl'],
          createdAt: (doc['createdAt'] as Timestamp).toDate(),
        ));
      }
      return messages;
    });
    return chats;
  }

  @override
  Future<void> sendMessage(Message message) async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    await _firestore.collection('chat').add({
      'userId': user.uid,
      'message': message.text ?? '',
      'createdAt': Timestamp.now(),
      'username': userData.data()!['username'],
      'userImage': userData.data()!['image_url'],
      'imageUrl': message.imageUrl ?? '',
    });
  }

  @override
  Future<void> pickAndUploadImage() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }

    final ref = _storage
        .ref()
        .child('chat_images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = ref.putFile(File(pickedImage.path));

    await uploadTask.whenComplete(() async {
      final imageUrl = await ref.getDownloadURL();
      final message = Message(
          userId: user.uid,
          userImage: userData.data()!['image_url'],
          username: userData.data()!['username'],
          imageUrl: imageUrl,
          createdAt: DateTime.now(),
          text: '');
      await sendMessage(message);
    });

    // return await ref.getDownloadURL();
  }
}
