import 'package:cinema_app/src/models/actors_model.dart';
import 'package:cinema_app/src/models/movie_model.dart';
import 'package:cinema_app/src/providers/movies_provider.dart';
import 'package:flutter/material.dart';

class MovieDetails extends StatelessWidget{
  final _movieProvider = new MoviesProvider();
  @override
  Widget build(BuildContext context){
    final Movie movie = ModalRoute.of(context).settings.arguments;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appbar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _posterTitle(context, movie),
                _description(context, movie),
                _casting(movie.id)
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _appbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Color(0xff1db954),
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          padding: EdgeInsets.only(left: 40.0, right: 40.0),
          child: Text(movie.title, style: TextStyle(fontSize: 16.0), overflow: TextOverflow.fade, softWrap: true ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.getBackgroundImg()),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle (BuildContext context ,Movie movie) {
    return Container(
      
     
      alignment: Alignment.center,
      padding: EdgeInsets.all(30),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 150.0,
              )
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.bodyText2, overflow: TextOverflow.ellipsis),
                SizedBox(height: 10, ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Text(movie.voteAverage.toString()),
                    ),
                    Row(
                      children: _votesStars(movie.voteAverage),
                    )
                  ],
                ),
                SizedBox(height: 10, ),
                Text('Estreno: ${movie.releaseDate}', )
              ]
            ),
          )
        ],
      )
    );
  }

  Widget _description(BuildContext context ,Movie movie) {
    return Container(
      color: Colors.black12,
      padding: EdgeInsets.all(10.0),
      child: Text(movie.overview, textAlign: TextAlign.justify, style: Theme.of(context).textTheme.bodyText1,),
    );
  }

  List <Widget> _votesStars(double vote) {
    final int vot = vote.toInt();
    List <Widget> st = new List<Widget>();
    if(vote == 0){
      st.add(Icon(
        Icons.star,
        color: Colors.grey,
        size: 15,
      ));
    }
    for(int i = 0; i < vot; i++) {
      st.add(Icon(
        Icons.star,
        color: Color(0xffD4AF37),
        size: i.toDouble() +10,
      ));
    }
    return st;
  }
  
  Widget _casting (int movieId) {
    return FutureBuilder(
      future: _movieProvider.getActors(movieId.toString()),
      builder: (BuildContext context, AsyncSnapshot <List> snapshot) {
        if(snapshot.hasData){
          
          return _actorsView(snapshot.data);
        }else {
          return Container(
            height: 100.0,
            child: Center( child: CircularProgressIndicator()),
          ); 
        }
      },
    );
  }

  Widget _actorsView(List<Actor> actors) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.all(10),
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actors.length,

        itemBuilder: (context, i) {
          return _actorCard(actors[i]);
        },
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      child: Column(
       
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(actor.getProfileImg()),
              height: 150.0,
              fit: BoxFit.cover,
            )
          ),
          Container(
            child: Text(actor.name, overflow: TextOverflow.ellipsis,),
          )
        ],
      ),
    );
  }

}