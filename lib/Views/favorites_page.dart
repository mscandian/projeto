import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/Views/characters_favorites.dart';
import 'package:marvelapp/Views/characters.dart';
import 'package:marvelapp/Views/login_page.dart';

class FavoritePage extends StatefulWidget {

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {

  var selectedItem = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userLogged;

  void initState() {
    super.initState();
    checkUser();
  }

Future<void> checkUser() async {
  final User user = auth.currentUser; 
  userLogged = user.email; 
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Image(image: AssetImage("images/logo.png"),
        fit: BoxFit.cover,
        width: 150.0),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){ 
            CircularProgressIndicator();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CharactersPage()
              )
            );
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
                        title: Text("Sobre"),
                        leading: Icon(Icons.info_outline)
                      ),
                      value: '/about',
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Sair"),
                        leading: Icon(Icons.exit_to_app)
                      ),
                      value: '/exit',
                    )
                  ];
                }              
              ),
            ]
          )
        )
      ]                
    ),
    body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("images/bg1.jpg"),
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
          fit: BoxFit.cover
        )
      ),
      child: 
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
            .collection("characters")
            .where("isFavourite", isEqualTo: true)
            .where("emailUser", isEqualTo: userLogged)
            .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot data = snapshot.data.docs[index];
                  print(snapshot.data.docs.length);
                  if (data.get('isFavourite') == true && data.get('emailUser') == userLogged) {
                    return CharacterFav(
                      documentSnapshot: data,
                      id: data.id,
                      characterID: data['characterID'],
                      characterName: data['characterName'],
                      thumbnail: data['characterThumbUrl'],
                    );
                  }          
                },
              );
            }
          ),
        )
      );
    }
}