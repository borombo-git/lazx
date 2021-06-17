import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lazx_idea/app.dart';

Future<void> main() async {
  await init();
  runApp(StarterApp());
}

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}
