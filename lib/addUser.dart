import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/config.dart';
import 'package:frontend/models/users.dart';
import 'package:http/http.dart' as http;

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formkey = GlobalKey<FormState>();
  late Users user;

  Future<void> addNewUser(user) async {
    var url = Uri.http(Config.server, "users");
    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(user.toJson()));
    var response = usersFromJson('[${res.body}]');

    if (response.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  Future<void> updateData(user) async {
    var url = Uri.http(Config.server, "users/${user.id}");
    var res = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(user.toJson()));
    var response = usersFromJson('[${res.body}]');

    if (response.length == 1) {
      Navigator.pop(context, "refresh");
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    try {
      user = ModalRoute.of(context)!.settings.arguments as Users;
      print(user.fullname);
    } catch (e) {
      user = Users();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                fnameInputField(),
                emailInputField(),
                passwordInputField(),
                genderInputField(),
                SizedBox(
                  height: 10,
                ),
                submitInputField()
              ],
            )),
      ),
    );
  }

  Widget fnameInputField() {
    return TextFormField(
      initialValue: user.fullname,
      decoration:
          InputDecoration(labelText: "Full name:", icon: Icon(Icons.person)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.fullname = newValue,
    );
  }

  Widget emailInputField() {
    return TextFormField(
      initialValue: user.email,
      decoration: InputDecoration(labelText: "Email:", icon: Icon(Icons.email)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        if (!EmailValidator.validate(value)) {
          return "It is not email format";
        }
        return null;
      },
      onSaved: (newValue) => user.email = newValue,
    );
  }

  Widget passwordInputField() {
    return TextFormField(
      initialValue: user.password,
      obscureText: true,
      decoration:
          InputDecoration(labelText: "Password:", icon: Icon(Icons.lock)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "This field is required";
        }
        return null;
      },
      onSaved: (newValue) => user.password = newValue,
    );
  }

  Widget genderInputField() {
    var initGen = 'None';
    try {
      if (!user.gender!.isEmpty) {
        initGen = user.gender!;
      }
    } catch (e) {
      initGen = initGen;
    }

    if (initGen == null) {
      initGen = 'None';
    }

    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: "Gender:", icon: Icon(Icons.man)),
      value: initGen,
      items: Config.gender.map((String val) {
        return DropdownMenuItem(
          child: Text(val),
          value: val,
        );
      }).toList(),
      onChanged: (value) {
        user.gender = value;
      },
      onSaved: (newValue) => user.gender,
    );
  }

  Widget submitInputField() {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(user.toJson().toString());

            if (user.id == null) {
              addNewUser(user);
            } else {
              updateData(user);
            }
          }
        },
        child: Text('Save'));
  }
}
