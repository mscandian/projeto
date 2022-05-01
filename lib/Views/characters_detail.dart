import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:marvelapp/API/Comics_APIHelper.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/Models/Comics.dart';
import 'package:marvelapp/Views/characters_details_view.dart';
import 'package:marvelapp/Views/comic_list_item.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CharactersDetails extends StatefulWidget {
  Character character;
  
  CharactersDetails(this.character);

  @override
  State<CharactersDetails> createState() => _CharactersDetailsState();
}

class _CharactersDetailsState extends State<CharactersDetails> implements CharactersDetailsView {

  ComicAPIHelper apiController;
  var comics = <Comic>[];
  var _editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = ScrollController();
  int currentPageNumber;
  Character character;
  CarouselSliderController _sliderController;
  var characters = <Character>[];
  bool isFavorite = false;
  GoogleTranslator translator = GoogleTranslator();
  String dropdownValue;
  String id;

 @override
  void initState() {
    super.initState();
    character = widget.character;
    apiController = ComicAPIHelper(this, character.id);
    apiController.getComics();
    _sliderController = CarouselSliderController();
    checkFavorite();
  }

static const Map<String, String> lang = {
    "English": "en",
    "French": "fr",
    "German": "de",
    "Japan": "ja",
    "Portuguese": "pt",
    "Spanish": "es"
  };

 void trans() {
    translator
      .translate(character.description, to: "$dropdownValue")
      .then((value) {
        setState(() {
          character.description = value.toString();
        });
      });
  }

final FirebaseAuth auth = FirebaseAuth.instance;

Future<void> checkFavorite() async {
  final User user = auth.currentUser;  
  FirebaseFirestore.instance
    .collection('characters')
    .where("characterID", isEqualTo: character.id)
    .where("emailUser", isEqualTo: user.email)
    .get()
    .then((value) async {
      if (value.docs.isNotEmpty) {
        isFavorite = value.docs.first.data()['isFavourite'];
      }
    }
  );
}

Future<void> uploadingData(bool _isFavourite) async {
  final User user = auth.currentUser;
  await FirebaseFirestore.instance.collection("characters").add({
    'characterID': character.id,
    'characterThumbUrl' : character.thumbnail.path + character.thumbnail.extension,
    'emailUser': user.email,
    'isFavourite': _isFavourite,
  });
}

Future<void> editCharacter(bool _isFavourite, String id) async {
  final User user = auth.currentUser;
  var documentID; 
  var collection = FirebaseFirestore.instance
    .collection('characters')
    .where("characterID", isEqualTo: character.id)
    .where("emailUser", isEqualTo: user.email)
    .get()
    .then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
        documentID = element.id;
        await FirebaseFirestore.instance
          .collection("characters")
          .doc(documentID)
          .update({"isFavourite": _isFavourite, "characterID": character.id});
          print("Registro atualizado");
        });
      } else {
        await FirebaseFirestore.instance.collection("characters").add({
          'characterID': character.id,
          'characterName': character.name,
          'characterThumbUrl' : character.thumbnail.path + '.' + character.thumbnail.extension,
          'emailUser': user.email,
          'isFavourite': _isFavourite,
      });
      print("Registro adicionado");      
    }
  });
}

@override
  Widget build(BuildContext context) {
    final description = character.description.isEmpty
        ? "Este personagem não possui uma descrição"
        : character.description;
        
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(character.name),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image(
                          image: NetworkImageWithRetry(character.thumbnail.path + "." + character.thumbnail.extension),
                          width: 100,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(8,0,0,0),
                            child: Text(
                              description,
                              overflow: TextOverflow.clip,
                              softWrap: true,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            hint: Text("Traduzir"),
                            elevation: 16,
                            style: TextStyle(color: Colors.black),                            
                            borderRadius: BorderRadius.circular(10),
                            underline: DropdownButtonHideUnderline(
                              child: Container(
                                height: 2,
                                color: Colors.black,
                              )
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                trans();
                              });
                            },
                            items: lang
                            .map((string, value) {
                              return MapEntry(
                                string,
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(string),
                                ),
                              );
                            })
                            .values
                            .toList(),
                          ),                                
                          IconButton(
                            icon: Icon(                              
                              isFavorite? Icons.favorite : Icons.favorite_border, 
                              color: isFavorite? Colors.red : null
                            ), 
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                                editCharacter(isFavorite, character.id.toString());
                              });
                            },
                          ),                          
                          IconButton( 
                            icon: const Icon(
                              Icons.share, color: Colors.lightBlue
                            ),
                            onPressed: () async {
                              final imageurl = character.thumbnail.path + '.' + character.thumbnail.extension;
                              final uri = Uri.parse(imageurl);
                              final response = await http.get(uri);
                              final bytes = response.bodyBytes;
                              final temp = await getTemporaryDirectory();
                              final path = '${temp.path}/image.jpg';
                              File(path).writeAsBytesSync(bytes);
                              await Share.shareFiles([path], text: 'Olha este personagem!'); 
                            },          
                          )
                        ],        
                      )
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0.0, 8, 0.0, 0.0),
                      child: const Center(
                        child: Text(
                          "Quadrinhos com este personagem",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
               Expanded(
                child: NotificationListener(
                  onNotification: onNotification,
                 child: CarouselSlider.builder(
                    unlimitedMode: true,
                    controller: _sliderController,
                    slideBuilder: (index) {
                      return ComicsListItem(comic: comics[index]);
                    },
                    slideTransform: CubeTransform(),
                    slideIndicator: CircularSlideIndicator(
                      padding: EdgeInsets.only(bottom: 32),
                      indicatorBorderColor: Colors.black,
                    ),
                    itemCount: comics.length,
                    initialPage: 0,
                    enableAutoSlider: false,                      
                  ),                     
                ),
                ),
            ],
          ),
        )
    );
  }

  @override
  addItems(List<Comic> comics) {
    setState(() {
      this.comics.addAll(comics);
    });
  }

  @override
  showError() {
    print("Ocorreu um erro ou nenhum personagem encontrado");
  }

  bool onNotification(ScrollNotification notification) {
    print("Notification");

    if (notification is ScrollUpdateNotification) {
//      if (scrollController.offset >=
//              scrollController.position.maxScrollExtent &&
//          !scrollController.position.outOfRange) {
        if (!isLoading) {
          apiController.getComics();
        }
      }
//    }

    return true;
  
  }

  @override
  clearList() {
    setState(() {
      comics.clear();
      _editTextController.clear();
    });
  }

  @override
  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

}