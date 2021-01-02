import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance?format=json-cors&key=deec93fb";

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.green,
      primaryColor: Colors.black,
    ),
    debugShowCheckedModeBanner: false,
  ));
}

Future<Map> getData() async {
  // Returns a map of data
  http.Response response =
      await http.get(request); // We wait a few seconds until the data arrives
  return json.decode(response.body); // Converts json to a flutter map
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double argPeso;
  double dollar;
  double euro;

  final realController = TextEditingController();
  final argPesoController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    argPesoController.text = (real / argPeso).toStringAsFixed(2);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _argPesoChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double argPeso = double.parse(text);
    realController.text = (argPeso * this.argPeso).toStringAsFixed(2);
    // To real then to the correspondent currency
    dollarController.text =
        ((argPeso * this.argPeso) / dollar).toStringAsFixed(2);
    euroController.text = ((argPeso * this.argPeso) / euro).toStringAsFixed(2);
  }

  void _dollarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    // To real then to the correspondent currency
    argPesoController.text =
        ((dollar * this.dollar) / argPeso).toStringAsFixed(2);
    euroController.text = ((dollar * this.dollar) / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    // To real then to the correspondent currency
    argPesoController.text = ((euro * this.euro) / argPeso).toStringAsFixed(2);
    dollarController.text = ((euro * this.euro) / dollar).toStringAsFixed(2);
  }

  void _clearAll(){
    realController.text = "";
    argPesoController.text="";
    dollarController.text = "";
    euroController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Currency Converter",
            style: TextStyle(fontSize: 30.0),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              // Checks connection
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child: Text(
                  "Loading data...",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 50.0,
                  ),
                  textAlign: TextAlign.center,
                ));
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Error :(",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 50.0,
                    ),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  //Gets the data, each [] accesses a 'div' of the map
                  // considering real as default
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  argPeso =
                      snapshot.data["results"]["currencies"]["ARS"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 60.0),
                            child: Icon(
                              Icons.monetization_on_rounded,
                              size: 130.0,
                              color: Colors.green,
                            ),
                          ),
                          buildTextField("Brazilian Reais", "R\$ ",
                              realController, _realChanged),
                          buildTextField("Argentinian Peso", "\$ ",
                              argPesoController, _argPesoChanged),
                          buildTextField("US Dollar", "US\$ ", dollarController,
                              _dollarChanged),
                          buildTextField(
                              "Euro", "€ ", euroController, _euroChanged),
                        ]),
                  );
                }
            }
          },
        ));
  }
}

Widget buildTextField(
    String currency, String symbol, TextEditingController c, Function f) {
  return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: TextField(
          controller: c,
          decoration: InputDecoration(
            labelText: currency,
            labelStyle: TextStyle(color: Colors.green),
            border: OutlineInputBorder(),
            prefixText: symbol,
          ),
          onChanged: f,
          keyboardType: TextInputType.number,
          style: TextStyle(color: Colors.green, fontSize: 25.0)));
}