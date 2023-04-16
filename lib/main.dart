import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryption_playground/login/login_screen.dart';
import 'package:encryption_playground/service/encryption_service.dart';
import 'package:encryption_playground/service/firebase_service.dart';
import 'package:encryption_playground/users/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

late final EncryptionService encryptionService;
late final FirebaseService firebaseService;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  encryptionService = EncryptionService();
  firebaseService = FirebaseService();

  final currentScreen = firebaseService.currentUserId == null
      ? const LoginScreen()
      : const UsersScreen();

  runApp(MaterialApp(home: currentScreen));
}
