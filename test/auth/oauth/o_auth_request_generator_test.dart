/*
import 'package:bankr/auth/oauth/auth_request_generator.dart';
import 'package:test/test.dart';

void main() {
  String identifier = 'theidentifier';
  String secret = 'thesecret';
  String redirectUrl = 'theredirectUrl';
  String code = 'thecode';
  String refreshToken = 'therefreshToken';
  var oAuthRequestGenerator = AuthRequestGenerator(identifier, secret, redirectUrl);

  group('generateAuthorizationJson', () {
    test('check returned authorization code map is correct', () {
      expect(
        oAuthRequestGenerator.generateAuthorizationJson(code),
        <String, String>{
          "grant_type": "authorization_code",
          "client_id": identifier,
          "client_secret": secret,
          "redirect_uri": redirectUrl,
          "code": code,
        },
      );
    });
  });

  group('generateRefreshJson', () {
    test('check returned refresh token map is correct', () {
      expect(
        oAuthRequestGenerator.generateRefreshJson(refreshToken),
        <String, String>{
          "grant_type": "refresh_token",
          "client_id": identifier,
          "client_secret": secret,
          "refresh_token": refreshToken,
        },
      );
    });
  });
}
*/
