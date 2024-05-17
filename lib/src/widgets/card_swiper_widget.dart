import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula>? peliculas;

  CardSwiper({required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        itemBuilder: (BuildContext context, int index) =>
            _tarjeta(context, peliculas![index]),
        itemCount: peliculas!.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
      ),
    );
  }

  Widget _tarjeta(context, Pelicula pelicula) {
    pelicula.uniqueId = '${pelicula.id}-card';
    final tarjeta = Hero(
      tag: pelicula.uniqueId,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(pelicula.getPosterImg()),
            placeholder: AssetImage('assets/img/no-image.jpg'),
            fit: BoxFit.cover,
          )),
    );
    return GestureDetector(
      child: tarjeta,
      onTap: () {
        Navigator.pushNamed(context, 'detalle', arguments: pelicula);
      },
    );
  }
}
