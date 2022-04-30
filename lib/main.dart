import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/Views/characters.dart';
import 'package:marvelapp/Views/favorites_page.dart';
import 'Views/login_page.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/Views/about_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Character result;

  const MyApp({Key key, this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, primaryColor: Colors.red),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
      routes: {
        '/about': (context) => AboutPage(),
        '/login': (context) => LoginPage(),
        '/favoritos': (context) => FavoritePage(),
        '/exit': (context) => LoginPage(),
      },      
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginPage(),      
    );
  }
}