import 'dart:convert';

import 'package:bankr/auth/access_token.dart';
import 'package:bankr/auth/oauth/o_auth_access_token_retriever.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutterTest;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../api/true_layer_api_adapter_test.dart';

void main() {
  flutterTest.TestWidgetsFlutterBinding.ensureInitialized();
  var mockHttp = MockHttp();
  var oAuthAccessTokenRetriever = OAuthAccessTokenRetriever(mockHttp, 'url');

  group('retrieve', () {
    test('return an access token if the retrieve access token call returns valid json', () async {
      when(
        mockHttp.doPostAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => jsonDecode(await rootBundle.loadString('assets/test/access_token.json')) as Map<String, dynamic>,
      );

      expect(
        await oAuthAccessTokenRetriever.retrieve(Map<String, String>()),
        const TypeMatcher<AccessToken>(),
      );
    });

    test('return null if the retrieve access token call returns an error', () async {
      when(
        mockHttp.doPostAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => null,
      );

      expect(
        await oAuthAccessTokenRetriever.retrieve(Map<String, String>()),
        null,
      );
    });
  });
}
