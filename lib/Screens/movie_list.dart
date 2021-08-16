import 'package:flutter/material.dart';
import 'package:movieee_app/components/movieTile.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:provider/provider.dart';

class MovieList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: Provider.of<MoviesData>(context).movieCount,
        itemBuilder: (context, index) {
      //TODO: We are fetching movie data from the database and representing as lists over here
      return MovieTile(
          tileIndex: index,
          );
    });
  }
}
