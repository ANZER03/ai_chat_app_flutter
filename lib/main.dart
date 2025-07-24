import 'package:flutter/material.dart';
import 'package:ai_chat_app/pages/login.dart';
import 'package:ai_chat_app/pages/chat.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initialRoute = '/login';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    setState(() {
      _initialRoute = isLoggedIn ? '/chat' : '/login';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anzer AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: _initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/chat': (context) => Chat(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
