
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const Map<String,String> defaultHeader = <String,String>{"Content-Type":"application/json; charset=UTF-8"};
//const String urlForInfoPosting = "https://distintivo.unam.mx/save.php";
const String urlForInfoPosting = "https://distintivo.unam.mx/prueba.php";

Future<String> httpPost({
  url = urlForInfoPosting,
  Map<String, String> headers = defaultHeader,
  Object body
}) async{
  try{
    http.Response response = await http.post(url,
      body: {'post' : jsonEncode(body)}
    );
    if(response.statusCode == 200){
      debugPrint(response.statusCode.toString());
      return response.body;
    }else{
      debugPrint(response.statusCode.toString());
      return "Failed to add a post: " + response.body;
    }
   /* var url = 'https://example.com/whatsit/create';
    var response = await http.post(urlForInfoPosting, body: {'name': 'doodle', 'color': 'blue'});
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;*/
  }catch(e){
    return "Failed to add a post: $e";
  }
}