import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'home.dart';
import 'methods/common.dart';
import 'methods/dailog_box.dart';

class RegisterPage extends StatefulWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final Map<String, String> registeredUsers = {};
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _termsAndConditionsAccepted = false;
  bool _visiblePassword = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController passTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  CommonMethods cMethods = CommonMethods();

  void checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context);
    signUpForValidation();
  }

  void signUpForValidation() {
    if (_formKey.currentState!.validate() && _termsAndConditionsAccepted) {
      registerNewUser();
    } else if (!_termsAndConditionsAccepted) {
      cMethods.displaySnackBar('You must accept the terms and conditions', context);
    }
  }

  Future<void> registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: 'Registering your account'),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passTextEditingController.text.trim(),
        ).catchError((errorMsg) {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if (!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);
    Map userDataMap = {
      'name': usernameTextEditingController.text.trim(),
      'email': emailTextEditingController.text.trim(),
      'phone': _phoneController.text.trim(),
      'id': userFirebase.uid,
      'blockStatus': 'no',
    };
    usersRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: Center(
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create an',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Account',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: usernameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'John Doe',
                          suffixIcon: Icon(
                            Icons.person,
                            color: Colors.red,
                          ),
                          contentPadding: EdgeInsets.all(16),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 3) {
                            return 'Your name must be at least 3 or more digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email",
                          hintText: 'johndoe@gmail.com',
                          suffixIcon: Icon(
                            Icons.email,
                            color: Colors.red,
                          ),
                        ),
                        validator: (value) {
                          String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                          RegExp emailRegex = RegExp(emailPattern);
                          if (value == null || !emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Contact no',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          print(value);
                        },
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: _phoneController,
                        formatInput: false,
                        keyboardType: TextInputType.numberWithOptions(
                          signed: true, decimal: true,
                        ),
                        inputDecoration: InputDecoration(
                          labelText: 'Phone Number',
                        ),
                        validator: (value) {
                          String phonePattern = r'^\d{8,}$';
                          RegExp phoneRegex = RegExp(phonePattern);
                          if (value == null || !phoneRegex.hasMatch(value.trim())) {
                            return 'Your phone must be at least 8 or more digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: passTextEditingController,
                        obscureText: !_visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: 'Enter your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _visiblePassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _visiblePassword = !_visiblePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return 'Your password must be at least 8 or more characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _termsAndConditionsAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _termsAndConditionsAccepted = value ?? false;
                              });
                            },
                          ),
                          Text('I agree with '),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              "Terms & Conditions",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account?'),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (c) => Home()));
                              },
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
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
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            checkIfNetworkIsAvailable();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Register',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
