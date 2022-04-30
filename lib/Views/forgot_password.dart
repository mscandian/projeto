import 'package:flutter/material.dart';
import 'package:marvelapp/Views/login_page.dart';

class ForgotPassword extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
            image: AssetImage("images/favorites_bg2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(height: 150),
            const Padding(padding: EdgeInsets.only(right: 80),
            child: 
              Text('Esqueceu a senha?', 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold)
                )
              ),
              Padding(padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: Text('Entre com o endereço de e-mail cadastrado em sua conta.',
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontSize: 16,
                ),
              )
              ),
              SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[600].withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon:
                      Icon(Icons.email_outlined, color: Colors.white),
                      labelText: 'E-mail',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      errorStyle: TextStyle(color: Colors.yellow),
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo e-mail é obrigatório';
                      }
                        return null;
                    },
                    onSaved: (val) {
                      email = val;
                    },
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                  SizedBox(
                    height: 45,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        CircularProgressIndicator();
                        Navigator.pushReplacement(
                          context, MaterialPageRoute(
                            builder: (context) => LoginPage()
                          ))
                        ;                        
                      },                
                   style: ElevatedButton.styleFrom(
                      primary: Colors.blueAccent,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                          BorderRadius.all(
                            Radius.circular(12.0)
                          )
                      )
                    ),
                    child: Text(
                      'Redefinir Senha',
                      style: TextStyle(fontSize: 22),
                    ),
                  )),                                    
            ]
                        )
        )
      )
    );
  }
}