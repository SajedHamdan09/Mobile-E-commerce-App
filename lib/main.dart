// import 'dart:html';
// import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter2/DisplayPage.dart';
import 'package:project_flutter2/devices.dart';
import 'package:project_flutter2/login_Screen.dart';
import 'app_Bar.dart';
import 'cart.dart';
import 'search.dart';
import 'login_Screen.dart';
import 'wishlist.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);


  runApp(MyApp());
}

// void main()  {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:  'Flutter Project',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _children = [
    Search(),
    DisplayPage(),
    Cart(),
    Wishlist(),
    LoginScreen()
  ];

  int _selectedIndex = 1;

  void _tappedLabel(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  // List<dynamic> products = [];
  //
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData().then((fetchedProducts) {
  //     setState(() {
  //       products = fetchedProducts;
  //     });
  //   });
  // }


  @override
  Widget build(BuildContext context) {
    final List<AppBar?> _appBars = [null, My_AppBar(context), null, null, null];

    return Scaffold(
      appBar: _appBars[_selectedIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 15, left: 30, right: 30, top: 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart), label: 'Cart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite), label: 'Login'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login')
            ],
            backgroundColor: Color(0xFF6096ba),
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            selectedLabelStyle:
                TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Color(0xFFE7ECEF),
            currentIndex: _selectedIndex,
            onTap: _tappedLabel,
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            child: child,
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
          );
        },
        child: _children[_selectedIndex],
      ),
      backgroundColor: Colors.white,
    );
  }
}
