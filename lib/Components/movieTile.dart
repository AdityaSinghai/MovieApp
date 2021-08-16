import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movieee_app/models/movie.dart';
import 'package:movieee_app/models/movie_data.dart';
import 'package:movieee_app/screens/editForm.dart';
import 'package:provider/provider.dart';

class MovieTile extends StatelessWidget {
  final int tileIndex;

  MovieTile({this.tileIndex});

  @override
  Widget build(BuildContext context) {
    void _likedButtonToggle(context, Movie currentMovie) {
      Provider.of<MoviesData>(context, listen: false).toggleLike(
          movie: Movie(
            movieName: currentMovie.movieName,
            releaseYear: currentMovie.releaseYear,
            url: currentMovie.url,
            isLiked: !currentMovie.isLiked,
            director: currentMovie.director,
          ),
          movieKey: currentMovie.key);
    }

    void _showDeleteConfirmation(currentClient) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      'You are about to delete ${currentClient.movieName} and all of their content.'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'You cannot undo this action.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  print("Deleting ${currentClient.movieName}...");
                  Provider.of<MoviesData>(context, listen: false)
                      .deleteMovie(currentClient.key);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  print("Canceled delete.");
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      child: Consumer<MoviesData>(builder: (context, movieData, child) {
        Movie currentMovie = movieData.getMovie(tileIndex);
        return Stack(
          children: [

            Container(
              height: MediaQuery.of(context).size.height*0.11,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height*0.2,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width*0.25,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(2,5), // changes position of shadow
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(
                            currentMovie.url,
                          ),
                          fit: BoxFit.fill
                        ),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  SizedBox(width: 50  ,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentMovie.movieName,
                          softWrap: true,
                          style:
                      TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      )),
                      Text(currentMovie.releaseYear.toString(),style: TextStyle(
                        color: Colors.black45
                      ),),
                      Row(
                        children: [
                          Text("Director: ",style: TextStyle(fontWeight: FontWeight.bold),),
                          Text(currentMovie.director,
                          softWrap: true,),
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //TODO: This button is used to edit the movie information
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              Provider.of<MoviesData>(context, listen: false)
                                  .setActiveMovie(currentMovie.key);

                              showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                                  ),
                                isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: MediaQuery.of(context).size.height*0.6,
                                            child: EditMovie(currentMovie: currentMovie)),
                                      ));
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Provider.of<MoviesData>(context, listen: false)
                                    .setActiveMovie(currentMovie.key);

                                _showDeleteConfirmation(currentMovie);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color:
                                currentMovie.isLiked ? Colors.red : Colors.black12,
                              ),
                              onPressed: () {
                                _likedButtonToggle(context, currentMovie);
                              })
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
