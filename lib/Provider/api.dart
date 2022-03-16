import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  String? token;
  //  = 'keyzvxCW0Z7oOQ6bJ'
  Api(this.token);

  Future post(url, body) async {
    return await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body));
  }

  Future update(url, body1) async {
    // print(json.encode(body));
    return await http.patch(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body1));
  }

  Future get(url) async {
    return await http.get(
      Uri.parse(url),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future delete(url) async {
    return await http.delete(Uri.parse(url), headers: {
      'Acceptt-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
  }
}
