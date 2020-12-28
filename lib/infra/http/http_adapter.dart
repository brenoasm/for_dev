import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../../data/http/http.dart';

class HttpAdapter implements HttpClient {
  final Client client;

  HttpAdapter(this.client);

  Future<Map> request({
    @required String url,
    @required String method,
    Map body,
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json',
    };

    final jsonBody = body != null ? jsonEncode(body) : null;

    final result = await client.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    if (result.statusCode == 200) {
      return result.body.isEmpty ? null : jsonDecode(result.body);
    } else {
      return null;
    }
  }
}
