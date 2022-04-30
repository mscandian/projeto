class Comics {
 
  Data data;

  Comics(this.data);

  Comics.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int offset;
  int limit;
  int total;
  int count;
  List<Comic> comics;

  Data({this.offset, this.limit, this.total, this.count, this.comics});

  Data.fromJson(Map<String, dynamic> json) {
    offset = json['offset'];
    limit = json['limit'];
    total = json['total'];
    count = json['count'];
    if (json['results'] != null) {
      comics = <Comic>[];
      json['results'].forEach((v) {
        comics.add(Comic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['offset'] = offset;
    data['limit'] = limit;
    data['total'] = total;
    data['count'] = count;
    if (comics != null) {
      data['results'] = comics.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comic {
  int id;
  String title;
  String variantDescription;
  String description;
  int pageCount;
  Thumbnail thumbnail;


  Comic(
      {this.id,
      this.title,
      this.variantDescription,
      this.description,
      this.pageCount,
      this.thumbnail});

  Comic.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    variantDescription = json['variantDescription'];
    description = json['description'];
    pageCount = json['pageCount'];

    thumbnail = json['thumbnail'] != null
        ? Thumbnail.fromJson(json['thumbnail'])
        : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['variantDescription'] = variantDescription;
    data['description'] = description;
    data['pageCount'] = pageCount;
    return data;
  }
}

class Thumbnail {
  String path;
  String extension;

  Thumbnail({this.path, this.extension});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['path'] = path;
    data['extension'] = extension;
    return data;
  }
}

class Images {
  String path;
  String extension;
  Images({this.path, this.extension});
  Images.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    extension = json['extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['path'] = path;
    data['extension'] = extension;
    return data;
  }
}