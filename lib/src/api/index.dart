import 'dart:convert';

import 'package:http/http.dart' as http;

// These keys are for development purposes and do not represent the actual application keys.
// Feel free to use them or use a new set of keys by creating an OAuth application of your own.
// https://github.com/settings/applications/new

// PREFER using lowerCamelCase for constant names.
const clientId = '87c7f05700c052937cfb';
const clientSecret = '3a70aee4d5e26c457720a31c3efe2f9062a4997a';

class _Accept {
  static const diff = 'application/vnd.github.v3.diff+json';
  static const full = 'application/vnd.github.v3.full+json';
  static const html = 'application/vnd.github.v3.html+json';
  static const json = 'application/vnd.github.v3+json';
  static const mercyPreview = 'application/vnd.github.mercy-preview+json';
  static const raw = 'application/vnd.github.v3.raw+json';
}

class _Method {
  static const get = 'GET';
  static const head = 'HEAD';
  static const put = 'PUT';
  static const delete = 'DELETE';
  static const patch = 'PATCH';
  static const post = 'POST';
}

class _Parameters {
  String method;
  Map<String, String> headers;
  String body;

  _Parameters(
    String accessToken,
    [
      String method = _Method.get,
      String accept = _Accept.json,
      Object body = const {},
    ]
  ) {
    const withBody = [_Method.put, _Method.patch, _Method.post];
    this.method = method;
    headers = {
      'Accept': accept,
      'Authorization': 'token $accessToken',
      'Cache-Control': 'no-cache',
    };

    if (withBody.contains(method)) {
      this.body = json.encode(body);
      if (method == _Method.put) {
        headers['Content-Length'] = '0';
      }
    }
  }
}

class _V3 {
  static const root = 'https://api.github.com';

  Future<http.Response> call(String url, _Parameters parameters) async {
    final finalUrl = url.indexOf(_V3.root) == 0 ? url : '${_V3.root}$url';
    var response;
    switch (parameters.method) {
      case _Method.get:
        response = await http.get(finalUrl, headers: parameters.headers);
        break;
      case _Method.head:
        response = await http.head(finalUrl, headers: parameters.headers);
        break;
      case _Method.put:
        response = await http.put(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      case _Method.delete:
        response = await http.delete(finalUrl, headers: parameters.headers);
        break;
      case _Method.patch:
        response = await http.patch(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      case _Method.post:
        response = await http.post(finalUrl, headers: parameters.headers, body: parameters.body);
        break;
      default:
    }

    return response;
  } 
  
  Future<int> count(String url, String accessToken) async {
    final finalUrl = url.contains('?') ? '$url&per_page=1' : '$url?per_page=1';
    final response = await get(url, accessToken);

    if (response.statusCode == 404) {
      return 0;
    }

    var linkHeader = response.headers['Link'];
    var number;

    if (linkHeader != null) {
      linkHeader = RegExp(r'/page=(\d)+/g')
        .allMatches(linkHeader)
        .toList()
        .last
        .group(0);
      number = linkHeader.split('=').last;
    } else {
      number = json.decode(response.body).length;
    }

    return number;
  }

  Future<http.Response> get(String url, String accessToken) async {
    final response = await call(url, _Parameters(accessToken));

    return response;
  }
}
final v3 = _V3();