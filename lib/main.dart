import 'package:flutter/material.dart';
import 'package:sirmo_app/modules/auth/view/login_view.dart'; // Sesuaikan path-nya

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIRMO App',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const LoginView(), 
    );
  }
}