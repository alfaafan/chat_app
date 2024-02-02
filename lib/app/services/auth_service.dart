import 'package:firebase/domain/interfaces/user_repository_interface.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final UserRepositoryInterface _userRepository;

  AuthService(this._userRepository);

  User? _user;

  User? get user => _user;

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    final user =
        await _userRepository.signInWithEmailAndPassword(email, password);
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    final user = await _userRepository.signInWithGoogle();
    if (user != null) {
      _user = user;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _userRepository.signOut();
    _user = null;
    notifyListeners();
  }
}
