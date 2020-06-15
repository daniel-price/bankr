/*
import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/oauth/access_token_retriever.dart';
import 'package:bankr/auth/oauth/o_auth_authenticator.dart';
import 'package:bankr/auth/oauth/auth_code_generator.dart';
import 'package:bankr/auth/oauth/auth_request_generator.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockOAuthAccessTokenRetriever extends Mock implements OAuthAccessTokenRetriever {}

class MockOAuthCodeGenerator extends Mock implements OAuthCodeGenerator {}

void main() {
  var mockOAuthAccessTokenRetriever = MockOAuthAccessTokenRetriever();
  var mockOAuthCodeGenerator = MockOAuthCodeGenerator();

  var oAuthAuthenticator = OAuthAuthenticator(mockOAuthAccessTokenRetriever, mockOAuthCodeGenerator, OAuthRequestGenerator('identifier', 'secret', 'redirecturl'));

  group('authenticate', () {
    test('return an access token if all successful', () async {
      when(
        mockOAuthCodeGenerator.generate(),
      ).thenAnswer(
        (_) async => 'code',
      );

      when(
        mockOAuthAccessTokenRetriever.retrieve(any),
      ).thenAnswer(
        (_) async => AccessToken('a', DateTime(2020), 'c', 'd', 'e'),
      );

      expect(
        await oAuthAuthenticator.authenticate(),
        const TypeMatcher<AccessToken>(),
      );
    });

    test('throw exception if unable to get code', () {
      when(
        mockOAuthCodeGenerator.generate(),
      ).thenThrow(Exception());

      expect(
        oAuthAuthenticator.authenticate(),
        throwsException,
      );
    });

    test('throw exception if unable to retrieve token', () {
      when(
        mockOAuthAccessTokenRetriever.retrieve(any),
      ).thenThrow(Exception());

      expect(
        oAuthAuthenticator.authenticate(),
        throwsException,
      );
    });
  });

  group('refresh', () {
    test('return an access token if all successful', () async {
      when(
        mockOAuthAccessTokenRetriever.retrieve(any),
      ).thenAnswer(
        (_) async => AccessToken('a', DateTime(2020), 'c', 'd', 'e'),
      );

      expect(
        await oAuthAuthenticator.refresh('refreshToken'),
        const TypeMatcher<AccessToken>(),
      );
    });

    test('throw exception if unable to refresh', () {
      when(
        mockOAuthAccessTokenRetriever.retrieve(any),
      ).thenThrow(Exception());

      expect(
        oAuthAuthenticator.refresh('refreshToken'),
        throwsException,
      );
    });
  });
}
*/
