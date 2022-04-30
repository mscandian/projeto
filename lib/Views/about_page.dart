import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/API/Characters_Response.dart';
import 'package:marvelapp/Views/characters.dart';
import 'package:marvelapp/Views/login_page.dart';

class AboutPage extends StatefulWidget {

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  CharacterResponse apiController;
  var selectedItem = '';

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
                          title: Text("Favoritos"),
                          leading: Icon(Icons.favorite)
                        ),
                        value: '/favoritos',
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
      body: SizedBox.expand(
        child: Container(
          constraints: BoxConstraints.expand(),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/about_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.only(top: 30.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 16, 
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                text: 'Trabalho de conclusão de curso em Desenvolvimento de Aplicações para Dispositivos Móveis'
              )
            ),
        ),
      ),
    );
  }
}