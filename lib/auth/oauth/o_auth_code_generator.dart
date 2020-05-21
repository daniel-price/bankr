import 'package:flutter_web_auth/flutter_web_auth.dart';

class OAuthCodeGenerator {
  final String _authUrl;
  final String _callbackUrlScheme;

  OAuthCodeGenerator(this._authUrl, this._callbackUrlScheme);

  Future<String> generate() async {
    final result = await FlutterWebAuth.authenticate(url: _authUrl, callbackUrlScheme: _callbackUrlScheme);
    var queryParameters = Uri.parse(result).queryParameters;
    String error = queryParameters['error'];
    if (error != null) {
      return null;
    }

    return queryParameters['code'];
  }
}
