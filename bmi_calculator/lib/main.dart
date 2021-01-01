import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _info = "Enter your measures";

  void _resetFields() {
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _info = "Enter your measures";
      _formKey = GlobalKey<FormState>();
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);

      print(imc);
      if (imc < 18.6) {
        _info = "Underweight (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 18.6 && imc < 24.9) {
        _info = "Normal weight (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 24.9 && imc < 29.9) {
        _info = "Overweight (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 29.9 && imc < 34.9) {
        _info = "Obesity I (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 34.9 && imc < 39.9) {
        _info = "Obesity II (${imc.toStringAsPrecision(3)})";
      } else if (imc >= 40) {
        _info = "Obesity III (${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetFields,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Icon(Icons.person_rounded, size: 200.0, color: Colors.deepOrange),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Weight (kg)",
                    labelStyle: TextStyle(color: Colors.deepOrange)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter your weight!";
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Height (cm)",
                    labelStyle: TextStyle(color: Colors.deepOrange)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Enter your height!";
                  }
                  return null;
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(
                  _info,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepOrange, fontSize: 25.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Container(
                  height: 80.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text(
                      "Calculate",
                      style: TextStyle(color: Colors.white, fontSize: 30.0),
                    ),
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
