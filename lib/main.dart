import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movieee_app/Screens/loginScreen.dart';
import 'package:movieee_app/screens/homepage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/movie.dart';
import 'models/movie_data.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Hive.registerAdapter(MovieAdapter());
  runApp(MyApp());
}

Future _initHive() async {
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
      create: (context) => MoviesData(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins'
        ),
        home: FutureBuilder(
          future: _initHive(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Scaffold(
                  body: Center(
                    child: Text('Error initializing hive data store.'),
                  ),
                );
              }
              else{
                return LoginScreen();
              }
            }
            else{
              return Scaffold(
                body: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    Hive.box('movies').close();
    super.dispose();
  }
}

