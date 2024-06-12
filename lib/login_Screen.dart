import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_flutter2/SQLDB.dart';
import 'package:project_flutter2/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.black12,
          title: Text(
            "Login & Signup",
            style: TextStyle(color: Color(0xFF274C77)),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
            labelColor: Color(0xFF274C77),
            indicatorColor: Color(0xFF274C77),
            dividerColor: Color(0xFF274C77),
            tabs: [
              Tab(
                text: "Login",
              ),
              Tab(
                text: "Signup",
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Content for Login Tab (replace with your login UI)
            Center(child: LoginCard()),
            // Content for Signup Tab (replace with your signup UI)
            Center(child: SignupCard()),
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  _LoginCardState createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  String _emailORusername = "", _password = "";
  final _emailORusernameController = TextEditingController(),
      _passwordController = TextEditingController();

  bool _obsecureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obsecureText = !_obsecureText;
    });
  }

  sqlDB db = sqlDB();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            color: Color(0xFFE7ECEF),
            margin: EdgeInsets.all(30),
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _emailORusernameController,
                      decoration: InputDecoration(
                          labelText: 'Email or Username',
                          labelStyle: TextStyle(color: Color(0xFF274C77)),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF274C77),
                          )),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obsecureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFF274C77)),
                        prefixIcon: const Icon(Icons.password_rounded,
                            color: Color(0xFF274C77)),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obsecureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF274C77)),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: TextButton(
                        child: Text("Forgot Password?",
                            style: TextStyle(
                                color: Color(0xFF274C77),
                                fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.of(context).push(_forgotpasswordRoute());

                          // ForgotPassword();
                        },
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () async{
                          _emailORusername = _emailORusernameController.text;
                          _password = _passwordController.text;
                          List<Map> users =
                              await db.readData("SELECT * FROM 'user'");
                          if (users.contains(_emailORusernameController) && users.contains(_password)) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          } else {
                            AlertDialog(
                              title: Text("Check username or password"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'close',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xFFFF274C77),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("You have successfully logged up."),
                            backgroundColor: Colors.green,
                          ));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color(0xFF274C77),
                              fontWeight: FontWeight.w600),
                        )),
                  ],
                )),
          ),
          Text(
            'Or Login With Your Social Account',
            style: TextStyle(
                fontFamily: 'PTSansCaption',
                color: Color(0xFFFF274C77),
                fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Image(
                      image: AssetImage('assets/facebook.png'),
                      width: 40,
                      height: 40),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage('assets/google.png'),
                    width: 40,
                    height: 40,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SignupCard extends StatefulWidget {
  @override
  _SignupCardState createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  sqlDB db = sqlDB();

  String _email = "", _username = "", _password = "", _confirmedPassword = "";

  final _emailController = TextEditingController(),
      _usernameController = TextEditingController(),
      _passwordController = TextEditingController(),
      _confirmedPasswordController = TextEditingController();

  bool _obsecureTextFieldOne = true, _obsecureTextFieldTwo = true;

  void _togglePasswordOneVisibility() {
    setState(() {
      _obsecureTextFieldOne = !_obsecureTextFieldOne;
    });
  }

  void _togglePasswordTwoVisibility() {
    setState(() {
      _obsecureTextFieldTwo = !_obsecureTextFieldTwo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Card(
            color: Color(0xFFE7ECEF),
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: Color(0xFF274C77)),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Color(0xFF274C77),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF274C77)),
                        prefixIcon: const Icon(Icons.email_outlined,
                            color: Color(0xFF274C77))),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Color(0xFF274C77)),
                        prefixIcon: const Icon(Icons.password_sharp,
                            color: Color(0xFF274C77)),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obsecureTextFieldOne
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF274C77)),
                          onPressed: _togglePasswordOneVisibility,
                        )),
                    obscureText: _obsecureTextFieldOne,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _confirmedPasswordController,
                    decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: TextStyle(color: Color(0xFF274C77)),
                        prefixIcon: const Icon(Icons.password_outlined,
                            color: Color(0xFF274C77)),
                        suffixIcon: IconButton(
                          icon: Icon(
                              _obsecureTextFieldTwo
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF274C77)),
                          onPressed: _togglePasswordTwoVisibility,
                        )),
                    obscureText: _obsecureTextFieldTwo,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        _username = _usernameController.text;
                        _email = _emailController.text;
                        _password = _passwordController.text;
                        _confirmedPassword = _confirmedPasswordController.text;
                        List<Map> users =
                            await db.readData("SELECT * FROM 'user'");
                        if (users.contains(_username)) {
                          AlertDialog(
                            title: Text("Username already taken"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'close',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFFF274C77),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        } else if (users.contains(_email)) {
                          AlertDialog(
                            title: Text("Email already taken"),
                            actions: <Widget>[
                              TextButton(
                                child: Text(
                                  'close',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Color(0xFFFF274C77),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        } else {
                          int response = await db.insertData(
                              "INSERT INTO 'user' ('name', 'email', 'password') VALUES ('" +
                                  _username +
                                  "', '" +
                                  _email +
                                  "', '" +
                                  _password +
                                  "')");
                          print(response);
                        }
                      },
                      child: Text(
                        'Signup',
                        style: TextStyle(
                            color: Color(0xFF274C77),
                            fontWeight: FontWeight.w600),
                      )),
                  // ElevatedButton(onPressed: () async{
                  //   int response = await db.deleteData("DELETE FROM user WHERE name = '$_username'");
                  //   print(response);
                  // }, child: Text("delete Data")),
                  // ElevatedButton(onPressed: () async{
                  //   int response = await db.updateData("UPDATE 'user' SET 'password' = 11");
                  //   print(response);
                  // }, child: Text("update Data"))
                ],
              ),
            ),
          ),
          Text(
            'Or Login With Your Social Account',
            style: TextStyle(
                fontFamily: 'PTSansCaption',
                color: Color(0xFFFF274C77),
                fontSize: 14),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Image(
                      image: AssetImage('assets/facebook.png'),
                      width: 40,
                      height: 40),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: IconButton(
                  onPressed: () {},
                  icon: Image(
                    image: AssetImage('assets/google.png'),
                    width: 40,
                    height: 40,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar()
//   title: Text(
//     "Forgot Password",
//     style: TextStyle(fontSize: 30 , fontWeight: FontWeight.w600),
//   ),
//   centerTitle: true,
// )
      ,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Text(
                "Forgot Password",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF274C77)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 100, right: 35, left: 35),
                child: Text(
                  "Please enter your email address. You will receive an link to create a new password via email.",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextField(
                    decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                            color: Color(0xFF274C77),
                            fontWeight: FontWeight.w600),
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Color(0xFF274C77),
                        ))),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFE7ECEF))),
                      onPressed: () {},
                      child: Text(
                        "Send",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF274C77)),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Route _forgotpasswordRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ForgotPassword(),
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
