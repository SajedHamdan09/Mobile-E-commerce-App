import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<List<String>> settings = [
    ['Edit Profile', 'assets/draw.png'],
    ['Settings', 'assets/setting.png'],
    ['Billing Details', 'assets/pay.png'],
    ['Privacy Policy', 'assets/insurance.png'],
    ['Rate Us', 'assets/star.png'],
    ['About Us', 'assets/information-button.png'],
    ['Sign Out', 'assets/logout.png']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFFF274C77),
          title: Text(
            "Profile",
            style: TextStyle(
                color: Color(0xFFF5F5F5), fontFamily: 'Jersey', fontSize: 40),
          )),
      body: Center(
        child: Column(children: <Widget>[
          Container(margin: EdgeInsets.only(top: 30),
          child: Image.asset('assets/avatar.png'),width: 80,height: 80,),
          Expanded(
            child: ListView.builder(
                itemCount: settings.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.only(left: 90 , right: 90,top: 20),
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFFF274C77),
                      ),
                      child: Padding(padding: EdgeInsets.only(top: 3 , bottom: 3 , left: 12, right: 12),child:
                      ListTile(
                        leading: Image(image: AssetImage(settings[index][1]) , color: Color(0xFFF5F5F5),width: 35,height: 35,),
                        trailing: Text('${settings[index][0]}' , style: TextStyle(color: Color(0xFFF5F5F5) , fontFamily: 'Inter' , fontSize: 15 , fontWeight: FontWeight.w600),),
                      ),),
                    ),
                  );
                }),
          ),
        ],),
      ),
    );

  }
}
