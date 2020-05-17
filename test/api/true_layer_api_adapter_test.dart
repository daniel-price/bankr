import 'dart:convert';

import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';
import 'package:bankr/util/http.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutterTest;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockHttp extends Mock implements Http {}

class MockAccount extends Mock implements Account {}

void main() {
  flutterTest.TestWidgetsFlutterBinding.ensureInitialized();
  var mockHttp = MockHttp();
  TrueLayerApiAdapter trueLayerApiAdapter = TrueLayerApiAdapter(mockHttp);

  group('retrieveAccounts', () {
    test('return null if the api returns an error', () async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => <String, String>{'error': 'error'},
      );

      expect(
        await trueLayerApiAdapter.retrieveAccounts('access token', 1),
        null,
      );
    });

    test('return some accounts if api returns valid json', () async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => jsonDecode(await rootBundle.loadString('assets/test/tl_account.json')) as Map<String, dynamic>,
      );

      expect(
        await trueLayerApiAdapter.retrieveAccounts('access token', 1),
        const TypeMatcher<List<Account>>(),
      );
    });
  });

  var mockAccount = MockAccount();

  group('retrieveTransactions', () {
    test('return null if the api returns an error', () async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => <String, String>{'error': 'error'},
      );

      when(mockAccount.accountId).thenReturn("123abc");

      expect(
        await trueLayerApiAdapter.retrieveTransactions('access token', mockAccount),
        null,
      );
    });

    test('return some transactions if api returns valid json', () async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
        (_) async => jsonDecode(await rootBundle.loadString('assets/test/tl_account_transaction.json')) as Map<String, dynamic>,
      );

      when(mockAccount.accountId).thenReturn("123abc");

      expect(
        await trueLayerApiAdapter.retrieveTransactions('access token', mockAccount),
        const TypeMatcher<List<AccountTransaction>>(),
      );
    });
  });
}
