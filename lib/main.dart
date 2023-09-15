import 'package:firebase_alura/_core/my_colors.dart';
import 'package:firebase_alura/firestore/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listin - Lista Colaborativa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MyColors.brown,
        scaffoldBackgroundColor: MyColors.brown.shade100,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: MyColors.brown,
        ),
        listTileTheme: const ListTileThemeData(
          iconColor: MyColors.brown,
        ),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 72,
          centerTitle: true,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
