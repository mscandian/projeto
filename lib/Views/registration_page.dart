import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marvelapp/Auth/authentication.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showProgress = false;
  String email, password;

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
              Navigator.pushNamed(context, '/login');
          },
          icon: Icon(Icons.arrow_back_ios_new, size: 30.0),
        ),        
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            image: AssetImage("images/marvel1.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formkey,
          child: ModalProgressHUD(
            inAsyncCall: showProgress,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[600].withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo e-mail é obrigatório';
                      }
                        return null;
                    },                  
                    onChanged: (value) {
                      email = value; 
                    },
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.yellow),
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email_outlined, color: Colors.white
                      ),                    
                      hintText: "Insira seu e-mail"
                    )             
                  )
                ),
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[600].withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo senha é obrigatório';
                      }
                        return null;
                    },
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.yellow),
                      prefixIcon: Icon(Icons.lock_outline,
                      color: Colors.white),                    
                      border: InputBorder.none,
                      hintText: "Insira sua senha"
                    )
                  )
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 45,
                  width: 300,
                  child: ElevatedButton(onPressed: () async {
                    if (_formkey.currentState.validate()) {
                      setState(() {
                        showProgress = true;
                      });
                      try {
                        final newuser =
                        await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                        if (newuser != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.blue,
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Usuário cadastrado com sucesso! Você pode logar agora!',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          setState(() {
                            showProgress = false;
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title:
                          Text('Ops! Falha ao cadastrar usuário'),
                          content: Text('${e.message}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Okay'),
                              )
                            ],
                        ),
                      );
                      }
                      setState(() {
                        showProgress = false;
                      });
                    }                  
                  }, 
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.0)
                      )
                    )
                  ),      
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(fontSize: 22),
                  ),
                )
              )     
            ]
          )
        )
      )
    )
    );
  }
}