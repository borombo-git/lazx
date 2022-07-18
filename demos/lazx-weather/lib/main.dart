import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

Future<void> main() async {
  await init();
  runApp(LazxWeatherApp());
}

// Function to initialize things at the beginning
Future<void> init() async {
  // Load the .env file
  await dotenv.load(fileName: ".env");
}
