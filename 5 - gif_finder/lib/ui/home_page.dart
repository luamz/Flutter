import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gif_finder/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import "package:gif_finder/ui/gif_page.dart";
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;

  int _getCount(List data) {
    if(_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length+1;
    }
  }

  Future<Map> _getGifs() async {
    http.Response response;
    if(_search == null || _search.isEmpty){
      // Trending
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=D6mst0CTRCD0h4N42v4K63EYf6X1c7pb&limit=30&rating=g");
    } else {
      // Search
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=D6mst0CTRCD0h4N42v4K63EYf6X1c7pb&q=$_search&limit=29&offset=$_offset&rating=g&lang=en");
    }

    return json.decode(response.body); // Returns a map
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black54,
      body: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  labelText: "Search a gif...",
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(color: Colors.white, fontSize: 20.0),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  // If text is submitted, do the search
                  setState(() {
                    _search = text;
                  });
                },
              )),
          Expanded(
            child: FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Container(
                        width: 200.0,
                        height: 200.0,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2.0,
                        ),
                      );
                    default:
                      if (snapshot.hasError)
                        return Container();
                      else
                        return _createGifTable(context, snapshot);
                  }
                }),
          )
        ],
      ),
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0, // Space between gifs
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          // If we are not searching and the current square isn't the last one, load the gif
          return GestureDetector(
            // Makes image clickable
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height_downsampled"]
                ["url"],
                height: 300.0,
                fit: BoxFit.cover,
              ),
            onTap: (){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> GifPage(snapshot.data["data"][index]))
              );
            },
            onLongPress: (){
              // Makes gif shareable when pressed
              Share.share( snapshot.data["data"][index]["images"]["fixed_height_downsampled"]["url"]);
            },
          );
        } else { // If we're searching and this is the last square, load the button
          return Container(
            child: GestureDetector(
              // makes the button clickable
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 60.0),
                  Text(
                    "Load more...",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ],
              ),

              onTap: () {
                setState(() {
                  _offset += 29;
                });
              },
            ),
          );
        }
      },
    );
  }
}
