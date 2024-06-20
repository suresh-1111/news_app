import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:news_app/home.dart';
import 'methods/globals.dart' as globals;
import 'methods/common.dart';
import 'methods/dailog_box.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'methods/sign_in_google.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController passTextEditingController = TextEditingController();
  final TextEditingController emailTextEditingController = TextEditingController();
  final CommonMethods cMethods = CommonMethods();
  final GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    if (_formKey.currentState!.validate()) {
      signInForValidation();
    }
  }

  void signInForValidation() {
    if (!emailTextEditingController.text.contains('@')) {
      cMethods.displaySnackBar('Please enter a valid email', context);
    } else if (passTextEditingController.text.trim().length < 8) {
      cMethods.displaySnackBar('Your password must be at least 8 or more characters', context);
    } else {
      signInUser();
    }
  }

  Future<void> signInUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: 'allowing you to login...'),
    );

    try {
      final User? userFirebase = (
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passTextEditingController.text.trim(),
          )
      ).user;

      Navigator.pop(context);

      if (userFirebase != null) {
        DatabaseReference usersRef = FirebaseDatabase.instance.ref().child('users').child(userFirebase.uid);
        final snap = await usersRef.once();

        if (snap.snapshot.value != null) {
          if ((snap.snapshot.value as Map)['blockStatus'] == 'no') {
            globals.userName = (snap.snapshot.value as Map)['name'];
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomePage()));
          } else {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar('You are blocked, contact support.', context);
          }
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar('Your record does not exist as a user', context);
        }
      }
    } catch (errorMsg) {
      Navigator.pop(context); // Dismiss the loading dialog
      cMethods.displaySnackBar(errorMsg.toString(), context);
    }
  }

  void _handleGoogleSignIn() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: 'allowing you to login...'),
    );

    User? user = await googleSignInProvider.signInWithGoogle();

    Navigator.pop(context);

    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage())); // Navigate after successful login
    } else {
      print("Failed to sign in with Google.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.only(top: 3.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                height: 600,
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign In to your ',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Account',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      TextFormField(
                        controller: emailTextEditingController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: 'Email',
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passTextEditingController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: 'Password',
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return 'Your password must be at least 8 or more characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Text(
                          'Login with',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _handleGoogleSignIn,
                            child: CachedNetworkImage(
                              imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTyh0mw1NSASd23j828x3h5ixlbD0ybbrp1AQ&s',
                              width: 32,
                              height: 32,
                            ),
                          ),
                          SizedBox(width: 30),
                          CachedNetworkImage(
                            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSkbPf6A7tl21KJxFRS7Ou3ss9GgyDsbeuAUw&s',
                            width: 32,
                            height: 32,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) => Home(initialTabIndex: 1),
                              ),
                            );
                          },
                          child: Text(
                            "Register now",
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: checkIfNetworkIsAvailable,
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
