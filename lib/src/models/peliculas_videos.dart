class PeliculasVideo {
  List<PeliculaVideo> items = [];

  PeliculasVideo();

  PeliculasVideo.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final pelicula = new PeliculaVideo.fromJsonMap(item);
      items.add(pelicula);
    }
  }
}

class PeliculaVideo {
  late String id;
  late String? iso6391;
  late String? iso31661;
  late String key;
  late String name;
  late String site;
  late int size;
  late String type;

  PeliculaVideo({
    required this.id,
    this.iso6391,
    this.iso31661,
    required this.key,
    required this.name,
    required this.site,
    required this.size,
    required this.type,
  });

  PeliculaVideo.fromJsonMap(Map<String, dynamic> json) {
    id = json['id'].toString();
    iso6391 = json['iso6391'];
    iso31661 = json['iso31661'];
    key = json['key'].toString();
    name = json['name'];
    site = json['site'];
    size = json['size'];
    type = json['type'];
  }

  getUrlVideo() {
    if (key != null) {
      return 'https://www.youtube.com/watch?v=$key';
    }
  }
}
