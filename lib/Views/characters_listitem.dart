import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/Views/characters_detail.dart';

class CharactersListItem extends StatelessWidget {

  CharactersListItem({this.result});

  final Character result;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CharactersDetails(result)),
          );
        },
        child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            color: Colors.white,
            elevation: 5.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Image(
                    image: NetworkImageWithRetry(
                      result.thumbnail.path + "." + result.thumbnail.extension,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 30,
                  child: Center(
                    child: Text(
                      result.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                )
              ],
            )
        )
    );
  }
}
