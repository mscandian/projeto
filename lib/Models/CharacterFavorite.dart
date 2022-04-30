import 'package:cloud_firestore/cloud_firestore.dart';

class CharacterFavorite{
  int characterID;
  DocumentSnapshot<Object> documentSnapshot;
  String id;
  String characterName;
  String thumbnail;
      
  CharacterFavorite({
    this.characterID, 
    this.documentSnapshot, 
    this.id, 
    this.characterName,
    this.thumbnail
  });
}