import 'package:flutter/material.dart';
import 'package:cinema_app/src/models/movie_model.dart';


class MoviesHorizontal extends StatelessWidget {
  @override
  MoviesHorizontal({@required this.movies, @required this.nextPage});

  final List<Movie> movies;

  final Function nextPage;

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  ); 

  Widget build(BuildContext context) {
    _pageController.addListener(() { 
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        nextPage();
      }
    });
    final _screenSize = MediaQuery.of(context).size;
    return Container( 
      height: _screenSize.height * 0.25,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        //children: _cards(),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return _card(context, movies[index]);
        },
      ),
    );
  }

  Widget _card(BuildContext context,Movie movie) {
    movie.uniqueId = '${movie.id}-poster';
    final card =  Container(
      margin: EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: AssetImage('assets/loading.gif'),
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            movie.title, 
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold
            )
          )
        ],
      ),
    );

    return GestureDetector(
      child: card,
      onTap: (){
        Navigator.pushNamed(context,'details', arguments: movie);
        print('Name: ${movie.title}, Id: ${movie.id}');
      },
    );
  }

  
}
