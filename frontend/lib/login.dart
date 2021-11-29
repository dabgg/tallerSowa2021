import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytracker/mapvista.dart';
import 'package:mytracker/user.dart';

class LoginView extends StatefulWidget {
  LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  Future save() async {
    var res = await http.post("http://localhost:8080/login",
        headers: <String, String>{
          'Context-Type': 'application/json;charSet=UTF-8'
        },
        body: <String, String>{
          'nickname': user.nickname,
          'password': user.password
        });
    print(res.body);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => MapView()));
  }

  User user = User('', '');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50.1,
                backgroundColor: Colors.blue,
                backgroundImage: AssetImage('assets/images/logoCamion.jpg'),
              ),
              Text(
                'Login',
                style: TextStyle(fontFamily: 'BebasNeue', fontSize: 40.0),
              ),
              SizedBox(
                width: 160.0,
                height: 60.0,
                child: Divider(color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: TextEditingController(text: user.nickname),
                  onChanged: (value) {
                    user.nickname = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Escribe algo';
                    } else if (value.length < 25) {
                      return 'El nickname debe ser de a lo menos 25 caracteres';
                    } else {
                      return 'Enter valid nickname';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Ingrese nombre de usuario',
                      labelText: 'NOMBRE DE USUARIO',
                      suffixIcon: Icon(Icons.verified_user),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              SizedBox(
                width: 0.0,
                height: 10.0,
                child: Divider(color: Colors.black87),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: TextEditingController(text: user.password),
                  onChanged: (value) {
                    user.nickname = value;
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Escribe algo';
                    } else if (value.length < 4) {
                      return 'El contraseña debe ser de a lo menos 4 caracteres';
                    } else {
                      return 'Enter valid password';
                    }
                  },
                  decoration: InputDecoration(
                      hintText: 'Ingrese contraseña',
                      labelText: 'CONTRASEÑA',
                      suffixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Divider(
                height: 15.0,
              ),
              SizedBox(
                // ignore: todo
                /* EN ESTE SIZEDBOX TIENE QUE ESTAR TODO EL TEMA DE LA AUTH, SEGUN EL VIDEO QUE COMPARTI*/
                child: FlatButton(
                  hoverColor: Colors.lightBlue,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30.0,
                        fontFamily: 'BebasNeue'),
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    Route route = MaterialPageRoute(builder: (bc) => MapView());
                    Navigator.of(context).push(route);
                  },
                ),
              ) //ESTE ES EL FINAL DE SIZEDBOX
              /*SizedBox(
                // ignore: todo
                /* EN ESTE SIZEDBOX TIENE QUE ESTAR TODO EL TEMA DE LA AUTH, SEGUN EL VIDEO QUE COMPARTI*/
                child: FlatButton(
                  hoverColor: Colors.lightBlue,
                  child: Text(
                    'Iniciar sesión',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 30.0,
                        fontFamily: 'BebasNeue'),
                  ),
                  color: Colors.blue,
                  
                  onPressed: () {
                    Route route =
                        MaterialPageRoute(builder: (bc) => MyHomePage());
                    Navigator.of(context).push(route);
                  },
                ),
              ) //ESTE ES EL FINAL DE SIZEDBOX*/
            ],
          )
        ],
      ),
    );
  }
}
