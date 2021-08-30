import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class MyRest extends StatelessWidget {

  /*Future<http.Response> fetchData() {
    return http.get(Uri.parse('https://rosso.freetzi.com/store/wp-json/wp/v2/pages/'));
  }*/
  @override
  Widget build(BuildContext context) {
    
    fetchData();

    return Container();
  }

  Future<http.Response> fetchData() async{
    final respons = await http.get(Uri.parse('https://rosso.freetzi.com/store/wp-json/wp/v2/pages/6'));
    //var parsed = jsonDecode(respons.body);
    Map<String, dynamic> parsed = jsonDecode(respons.body);
    print(parsed);
    return respons;
  }

}