import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {

  ContactHelper helper = ContactHelper();
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();

    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: contacts.length,
        itemBuilder: (context, index){
          return _contactCard(context, index);
        },
      ),
    );
  }
  
  Widget _contactCard(BuildContext context, int index){
    return GestureDetector(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: contacts[index].img != null ?
                      FileImage(File(contacts[index].img)) // If the contact has a photo
                          : AssetImage("images/person.png") // Else, we use the standard
                    ),
                  ),
                ),
                Padding(padding: (
                    EdgeInsets.only(right: 20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(contacts[index].name ?? "",
                        style: TextStyle(fontSize:  20,
                        fontWeight: FontWeight.bold),),
                        Text(contacts[index].email ?? "",
                          style: TextStyle(fontSize:  18),),
                        Text(contacts[index].phone ?? "",
                          style: TextStyle(fontSize:  18,),),


                      ]
                    ),
                )

              ],
            )
        ),
      ),
    );
  }
}
