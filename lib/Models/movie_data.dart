import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:movieee_app/models/movie.dart';

class MoviesData extends ChangeNotifier {
  // Name our hive box for this data
  String _boxName = "movies";

  // Initialize our list of contacts
  List<Movie> _movies = [];

  // Holds our active contact
  Movie _activeMovie;

  void getMovies() async {
    var box = await Hive.openBox<Movie>(_boxName);

    // Update our provider state data with a hive read, and refresh the ui
    _movies = box.values.toList();
    notifyListeners();
  }

  Movie getMovie(index){
    return _movies[index];
  }

  int get movieCount {
    return _movies.length;
  }

  void addMovie(Movie newMovie) async {
    var box = await Hive.openBox<Movie>(_boxName);

    // Add a contact to our box
    await box.add(newMovie);

    // Update our provider state data with a hive read, and refresh the ui
    _movies = box.values.toList();
    notifyListeners();
  }

  void deleteMovie(key) async {
    var box = await Hive.openBox<Movie>(_boxName);

    await box.delete(key);

    // Update _contacts List with all box values
    _movies = box.values.toList();

    print("Deleted movie with key: " + key.toString());

    // Update UI
    notifyListeners();
  }

  void toggleLike({Movie movie, int movieKey}) async {

    var box = await Hive.openBox<Movie>(_boxName);
    await box.put(movieKey, movie);
    _movies = box.values.toList();

    // Update activeContact
    _activeMovie = box.get(movieKey);

    print('Isliked: ' + movie.isLiked.toString());

    // Update UI
    notifyListeners();

  }

  void editMovie({Movie movie, int movieKey}) async {
    var box = await Hive.openBox<Movie>(_boxName);

    // Add a contact to our box
    await box.put(movieKey, movie);

    // Update _contacts List with all box values
    _movies = box.values.toList();

    // Update activeContact
    _activeMovie = box.get(movieKey);

    print('New Name Of Movie: ' + movie.movieName);

    // Update UI
    notifyListeners();
  }

  /// Set an active contact we can notify listeners for
  void setActiveMovie(key) async {
    var box = await Hive.openBox<Movie>(_boxName);
    _activeMovie = box.get(key);
    notifyListeners();
  }

  /// Get Active Contact
  Movie getActiveMovie() {
    return _activeMovie;
  }


}


