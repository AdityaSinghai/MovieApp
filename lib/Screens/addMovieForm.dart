import 'package:flutter/material.dart';
import 'package:movieee_app/Components/text_field_container.dart';
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
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Color(0xFF6F35A5),
        decoration: InputDecoration(labelText: "Director Name",
          border: InputBorder.none,),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Director name is required';
          }
          return null;
        },
        onSaved: (String value) {
          _director = value;
        },
      ),
    );
  }

  Widget _buildMovieName() {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Color(0xFF6F35A5),
        decoration: InputDecoration(labelText: "Movie Name",
          border: InputBorder.none,),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Movie name is required';
          }
          return null;
        },
        onSaved: (String value) {
          _movieName = value;
        },
      ),
    );
  }

  Widget _buildReleaseYear() {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Color(0xFF6F35A5),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Release Year",
          border: InputBorder.none,),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Release year is required';
          }
          return null;
        },
        onSaved: (String value) {
          _releaseYear = int.parse(value);
        },
      ),
    );
  }

  Widget _buildPosterURL() {
    return TextFieldContainer(
      child: TextFormField(
        cursorColor: Color(0xFF6F35A5),
        keyboardType: TextInputType.url,
        decoration: InputDecoration(labelText: "Poster url",
          border: InputBorder.none,),
        validator: (String value) {
          if (value.isEmpty) {
            return 'Poster url is required';
          }
          return null;
        },
        onSaved: (String value) {
          _posterURL = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Wrap(
              children: [
                _buildMovieName(),
                _buildDirectorName(),
                _buildReleaseYear(),
                _buildPosterURL(),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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

                            _addMovie(context);


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
