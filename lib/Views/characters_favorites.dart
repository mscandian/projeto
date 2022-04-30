import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/network.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/Views/characters_detail.dart';

class CharacterFav extends StatelessWidget {
        int characterID;
        DocumentSnapshot<Object> documentSnapshot;
        String id;
        String characterName;
        String thumbnail;
      
      CharacterFav({
        this.characterID, 
        this.documentSnapshot, 
        this.id, 
        this.characterName,
        this.thumbnail, this.result
      });

 
  final Character result;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      color: Colors.white,
      elevation: 10.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: NetworkImageWithRetry(
                  thumbnail,
                ),
                fit: BoxFit.cover,
                width: 100,
                height: 100,    
              )
            ]
          ),
          Column(
            children:[
              SizedBox( 
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.only(left: 5),
                child:
                  Text(                  
                    characterName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  )
              )
            ]
          ),    
        ]
      )
    );     
  }
}

