import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:marvelapp/Models/Comics.dart';

class ComicsImageScreen extends StatefulWidget {
  Comic comic;

  ComicsImageScreen(this.comic);

  @override
  State<StatefulWidget> createState() => ComicsImageScreenState();
}

class ComicsImageScreenState extends State<ComicsImageScreen> {
  Comic comic;

  @override
  void initState() {
    this.comic = widget.comic;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(comic.title),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(comic.thumbnail.path + '.' + comic.thumbnail.extension),
      )
    );   
   }
}