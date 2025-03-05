import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'register.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Assurez-vous que ce fichier est bien configuré
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        fontFamily: 'Poppins',
      ),
      home: const RegisterScreen(),
    );
  }
}
