import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plastic/model/sample_model.dart';
import 'package:postgres/postgres.dart';
import 'package:http/http.dart' as http;

class DatabaseService extends ChangeNotifier{
  var connection = PostgreSQLConnection("10.0.2.2", 5432, "plasticdb", username: "postgres", password: "176369",);

  initDatabaseConnection(String title, String subtitle, double lat, double long, String files, String typ) async {
    if(connection.isClosed){
      await connection.open().then((value) {
        debugPrint("Database Connected!");
      });
    }

    final data = <String, dynamic>{
      "title": title,
      "subtitle": subtitle,
      "datetime": DateTime.now(),
      "lat": lat,
      "lng": long,
      "files": files,
      "typ": typ
    };
    await setData(connection, "shares", data);
    debugPrint('İŞLEM BİTTİ');
    //await connection.close();


  }
  Future<void> setData(PostgreSQLConnection connection, String table,
      Map<String, dynamic> data) async {
    await connection.execute(
        'INSERT INTO $table (${data.keys.join(', ')}) VALUES (${data.keys.map((k) => '@$k').join(', ')})',
        substitutionValues: data);

  }

  Future<List<SampleModel>> getData() async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3000/users'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return SampleModel.fromJson(jsonDecode(response.body));


      return [
        for (final item in jsonDecode(response.body)) SampleModel.fromJson(item),
      ];
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load data');
    }
  }
}