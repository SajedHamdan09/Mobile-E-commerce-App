// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:project_flutter2/devices.dart';
import 'package:project_flutter2/gadgets.dart';
import 'package:project_flutter2/laptops.dart';
import 'package:project_flutter2/screens.dart';

class My_AppBar extends AppBar {
  final BuildContext context;

  My_AppBar(this.context)
      : super(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/logo2.png"),
                fit: BoxFit.contain,
                // width: 300,
                height: 250,
              )
            ],
          ),
          backgroundColor: Color(0xFF6096BA),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.only(top: 5, left: 5, right: 5),
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(_devicesRoute());
                        },
                        icon: Image.asset('assets/smartphone.png'),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(_laptopsRoute());
                        },
                        icon: Image.asset('assets/laptop.png'),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(_screensRoute());
                        },
                        icon: Image.asset('assets/tv.png'),
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).push(_gadgetsRoute());
                        },
                        icon: Image.asset('assets/gadget.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}

Route _devicesRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Devices(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

Route _laptopsRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Laptops(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

Route _screensRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Screens(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

Route _gadgetsRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Gadgets(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}
