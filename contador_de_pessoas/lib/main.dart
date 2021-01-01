import "package:flutter/material.dart";

void main() {
  runApp(MaterialApp(title: "Contador de Pessoas", home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _clientes = 0;
  String _infoText = "Podem entrar!";

  void _changeClientes(int n) {
    setState(() {
      // Redesenha na tela o que mudou
      _clientes += n;
      if (this._clientes >= 0 && this._clientes <=10) {

        _infoText = "Podem entrar!!";
      }
      else if (this._clientes > 10){
        if (n>0)
          _clientes -= n;
        _infoText = "Restaurante lotado, aguardem!";
      }

      else{
        _infoText = "Mundo invertido?!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/fundo.jpeg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "Sejam\n bem-vindos\n ao\n Turing Restaurante!",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Clientes: $_clientes",
              style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: FlatButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    onPressed: () {
                      _changeClientes(1);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: FlatButton(
                    child: Text(
                      "Sair",
                      style: TextStyle(fontSize: 20.0, color: Colors.black),
                    ),
                    onPressed: () {
                      _changeClientes(-1);
                    },
                  ),
                ),
              ],
            ),
            Text(
              _infoText,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 40.0),
            )
          ],
        )
      ],
    );
  }
}
