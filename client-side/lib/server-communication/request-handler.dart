import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/database.dart';

class RequestHandler {
  RequestHandler._privateConstructor();
  static final RequestHandler _request_handler_instance =
      RequestHandler._privateConstructor();
  factory RequestHandler() {
    return _request_handler_instance;
  }

  var _ip = DataBase().ip;
  var _is_http = DataBase().is_http;

  void set ip(String ip) {
    _ip = ip;
  }

  void set is_http(bool value) {
    _is_http = value;
  }

  Future<String> clipboard_get_request() async {
    try {
      final response = await http.get(
          _is_http ? Uri.http(_ip, 'api') : Uri.https(_ip, 'api'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['text_field'];
      } else {
        return "";
      }
    } catch (_) {
      return "";
    }
  }

  void clipboard_post_request(String text_field) async {
    try {
      final response = await http.post(
          _is_http ? Uri.http(_ip, 'api') : Uri.https(_ip, 'api'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'text_field': text_field}));
    } catch (_) {
      print("catch called in clipboard_post_request");
    }
  }

  Future<String> get_a_quote() async {
    try {
      final response = await http.get(
        Uri.http("quotes.stormconsultancy.co.uk", "random.json"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['quote'];
      } else {
        return "";
      }
    } catch (_) {
      return "";
    }
  }
}
