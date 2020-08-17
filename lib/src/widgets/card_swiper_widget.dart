import 'package:cinema_app/src/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  @override
  CardSwiper({@required this.movies});

  final List<Movie> movies;

  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Swiper(
          itemBuilder: (BuildContext context, int index) {
            movies[index].uniqueId = '${movies[index].id}-cards';
            return Container(
              
              child: Column(
                children: <Widget>[
                  Hero(
                    tag: movies[index].uniqueId,
                    child: _cardBody(context, movies[index]),
                  ),
                  _cardBottom(movies[index].voteAverage)
                ],
              ),
            );
          },
          itemHeight: _screenSize.height * 0.55,
          itemWidth: _screenSize.width * 0.5,
          itemCount: movies.length,
          layout: SwiperLayout.STACK
          // pagination: new SwiperPagination(),
          // control: new SwiperControl(),
          ),
    );
  }

  Widget _cardBody(BuildContext context,Movie movie) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => Navigator.pushNamed(context,'details', arguments: movie),
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10)),
            child: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage(movie.getPosterImg()),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Tooltip(
          
          message: movie.releaseDate,
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Icon(Icons.info, color: Colors.white)
          ),
        ),
      ],
    );
  }

  Widget _cardBottom(double vote) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(10),
      bottomLeft: Radius.circular(10)),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 4, color: Color(0xff1db954))
              ),
              color: Color(0xff121212)
            ),
            width: 500,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(vote.toString(), style: TextStyle(fontSize: 15, color: Colors.white),),
                Row( children: _votesStars(vote))
              ],
            ),
          )
        ],
      ),
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
}
