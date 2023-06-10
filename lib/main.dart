import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pinpoint/repo/database_queries.dart';
import 'package:pinpoint/view/bottom_navigation.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await DatabaseQueries().loginWithEmail();
  runApp(const PinPoint());
}

class PinPoint extends StatelessWidget {
  const PinPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PinPoint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomNavigation(),
      initialRoute: '/',
    );
  }
}