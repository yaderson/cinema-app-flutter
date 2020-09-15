import 'package:cinema_app/src/providers/movies_provider.dart';
import 'package:cinema_app/src/search/search_delegate.dart';
import 'package:cinema_app/src/widgets/card_swiper_widget.dart';
import 'package:cinema_app/src/widgets/movie_horizontal.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final _movieProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    _movieProvider.getPopulars();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cinema App', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xff1db954),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Container(
        child: Column(
            children: <Widget>[
              _swiperCards(),
              Expanded(child: Container()),
              _footer(context)
            ],
          ),
      )
    );
  }

  Widget _footer (BuildContext context) {
    return Container(
      width: double.infinity,
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          
          Container(
            padding: EdgeInsets.only(left: 20, bottom: 10),
            child: Text('Populares', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          StreamBuilder(
            stream: _movieProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                return MoviesHorizontal(movies: snapshot.data, nextPage: _movieProvider.getPopulars);
              }else {
                return Container(
                  height: 100.0,
                  child: Center( child: CircularProgressIndicator()),
                );
              }
            },
          )
        ],
      ),
    );
  }

  Widget _swiperCards() {

    
    //final <List<Movies>> moviesGet = movieProvider.getInCine();
    return FutureBuilder(
      future: _movieProvider.getInCine(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return CardSwiper(
            movies: snapshot.data
          );
        }else {
          return Container(
            height: 400.0,
            child: Center( child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
