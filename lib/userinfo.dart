import 'package:flutter/material.dart';

import 'models/users.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    Users user = ModalRoute.of(context)!.settings.arguments as Users;
    return Scaffold(
      appBar: AppBar(title: Text('User Info')),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Card(
          child: ListView(children: [
            ListTile(
              title: Text('Full Name'),
              subtitle: Text('${user.fullname}'),
            ),
            ListTile(
              title: Text('Email'),
              subtitle: Text('${user.email}'),
            ),
            ListTile(
              title: Text('Gender'),
              subtitle: Text('${user.gender}'),
            )
          ]),
        ),
      ),
    );
  }
}
