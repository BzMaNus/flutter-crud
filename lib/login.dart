import 'package:flutter/material.dart';
import 'package:frontend/home.dart';
import 'package:email_validator/email_validator.dart';
import 'package:frontend/models/config.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/models/users.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  Users user = Users();

  Future<void> login(Users user, context) async {
    var params = {"email": user.email, "password": user.password};
    var url = Uri.http(Config.server, "users", params);
    var res = await http.get(url);
    print(res.body);
    List<Users> login_result = usersFromJson(res.body);
    if (login_result.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("username or password invalid")));
    } else {
      Config.login = login_result[0];
      Navigator.pushNamed(context, Home.routeName);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textHeaader(),
                emailInputField(),
                passwordInputField(),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    submitButton(context),
                    const SizedBox(
                      width: 10.0,
                    ),
                    backButton(context),
                    const SizedBox(
                      width: 10.0,
                    ),
                    regiterLink()
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget textHeaader() {
    return Container(
      child: const Center(
          child: Text(
        'Login',
        style: TextStyle(fontSize: 45),
      )),
    );
  }

  Widget emailInputField() {
    return TextFormField(
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

  Widget submitButton(context) {
    return ElevatedButton(
        onPressed: () {
          if (_formkey.currentState!.validate()) {
            _formkey.currentState!.save();
            print(user.toJson().toString());
            login(user, context);
          }
        },
        child: Text('Login'));
  }

  Widget backButton(context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, Home.routeName);
        },
        child: Text('Back'));
  }

  Widget regiterLink() {
    return InkWell(
      child: const Text('Sign Up'),
      onTap: () {},
    );
  }
}
