import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar_example/Provider/api.dart';


class AirTableBuySell with ChangeNotifier {
  AirTableBuySell(this._listBuySell,);

  Map<DateTime, int> _listBuySell = {};
  // Map<DateTime, String> _listid = {};

  Map<DateTime, int> get iteams {
    return _listBuySell;
  }

  // Map<DateTime, String> get iteamId {
  //   return _listid;
  // }

  Future<void> createrecord(int number) async {
    var url = 'https://api.airtable.com/v0/appZdnwct4lJbfJj6/Table%201';
    // print(DateTime.now().toString().substring(0, 10));
    String date = DateTime.now().toString().substring(0, 10);
    var body = {
      "records": [
        {
          "fields": {"Name": date, "Number": number}
        }
      ]
    };
    final response = await Api('keyzvxCW0Z7oOQ6bJ').post(url, body);

    var b = json.decode(response.body);

    _listBuySell[DateTime.utc(
        int.parse(b['records'][0]['fields']['BuySell'].toString().split('-')[0]),
        int.parse(b['records'][0]['fields']['BuySell'].toString().split('-')[1]),
        int.parse(
            b['records'][0]['fields']['BuySell'].toString().split('-')[2]))] = 
      b['records'][0]['fields']['Number']
    ;
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
      Map<DateTime, int> a = Map.fromIterable(
          json.decode(response.body)['records'],
          key: (i) => DateTime.utc(
              int.parse(i['fields']['BuySell'].toString().split('-')[0]),
              int.parse(i['fields']['BuySell'].toString().split('-')[1]),
              int.parse(i['fields']['BuySell'].toString().split('-')[2])),
          value: (i) => i['fields']['Number']??3000);

      // Map<DateTime, String> b = Map.fromIterable(
      //     json.decode(response.body)['records'],
      //     key: (i) => DateTime.utc(
      //         int.parse(i['fields']['BuySell'].toString().split('-')[0]),
      //         int.parse(i['fields']['BuySell'].toString().split('-')[1]),
      //         int.parse(i['fields']['BuySell'].toString().split('-')[2])),
      //     value: (i) => i['id'].toString());
print(a);

      _listBuySell = a;
    } catch (error) {
      throw (error);
    }
    notifyListeners();
  }
}
