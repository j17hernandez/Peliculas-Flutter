import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/peliculas_videos.dart';
import 'package:peliculas/src/providers/peliculas_providers.dart';
import 'package:share/share.dart';

class PeliculaDetalle extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula =
        ModalRoute.of(context)!.settings.arguments as Pelicula;

    return Scaffold(
        body: CustomScrollView(
          slivers: [
            _crearAppbar(pelicula),
            SliverList(
                delegate: SliverChildListDelegate([
              SizedBox(height: 10.0),
              _posterTitulo(context, pelicula),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]))
          ],
        ),
        floatingActionButton: _buttonFloating(pelicula.id.toString()));
  }

  Widget _crearAppbar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.redAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 150),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitulo(BuildContext context, Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                )),
          ),
          SizedBox(width: 20.0),
          Flexible(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pelicula.title,
                  style: Theme.of(context).textTheme.bodyText1,
                  overflow: TextOverflow.ellipsis),
              Text(pelicula.originalTitle,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis),
              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
                  Text(pelicula.voteAverage.toString(),
                      style: Theme.of(context).textTheme.subtitle1)
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        pelicula.overview,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliProvider = PeliculasProvider();
    return FutureBuilder(
      future: peliProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List<Actor> actorsList =
              snapshot.data!.map((item) => item as Actor).toList();
          return _crearActoresPageView(actorsList);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buttonFloating(String pelicula) {
    final peliProvider = PeliculasProvider();
    return FutureBuilder(
      future: peliProvider.getVideos(pelicula),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.length != 0) {
          return _floatingButton(context, snapshot.data[0]);
        } else {
          return Visibility(visible: false, child: Text(''));
        }
      },
    );
  }

  Widget _floatingButton(BuildContext context, PeliculaVideo peli) {
    // String text = 'https://www.youtube.com/watch?v=$peli';
    String subject = 'Follow me';
    return FloatingActionButton(
      child: Icon(Icons.share),
      backgroundColor: Colors.redAccent,
      onPressed: () {
        Share.share(
          peli.getUrlVideo(),
          subject: subject,
        );
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    print('actores: ${actores.length}');
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(viewportFraction: 0.3, initialPage: 1),
        itemCount: actores.length,
        itemBuilder: (context, i) => _actorTarjeta(actores[i]),
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getFoto()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }
}
