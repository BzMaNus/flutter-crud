import 'package:flutter/material.dart';
import 'package:frontend/addUser.dart';
import 'package:frontend/login.dart';
import 'package:frontend/models/config.dart';
import 'package:frontend/models/users.dart';
import 'package:frontend/userinfo.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  static const routeName = "/";
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget mainBody = Container();
  @override
  void initState() {
    super.initState();
    Users user = Config.login;
    if (user.id != null) {
      mainBody = showUsers();
      getUsers();
    }
  }

  List<Users> _userList = [];
  Future<void> getUsers() async {
    var url = Uri.http(Config.server, 'users');
    var res = await http.get(url);
    setState(() {
      _userList = usersFromJson(res.body);
      mainBody = showUsers();
    });
  }

  Future<void> removeUser(user) async {
    var url = Uri.http(Config.server, "users/${user.id}");
    var res = await http.delete(url);
    print('Deleted ${res}');
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const SideMenu(),
      body: mainBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String result = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserForm()));
          if (result == "refresh") {
            getUsers();
          }
        },
        child: const Icon(Icons.person_add_alt_1),
      ),
    );
  }

  Widget showUsers() {
    return ListView.builder(
      itemCount: _userList.length,
      itemBuilder: (context, index) {
        Users user = _userList[index];
        return Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => {removeUser(user)},
          background: Container(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          child: Card(
            child: ListTile(
              title: Text("${user.fullname}"),
              subtitle: Text("${user.email}"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserInfo(),
                        settings: RouteSettings(arguments: user)));
              },
              trailing: IconButton(
                  onPressed: () async {
                    String result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserForm(),
                            settings: RouteSettings(arguments: user)));
                    if (result == 'refresh') {
                      getUsers();
                    }
                  },
                  icon: Icon(Icons.edit)),
            ),
          ),
        );
      },
    );
  }
}

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    String accountName = 'N/A';
    String accountEmail = 'N/A';
    String accountUrl =
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';

    Users user = Config.login;

    if (user.id != null) {
      accountName = user.fullname ?? accountName;
      accountEmail = user.email ?? accountEmail;
      accountUrl = user.imageUrl ?? accountUrl;
    }
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          UserAccountsDrawerHeader(
              accountName: Text(accountName),
              accountEmail: Text(accountEmail),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(accountUrl),
                backgroundColor: Colors.white,
              )),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pushNamed(context, Home.routeName);
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Login'),
            onTap: () {
              Navigator.pushNamed(context, Login.routeName);
            },
          ),
        ],
      ),
    );
  }
}
