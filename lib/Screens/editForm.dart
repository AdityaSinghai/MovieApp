import 'package:flutter/material.dart';
import 'package:movieee_app/models/movie.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:provider/provider.dart';

class EditMovie extends StatefulWidget {
  final Movie currentMovie;

  EditMovie({this.currentMovie});

  @override
  _EditMovieState createState() => _EditMovieState();
}

class _EditMovieState extends State<EditMovie> {
  String _editMovieName;
  int _editReleaseYear;
  String _editPosterURL;
  String _editDirector;

  //TODO: the movie details are edited from this form
  void _editMovie(context) {
    Provider.of<MoviesData>(context, listen: false).editMovie(
        movie: Movie(
            movieName: _editMovieName,
            releaseYear: _editReleaseYear,
            url: _editPosterURL,
            director: _editDirector,
            isLiked: widget.currentMovie.isLiked),
        movieKey: widget.currentMovie.key);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildDirectorName() {
    return TextFormField(
      initialValue: widget.currentMovie.director,
      decoration: InputDecoration(labelText: "Director Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Director name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _editDirector = value;
      },
    );
  }

  Widget _buildMovieName() {
    return TextFormField(
      initialValue: widget.currentMovie.movieName,
      decoration: InputDecoration(labelText: "Movie Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Movie name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _editMovieName = value;
      },
    );
  }

  Widget _buildReleaseYear() {
    return TextFormField(
      initialValue: widget.currentMovie.releaseYear.toString(),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Release Year"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Release year is required';
        }
        return null;
      },
      onSaved: (String value) {
        _editReleaseYear = int.parse(value);
      },
    );
  }

  Widget _buildPosterURL() {
    return TextFormField(
      initialValue: widget.currentMovie.url,
      keyboardType: TextInputType.url,
      decoration: InputDecoration(labelText: "Poster url"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Poster url is required';
        }
        return null;
      },
      onSaved: (String value) {
        _editPosterURL = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Wrap(
              children: [
                _buildMovieName(),
                _buildReleaseYear(),
                _buildDirectorName(),
                _buildPosterURL(),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top:50.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Color(0xFF6F35A5),
                      ),
                      child: MaterialButton(
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10.0),
                          splashColor: Color(0xFF6F35A5),
                          child: Text('Submit'),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            }

                            _formKey.currentState.save();

                            _editMovie(context);

                            Navigator.pop(context);
                          }),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
