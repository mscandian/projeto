import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/Models/Comics.dart';
import 'package:marvelapp/Views/comic_image.dart';

class ComicsListItem extends StatefulWidget {
  final Comic comic;

  const ComicsListItem({Key key, this.comic}) : super(key: key);
  
  @override
  State<ComicsListItem> createState() => _ComicsListItemState(comic);
}

class _ComicsListItemState extends State<ComicsListItem> {
  final Comic comic;

  _ComicsListItemState(this.comic);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, MaterialPageRoute(builder: (context) => ComicsImageScreen(comic))
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 5.0,
        child: Image(
          image: NetworkImageWithRetry(
            comic.thumbnail.path + "." + comic.thumbnail.extension,
          ),
          width: 100,
          height: 100,
        ),
      )
    );
  }
}