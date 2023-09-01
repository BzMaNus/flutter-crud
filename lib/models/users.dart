// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

List<Users> usersFromJson(String str) =>
    List<Users>.from(json.decode(str).map((x) => Users.fromJson(x)));

String usersToJson(List<Users> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Users {
  int? id;
  String? fullname;
  String? email;
  String? password;
  String? gender;
  String? imageUrl;

  Users({
    this.id,
    this.fullname,
    this.email,
    this.password,
    this.gender,
    this.imageUrl,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        fullname: json["fullname"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
        imageUrl: json["imageUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullname": fullname,
        "email": email,
        "password": password,
        "gender": gender,
        "imageUrl": imageUrl,
      };
}
