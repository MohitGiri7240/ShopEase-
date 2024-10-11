import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_application_1/Homepage.dart';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppApi {
  String kBaseUrl = "https://reqres.in/api/login";
//post type
  Future LoginApi(
      {required String email,
      required String password,
      required BuildContext context}) async {
    final userHeader = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    Uri url = Uri.parse("https://reqres.in/api/login");
    try {
      http.Response response = await http.post(url,
          body: jsonEncode({"email": email, "password": password}),
          headers: userHeader);
      final data = jsonDecode(response.body);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return Home();
      }));
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('isLogin', true);
      print(data);
      print(data["statusCode"]);
   
      print(data);
    } catch (e) {}
  }


}