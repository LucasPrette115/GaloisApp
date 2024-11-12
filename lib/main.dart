import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:graph_app/screens/capture_screen.dart';
import 'package:graph_app/screens/create_account_screen.dart';
import 'package:graph_app/screens/history_screen.dart';
import 'package:graph_app/screens/login_screen.dart';

const firebaseConfig = FirebaseOptions(
  apiKey: "api_key",
  authDomain: "galois-eb763.firebaseapp.com",
  projectId: "galois-eb763",
  storageBucket: "galois-eb763.appspot.com",
  messagingSenderId: "202313447280",
  appId: "1:202313447280:web:f86454878aa0d828b941b5",
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: firebaseConfig);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LoginScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/create-account': (context) => CreateAccountScreen(),
        '/home': (context) => EquationSolverScreen(),
        '/history': (context) => HistoryScreen(),
      },
    );
  }
}
