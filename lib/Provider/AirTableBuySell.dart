import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar_example/Provider/api.dart';

class AirTableBuySell with ChangeNotifier {
  AirTableBuySell(this._listBuySell, this._id);

  List _listBuySell = [];
  List _id = [];
  // Map<DateTime, String> _listid = {};

  List get iteams {
    return _listBuySell;
  }

  List get id {
    return _id;
  }

  // Map<DateTime, String> get iteamId {
  //   return _listid;
  // }

  Future<void> createrecord(int number) async {
    var url = 'https://api.airtable.com/v0/appZdnwct4lJbfJj6/Table%201';
    // print(DateTime.now().toString().substring(0, 10));

    number = number * 10;
    String date = DateTime.now().toString().substring(0, 10);
    var body = {
      "records": [
        {
          "fields": {"BuySell": date, "Number": number}
        }
      ]
    };
    final response = await Api('keyzvxCW0Z7oOQ6bJ').post(url, body);

    print(json.decode(response.body));

    var b = json.decode(response.body);

    _listBuySell.add([
      DateTime.utc(
          int.parse(
              b['records'][0]['fields']['BuySell'].toString().split('-')[0]),
          int.parse(
              b['records'][0]['fields']['BuySell'].toString().split('-')[1]),
          int.parse(
              b['records'][0]['fields']['BuySell'].toString().split('-')[2])),
      b['records'][0]['fields']['Number']
    ]);

    _id.add(b['records'][0]['id']);
    // _listid[DateTime.utc(
    //     int.parse(b['records'][0]['fields']['Name'].toString().split('-')[0]),
    //     int.parse(b['records'][0]['fields']['Name'].toString().split('-')[1]),
    //     int.parse(b['records'][0]['fields']['Name']
    //         .toString()
    //         .split('-')[2]))] = b['records'][0]['id'];
    notifyListeners();
  }

  Future<void> listrecords() async {
    var url =
        "https://api.airtable.com/v0/appZdnwct4lJbfJj6/Table%201?maxRecords=3&view=Grid%20view";

    try {
      final response = await Api('keyzvxCW0Z7oOQ6bJ').get(url);
      print(json.decode(response.body));
      List b = [];
      json.decode(response.body)['records'].forEach((i) {
        b.add([
          DateTime.utc(
              int.parse(i['fields']['BuySell'].toString().split('-')[0]),
              int.parse(i['fields']['BuySell'].toString().split('-')[1]),
              int.parse(i['fields']['BuySell'].toString().split('-')[2])),
          i['fields']['Number'] ?? 3000
        ]);
      });

      List idBuySell = [];
      json.decode(response.body)['records'].forEach((i) {
        idBuySell.add(i['id']);
      });
      print(idBuySell);
      _id = idBuySell;

      print(234234234234);

      _listBuySell = b;
    } catch (error) {
      throw (error);
    }
    notifyListeners();
  }

  Future<void> reset() async {
    print(6866878777877878787);
//  String id =  _listid[selecteddate].toString();
    print(_id);
    _id.forEach((element) async {
      var url =
          'https://api.airtable.com/v0/appZdnwct4lJbfJj6/Table%201/$element';
      var response = await Api('keyzvxCW0Z7oOQ6bJ').delete(url);
      print(json.decode(response.body));
    });
_listBuySell.clear();
    _id.clear();

    notifyListeners();
  }
}
