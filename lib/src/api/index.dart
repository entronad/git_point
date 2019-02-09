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
  static const get_ = 'GET';
  static const head = 'HEAD';
  static const put = 'PUT';
  static const delete = 'DELETE';
  static const patch = 'PATCH';
  static const post = 'POST';
}

class _V3 {
  static const root = 'https://api.github.com';

  String finalizeUrl(String url) =>
    url.indexOf(_V3.root) == 0 ? url : '${_V3.root}$url';
  
  Future<http.Response> get(String url, String accessToken) async {
    final response = await 
  }
  }
}
final v3 = _V3();