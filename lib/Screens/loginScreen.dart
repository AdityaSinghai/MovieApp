import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:movieee_app/Components/already_have_an_account_acheck.dart';
import 'package:movieee_app/Components/text_field_container.dart';
import 'package:movieee_app/Screens/registerScreen.dart';

import 'homepage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  bool _obscureText = true;
  bool showSpinner = false;
  String _error;

  //Shows Error Displayed from Console
  Widget _buildError() {
    setState(() {
      showSpinner = false;
    });
    if (_error != null) {
      return Container(
          padding: EdgeInsets.all(10),
          color: Colors.yellowAccent,
          width: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.error),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text(_error, overflow: TextOverflow.clip),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    },
                  )
                ],
              ),
            ],
          ));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
          body: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              _buildError(),
              Text(
                "Login in MovieeApp",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(left: 25, top: 10, right: 25),
                child: Form(
                  key: _formKey,
                  child: Column(

                    children: <Widget>[
                      TextFieldContainer(
                        child: TextFormField(
                          cursorColor: Color(0xFF6F35A5),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Registered Email ID",
                            suffixIcon:  Icon(Icons.account_circle_sharp),
                          ),
                          autofocus: false,
                          validator: (String value) {
                            if (value.isEmpty) {
                              setState(() {
                                showSpinner = false;
                              });
                              return 'Field Required';
                            }
                            if (!RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              setState(() {
                                showSpinner = false;
                              });
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      TextFieldContainer(
                        child: TextFormField(
                          cursorColor: Color(0xFF6F35A5),
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Password",
                            suffixIcon: IconButton(
                              color: Color(0xFF6F35A5),
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                          ),
                          autofocus: false,
                          obscureText: _obscureText,
                          validator: (String value) {
                            if (value.isEmpty) {
                              setState(() {
                                showSpinner = false;
                              });
                              return 'Field Required';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            color: Color(0xFF6F35A5),
                          ),
                          child: MaterialButton(
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10.0),
                            splashColor: Color(0xFF6F35A5),
                            onPressed: () async {
                              await Future.value(_error);
                              setState(() {
                                if (_error != null) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } else {
                                  setState(() {
                                    showSpinner = true;
                                  });
                                }
                              });
                              if (!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              _signInWithEmailAndPassword();
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          _success == null
                              ? ''
                              : (_success
                                  ? 'Successfully signed in ' + _userEmail
                                  : 'Sign in failed'),
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      AlreadyHaveAnAccountCheck(
                        press: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return RegistrationScreen();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInWithEmailAndPassword() async {
    print("SignIn is called");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      )).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return HomePage();
            }),
          );
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _error = e.message;
      });
    }
  }
}
