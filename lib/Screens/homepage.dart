import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieee_app/Screens/loginScreen.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:provider/provider.dart';
import 'addMovieForm.dart';
import 'movie_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });

        print("Printing logged in user: " + loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<MoviesData>(context, listen: false).getMovies();

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF6F35A5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          tooltip: 'Add Movies',
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              isScrollControlled: true,
              context: context,
              builder: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: AddMovieForm()),
              ),
            );
          },
        ),
        appBar: AppBar(
          title: Text(
            "Hi ${loggedInUser.email}!",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                onPressed: () {
                  _auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }),
                  );
                })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
                    child: Provider.of<MoviesData>(context).movieCount == 0
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Text(
                                  "There are no movies added. In order to add movies, press the '+' button"),
                            ),
                          )
                        : MovieList())),
          ],
        ),
      ),
    );
  }

  Widget buildSheet() {
    return AddMovieForm();
  }
}
