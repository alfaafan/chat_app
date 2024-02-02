//main.dart
import 'package:firebase/app/pages/auth_page/auth_page.dart';
import 'package:firebase/app/pages/chat_page/chat.dart';
import 'package:firebase/app/providers/chat_provider.dart';
import 'package:firebase/app/services/auth_service.dart';
import 'package:firebase/data/repositories/chat_repository.dart';
import 'package:firebase/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (ctx) => AuthService(UserRepository()),
      ),
      ChangeNotifierProvider(
          create: (ctx) => ChatProvider(chatRepository: ChatRepository()))
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatApp',
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              return const ChatScreen();
            }

            return const AuthScreen();
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
