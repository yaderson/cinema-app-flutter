import 'package:cinema_app/src/models/movie_model.dart';
import 'package:cinema_app/src/providers/movies_provider.dart';
import 'package:flutter/material.dart';


class DataSearch extends SearchDelegate {

  String _selection;

  final moviesProvider = new MoviesProvider();

  
  @override
  List<Widget> buildActions(BuildContext context) {
    // Actions of Navbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }
  
    @override
    Widget buildLeading(BuildContext context) {
      // Icons left
      return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        },
      );
    }
  
    @override
    Widget buildResults(BuildContext context) {
      // Create results
      return Container(
        height: 100.0,
        width: 100.0,
        color: Colors.amberAccent,
        child: Text('Selection: $_selection'),
      );
    }
  
    @override
    Widget buildSuggestions(BuildContext context) {
    // Suggestions when user type
    if(query.isEmpty){
      return Container(
        child: Text('Empty'),
      );
    }else {
      return FutureBuilder(
        future: moviesProvider.searchMovie(query),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            final mo = snapshot.data;
            return ListView(
              children: _subgetsList(context, mo),
            );
            
          }else {
            return Center(
              child: CircularProgressIndicator()
            );
          }
        },
      );
    }
  }

  List <Widget> _subgetsList(BuildContext context,List<Movie> movies) {
    List <Widget> result = new List<Widget>();
    movies.forEach((movie){
      movie.uniqueId = '${movie.id}-search';
      result.add(
        ListTile(
          leading: Hero(
            tag: movie.uniqueId,
            child: Image(
              image: NetworkImage(movie.getPosterImg()),
              height: 100.0,
              width: 100.0,
            ),
          ),
          title: Text(movie.title),
          onTap: () => Navigator.pushNamed(context, 'details', arguments: movie),
        )
      );
    });

    
    return result;
  }
}