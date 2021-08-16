import 'package:flutter/material.dart';
import 'package:movieee_app/Screens/loginScreen.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:provider/provider.dart';
import 'addMovieForm.dart';
import 'movie_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
        print("Printing logged in user: "+loggedInUser.email);
      }}
      catch(e){
        print(e);
      }
    }


  @override
  Widget build(BuildContext context) {
    Provider.of<MoviesData>(context, listen: false).getMovies();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Movies',
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
              context: context, builder: (context) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  ),
                  height: MediaQuery.of(context).size.height*0.6,
                    child: AddMovieForm()),
              ),
          );
        },
      ),
      appBar: AppBar(
        title: Text("Hi ${loggedInUser.email}!",style: TextStyle(
          color: Colors.black
        ),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: Icon(Icons.logout,color: Colors.black,), onPressed: (){
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
                  child: MovieList()
              )
          ),
        ],
      ),
    );
  }

  Widget buildSheet() {
    return AddMovieForm();
  }
}
