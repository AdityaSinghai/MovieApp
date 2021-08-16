import 'package:flutter/material.dart';
import 'package:movieee_app/models/movie.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:provider/provider.dart';

class AddMovieForm extends StatefulWidget {
  @override
  _AddMovieFormState createState() => _AddMovieFormState();
}

class _AddMovieFormState extends State<AddMovieForm> {
  String _movieName;
  int _releaseYear;
  String _posterURL;
  String _director;
  //TODO: Implement provider functionality (Movies are added to the database from this form)



  void _addMovie(context) {
    Provider.of<MoviesData>(context, listen: false).addMovie(
      Movie(
          movieName: _movieName,
          url: _posterURL,
          releaseYear: _releaseYear,
          director: _director,
          isLiked: false,
          ),
    );
    Navigator.pop(context);
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildDirectorName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Director Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Director name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _director = value;
      },
    );
  }

  Widget _buildMovieName() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Movie Name"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Movie name is required';
        }
        return null;
      },
      onSaved: (String value) {
        _movieName = value;
      },
    );
  }

  Widget _buildReleaseYear() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Release Year"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Release year is required';
        }
        return null;
      },
      onSaved: (String value) {
        _releaseYear = int.parse(value);
      },
    );
  }

  Widget _buildPosterURL() {
    return TextFormField(
      keyboardType: TextInputType.url,
      decoration: InputDecoration(labelText: "Poster url"),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Poster url is required';
        }
        return null;
      },
      onSaved: (String value) {
        _posterURL = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
          key: _formKey,
          child: Wrap(
            children: [
              _buildMovieName(),
              _buildDirectorName(),
              _buildReleaseYear(),
              _buildPosterURL(),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }

                        _formKey.currentState.save();

                        _addMovie(context);


                      }),
                ),
              )
            ],
          ),
        ));
  }
}
