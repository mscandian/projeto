import 'package:flutter/material.dart';
import 'package:marvelapp/Auth/authentication.dart';
import 'package:marvelapp/Views/characters.dart';
import 'package:marvelapp/Views/forgot_password.dart';
import 'package:marvelapp/Views/registration_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
            image: AssetImage("images/login_bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 200),
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
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[600].withOpacity(0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Senha',
                      errorStyle: TextStyle(color: Colors.yellow),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.lock_outline,
                      color: Colors.white),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon(
                          _obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                            color: Colors.white,
                        ),
                      ),
                    ),
                    obscureText: _obscureText,
                    onSaved: (val) {
                      password = val;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo senha é obrigatório';
                      }
                        return null;
                    },
                  )
                ),
                Container(
                  padding: EdgeInsets.only(left: 200),
                  child: TextButton(
                    child: Text('Esqueci a senha',
                      style: TextStyle(color: Colors.white)),
                      onPressed: () {
                              CircularProgressIndicator();
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (context) => ForgotPassword()
                                )
                              );                        
                      },
                    )
                  ),
                  SizedBox(height: 100),
                  SizedBox(
                    height: 45,
                    width: 300,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          AuthenticationHelper()
                          .signIn(email: email, password: password)
                          .then((result) {
                            if (result == null) {
                              CircularProgressIndicator();
                              Navigator.pushReplacement(
                                context, MaterialPageRoute(
                                  builder: (context) => CharactersPage()
                                )
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                                content: Text(
                                  result,
                                  style: TextStyle(
                                    fontSize: 16, color: Colors.yellow),
                                  ),
                                )
                              );
                            }
                          }
                        );
                      }
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
                      'Login',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Ainda não tem usuário?',
                      style: TextStyle(
                        color: Colors.white, 
                        fontSize: 16
                      ),
                    ), 
                    TextButton(
                      child: const Text('Cadastre-se',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.underline
                      )
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context, MaterialPageRoute(
                              builder: (context) => RegistrationPage()
                        )
                      );
                    },
                  )
                ], 
              ),       
            ],
          ),
        )
      )
    );
  }
}
