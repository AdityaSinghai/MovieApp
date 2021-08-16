import 'package:flutter/material.dart';
import 'package:movieee_app/Components/already_have_an_account_acheck.dart';
import 'package:movieee_app/Components/text_field_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movieee_app/Screens/homepage.dart';
import 'package:movieee_app/Screens/loginScreen.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool showSpinner = false;
  String _error;

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

  Widget _buildEmailForm() {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Color(0xFF6F35A5),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Email ID",
          suffixIcon: IconButton(
            color: Color(0xFF6F35A5),
            icon: Icon(Icons.account_circle_sharp),
            onPressed: () {},
          ),
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
            return 'Please enter a valid email address';
          }
          return null;
        },
          onSaved: (String value) {
                  _email = value;
                },
      ),
    );
    // return TextFieldContainer(
    //   child: TextFormField(
    //     keyboardType: TextInputType.emailAddress,
    //     textAlign: TextAlign.center,
    //     decoration: InputDecoration(labelText: "Email - ID"),
    //     validator: (String value) {
    //       if (value.isEmpty) {
    //         return 'Email ID is required';
    //       }
    //       return null;
    //     },
    //     onSaved: (String value) {
    //       _email = value;
    //     },
    //   ),
    // );
  }

  Widget _buildPasswordForm() {
    return TextFieldContainer(
      child : TextFormField(
        cursorColor: Color(0xFF6F35A5),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Password",
        ),
        autofocus: false,
        validator: (String value) {
          if (value.isEmpty) {
            setState(() {
              showSpinner = false;
            });
            return 'Field Required';
          }
          return null;
        },
        onSaved: (String value) {
          _password = value;
        },
      ),
      // child: TextFormField(
      //   textAlign: TextAlign.center,
      //   decoration: InputDecoration(labelText: "Password"),
      //   validator: (String value) {
      //     if (value.isEmpty) {
      //       return 'Password is required';
      //     }
      //     return null;
      //   },
      //   onSaved: (String value) {
      //     _password = value;
      //   },
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildError(),
                Text(
                  "Sign Up in MovieeApp",
                  style: TextStyle(fontWeight: FontWeight.w300,fontSize: 25),
                ),
                _buildEmailForm(),
                _buildPasswordForm(),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color(0xFF6F35A5),
                      ),
                      child: MaterialButton(
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          splashColor: Color(0xFF6F35A5),
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async{
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            try{
                              final newUser = await _auth.createUserWithEmailAndPassword(email: _email, password: _password);
                              if(newUser!=null){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    return HomePage();
                                  }),
                                );
                              }
                          } catch(e){
                              print(e);
                              setState(() {
                                _error = e.message;
                              });
                            }
                          },
                  ),
                    ),
                )),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  login: false,
                ),
              ],
            ),
          ),
        ));
  }
}
