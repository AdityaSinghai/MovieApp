import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'movie.g.dart';

//This is the Movie data model

@HiveType(typeId: 0)
class Movie extends HiveObject{
  @HiveField(0)
  final String movieName;
  @HiveField(1)
  final int releaseYear;
  @HiveField(2)
  final String url;
  @HiveField(3)
  final bool isLiked;
  @HiveField(4)
  final String director;
  Movie({@required this.movieName, this.releaseYear, this.url, this.isLiked,this.director});
}
