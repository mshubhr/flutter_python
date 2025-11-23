import 'package:flutter/material.dart';
import 'package:to_do_flutter_python/screens/splash_screen.dart';

void main() {
  runApp(const ClinkApp());
}

class ClinkApp extends StatelessWidget {
  const ClinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clink Dating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.lightBlueAccent,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}
