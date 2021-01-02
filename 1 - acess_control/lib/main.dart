import "package:flutter/material.dart";

void main() {
  runApp(MaterialApp(
      title: "Acess Control",
      home: Home(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _costumers = 0;
  String _infoText = "Come in!!";

  void _changeCostumers(int n) {
    setState(() {
      _costumers += n;
      if (this._costumers >= 0 && this._costumers <= 10) {
        _infoText = "Come in!!";
      } else if (this._costumers > 10) {
        if (n > 0) _costumers -= n;
        _infoText = "We're full,\n wait a few minutes!";
      } else {
        _infoText = "Are we in the upside down?!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/background.jpeg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(40.0),
              child: Text(
                "Welcome to the\nTuring Restaurant!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0,
                    decoration: TextDecoration.none),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              "Costumers inside:\n$_costumers",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0,60.0,20.0,40.0),
                  child: RaisedButton(
                    color: Colors.grey,
                    child: Text(
                      "Remove",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _changeCostumers(-1);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(20.0,60.0,20.0,40.0),
                  child: RaisedButton(
                    color: Colors.grey,
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 40.0, color: Colors.white),
                    ),
                    onPressed: () {
                      _changeCostumers(1);
                    },
                  ),
                ),
              ],
            ),

            Text(
              _infoText,
              style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontSize: 30.0,
                  decoration: TextDecoration.none),
              textAlign: TextAlign.center,
            ),
          ],
        )
      ],
    );
  }
}
