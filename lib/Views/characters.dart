import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/Models/Character.dart';
import 'package:marvelapp/API/Characters_Response.dart';
import 'package:marvelapp/Views/characters_listitem.dart';
import 'package:marvelapp/Views/characters_view.dart';
import 'package:marvelapp/Views/login_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class CharactersPage extends StatefulWidget {

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> implements CharactersView {
  CharacterResponse apiController;
  var characters = <Character>[];
  final _editTextController = TextEditingController();
  var isLoading = false;
  final ScrollController scrollController = ScrollController();
  int currentPageNumber;
  var selectedItem = '';

  @override
  void initState() {
    super.initState();
    apiController = CharacterResponse(this);
    apiController.getCharacters();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: const Image(image: AssetImage("images/logo.png"),
          fit: BoxFit.cover,
          width: 150.0),
          centerTitle: true,
          leading: IconButton(
            onPressed: (){ 
              apiController.refresh(); 
              apiController.getCharacters(); 
            },
            icon: Icon(Icons.home, size: 30.0),
          ),
          actions: [
            Padding(padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: 
              <Widget>[
                PopupMenuButton(
                  icon: const Icon(Icons.menu, size: 30.0),
                  elevation: 20,
                  enabled: true,
                  offset: const Offset(-10.0, kToolbarHeight),  
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (value) async {
                    setState(() {
                      selectedItem = value.toString();
                    });
                    if (value == '/exit') {
                      await FirebaseAuth.instance.signOut();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.blue,
                          content: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Até logo!',
                              style: TextStyle(fontSize: 14),
                              ),
                            ),
                              duration: Duration(seconds: 2),
                        )
                      );                                          
                      Navigator.pushAndRemoveUntil(context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false);
                    }
                    Navigator.pushNamed(context, value.toString());
                  }, 
                  itemBuilder: (BuildContext bc) {
                    return const [
                      PopupMenuItem(
                        child: ListTile(
                          title: Text("Favoritos"),
                          leading: Icon(Icons.favorite),
                        ),
                        value: '/favoritos', 
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          title: Text("Sobre"),
                          leading: Icon(Icons.info_outline)
                        ),
                        value: '/about',
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          title: Text("Sair"),
                          leading: Icon(Icons.exit_to_app),
                        ),
                        value: '/exit',
                      )
                    ];
                  }              
                ),
              ]))
          ]
        ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/detail_bg.jpg"),
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            fit: BoxFit.cover
          )
        ),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
              child: TextField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Procurar',
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: 'Procurar',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    borderSide: BorderSide(color: Colors.white)
                  ),
                  fillColor: Colors.grey.withOpacity(0.5),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () { _Search(); }
                  )
                            ),
                            onSubmitted: (text) {
                              _Search();
                          },
                          controller: _editTextController,
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: NotificationListener(
                  onNotification: onNotification,
                  child: GridView.builder(
                    padding: const EdgeInsets.only(top: 5.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.85,
                    ),
                    controller: scrollController,
                    itemCount: characters.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      return CharactersListItem(result: characters[index]);
                    }
                  )
                ),
              ),
            ],
          )),
    ));
  }

  addItems(List<Character> characters) {
    setState(() {
      this.characters.addAll(characters);
    });
  }

  showError() {
    print("Ocorreu um erro ou nenhum personagem encontrado");
  }

  _Search() {
    apiController.searchCharacters(_editTextController.text);
  }

  bool onNotification(ScrollNotification notification) {
    print("Notification");

    if (notification is ScrollUpdateNotification) {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        if (!isLoading) {
          apiController.getCharacters();
        }
      }
    }

    return true;
  }

  clearList() {
    setState(() {
      characters.clear();
      _editTextController.clear();
    });
  }

  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }

  showLoading() {
    setState(() {
      isLoading = true;
    });
  }


  snackBarMessage() {
    const snackBar = SnackBar(
      content: Text('Nenhum personagem encontrado!'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}

