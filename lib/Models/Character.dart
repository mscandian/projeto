import 'Comics.dart';

class Character {
  int id;
  String name;
  String description;
  String modified;
  Thumbnail thumbnail;
  String resourceURI;
  Comics comics;
  Comics series;
  Comics stories;
  Comics events;

  Character(
      {this.id,
      this.name,
      this.description,
      this.modified,
      this.thumbnail,
      this.resourceURI,
      this.comics,
      this.series,
      this.stories,
      this.events}); 

  Character.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    modified = json['modified'];
    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;
    resourceURI = json['resourceURI'];
    comics =
        json['comics'] != null ? Comics.fromJson(json['comics']) : null;
    series =
        json['series'] != null ? Comics.fromJson(json['series']) : null;
    stories =
        json['stories'] != null ? Comics.fromJson(json['stories']) : null;
    events =
        json['events'] != null ? Comics.fromJson(json['events']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['modified'] = this.modified;
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail.toJson();
    }
    data['resourceURI'] = this.resourceURI;
    if (this.comics != null) {
      data['comics'] = this.comics.toJson();
    }
    if (this.series != null) {
      data['series'] = this.series.toJson();
    }
    if (this.stories != null) {
      data['stories'] = this.stories.toJson();
    }
    if (this.events != null) {
      data['events'] = this.events.toJson();
    }
    return data;
  }
}

class CharactersResponse {
  Data data;

  CharactersResponse(this.data);

  CharactersResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
  }
}

class Data {
  int offset;
  int limit;
  int total;
  int count;
  List<Character> characters;

  Data({this.offset, this.limit, this.total, this.count, this.characters});

  Data.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
    total = json['total'];
    count = json['count'];
    if (json['results'] != null) {
      characters =  <Character>[];
      json['results'].forEach((v) {
        characters.add(Character.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['offset'] = offset;
    data['limit'] = limit;
    data['total'] = total;
    data['count'] = count;
    if (characters != null) {
      data['results'] = characters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}