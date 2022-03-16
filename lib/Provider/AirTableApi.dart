
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:table_calendar_example/Provider/api.dart';

import '../utils.dart';

class AirTableApi with ChangeNotifier {


  AirTableApi(this._listEvent, this._listid);

Map<DateTime, List<Event>> _listEvent = {};
Map<DateTime, String> _listid = {};



  Map<DateTime, List<Event>> get iteams {
    return _listEvent;
  }

  Map<DateTime, String> get iteamId {
    return _listid;
  }

  Future<void> createrecord(DateTime? selecteddate
    ) async {
    var url = 'https://api.airtable.com/v0/appyFv8BdGIwO1XUF/Table%201';
print (selecteddate.toString().substring(0,10));
Random random = new Random();
int randomNumber =  random.nextInt(200) + 300;
    var body =  {
  "records": [
    {
      "fields": {
        "Name": selecteddate.toString().substring(0,10),
        "Number": randomNumber
      }
    }
    
  ]
};
    final response = await Api('keyzvxCW0Z7oOQ6bJ').post(url, body);

    var b = json.decode(response.body);

    _listEvent[DateTime.utc(int.parse( b['records'][0]['fields']['Name'].toString().split('-')[0]),int.parse( b['records'][0]['fields']['Name'].toString().split('-')[1]),int.parse( b['records'][0]['fields']['Name'].toString().split('-')[2]))]  = 
    [Event(b['records'][0]['fields']['Number'].toString())];
    _listid[DateTime.utc(int.parse( b['records'][0]['fields']['Name'].toString().split('-')[0]),int.parse( b['records'][0]['fields']['Name'].toString().split('-')[1]),int.parse( b['records'][0]['fields']['Name'].toString().split('-')[2]))]  = 
   
    
    b['records'][0]['id'];



    notifyListeners();
  }

  Future<void> listrecords() async {
    var url = "https://api.airtable.com/v0/appyFv8BdGIwO1XUF/Table%201?maxRecords=30&view=Grid%20view";
    try {
      final response = await Api('keyzvxCW0Z7oOQ6bJ').get(url);
     Map<DateTime, List<Event>> a =

      Map.fromIterable( json.decode(response.body)['records'],
  key: (i) =>  DateTime.utc(int.parse(i['fields']['Name'].toString().split('-')[0]),int.parse(i['fields']['Name'].toString().split('-')[1]),int.parse(i['fields']['Name'].toString().split('-')[2])), 
  value: (i) =>  [Event(i['fields']['Number'].toString())]);
    
     Map<DateTime, String> b =

      Map.fromIterable( json.decode(response.body)['records'],
  key: (i) =>  DateTime.utc(int.parse(i['fields']['Name'].toString().split('-')[0]),int.parse(i['fields']['Name'].toString().split('-')[1]),int.parse(i['fields']['Name'].toString().split('-')[2])), 
  value: (i) =>  i['id'].toString());
    

_listEvent = a;
_listid = b;
// _listEvent.remove(DateTime.now());
    } catch (error) {
      throw (error);
    }
    notifyListeners();
  }

Future<void> retriverecord(String? scriptId) async {
    var url = "https://api.airtable.com/v0/appyFv8BdGIwO1XUF/Table%201/recLwSJ1Vjh2Mg7Kh";
    try {
      final response = await Api('keyzvxCW0Z7oOQ6bJ').get(url);
    } catch (error) {
      throw (error);
    }
    notifyListeners();
  }

  // update board
  Future<void> updaterecord(int? listIndex, int? itemIndex, int? oldListIndex,
      int? oldItemIndex) async {

    try {
      var url = "https://api.airtable.com/v0/appyFv8BdGIwO1XUF/Table%201";

var body =  {
  "records": [
    {
      "id": "recLwSJ1Vjh2Mg7Kh",
      "fields": {
        "Name": "2022-03-01",
        "Number": 350
      }
    },
    {
      "id": "rec2XS5rWxczIIhvV",
      "fields": {
        "Name": "2022-03-02",
        "Number": 350
      }
    },
    {
      "id": "recGsoB6OzjPgT6Cq",
      "fields": {
        "Name": "2022-03-03",
        "Number": 350
      }
    }
  ]
};

      await Api('keyzvxCW0Z7oOQ6bJ').update(url, body);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }




  Future<void> deleteRecord(DateTime? selecteddate) async {
 String id =  _listid[selecteddate].toString();

    var url = 'https://api.airtable.com/v0/appyFv8BdGIwO1XUF/Table%201/$id';
 await Api('keyzvxCW0Z7oOQ6bJ').delete(url);

_listid.remove(id);
_listEvent.remove(selecteddate);
    // _listData = [];

    notifyListeners();
  }


}
