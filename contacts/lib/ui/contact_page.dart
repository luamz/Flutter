import 'dart:io';

import 'package:contacts/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact}); // {} makes it optional

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  Contact _editedContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
    }

    _nameController.text = _editedContact.name;
    _emailController.text = _editedContact.email;
    _phoneController.text = _editedContact.phone;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            title: Text(_editedContact.name ?? "New Contact"), // ?? implicit if
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedContact.name.isNotEmpty && _editedContact != null) {
                Navigator.pop(context,
                    _editedContact); // Returns to home page with the current context
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.blueGrey,
          ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact
                                    .img)) // If the contact has a photo
                                : AssetImage(
                                    "images/person.png") // Else, we use the standard
                            ),
                      ),
                    ),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Name"),
                    controller: _nameController,
                    focusNode: _nameFocus,
                    onChanged: (text) {
                      _userEdited = true;
                      setState(() {
                        _editedContact.name = text;
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: _emailController,
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.email = text;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Phone"),
                    controller: _phoneController,
                    onChanged: (text) {
                      _userEdited = true;
                      _editedContact.phone = text;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                ],
              )),
        ),
        onWillPop: _requestPop);
  }

  _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Discard changes?"),
              content: Text("If you return all the changes will be discarded"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Stay")),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text("Return")),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
