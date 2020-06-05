import 'dart:convert';

import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/auth/access_token_store.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/util/http.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart' as flutterTest;
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class MockHttp extends Mock implements Http {}

class MockAccount extends Mock implements Account {}

class MockAccessTokenStore extends Mock implements AccessTokenStore {}

void main() {
  flutterTest.TestWidgetsFlutterBinding.ensureInitialized();
  var mockHttp = MockHttp();
  var mockAccessTokenStore = MockAccessTokenStore();
  TrueLayerApiAdapter trueLayerApiAdapter = TrueLayerApiAdapter(mockHttp, mockAccessTokenStore);
  var mockAccount = MockAccount();

  group('retrieveAccounts', () {
	  test('return some accounts if api returns valid json', ()
	  async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
			      (_)
	      async => jsonDecode(await rootBundle.loadString('assets/test/tl_account.json')) as Map<String, dynamic>,
      );

      expect(
        await trueLayerApiAdapter.retrieveAccounts('abc', 'def'),
        const TypeMatcher<List<Account>>(),
      );
    });

	  test('return null if the account call returns an error', ()
	  async {
      when(
        mockHttp.doGetAndGetJsonResponse(any, any),
      ).thenAnswer(
			      (_)
	      async => null,
      );

      expect(
	      await trueLayerApiAdapter.retrieveAccounts('abc', 'def'),
	      null,
      );
    });
  });

  group('retrieveAccountBalance', ()
  {
	  test('return a balance if api returns valid json', ()
	  async {
		  when(
			  mockHttp.doGetAndGetJsonResponse(any, any),
		  ).thenAnswer(
					  (_)
			  async => jsonDecode(await rootBundle.loadString('assets/test/tl_account_balance.json')) as Map<String, dynamic>,
		  );

		  expect(
			  await trueLayerApiAdapter.retrieveBalance('abc', mockAccount),
			  const TypeMatcher<AccountBalance>(),
		  );
	  });

	  test('return null if the balance call returns an error', ()
	  async {
		  when(
			  mockHttp.doGetAndGetJsonResponse(any, any),
		  ).thenAnswer(
					  (_)
			  async => null,
		  );

		  expect(
			  await trueLayerApiAdapter.retrieveBalance('abc', mockAccount),
			  null,
		  );
	  });
  });

  group('retrieveTransactions', ()
  {
	  test('return some transactions if api returns valid json', ()
	  async {
		  when(
			  mockHttp.doGetAndGetJsonResponse(any, any),
		  ).thenAnswer(
					  (_)
			  async => jsonDecode(await rootBundle.loadString('assets/test/tl_account_transaction.json')) as Map<String, dynamic>,
		  );

		  when(mockAccount.accountId).thenReturn("123abc");

		  expect(
			  await trueLayerApiAdapter.retrieveTransactions('abc', mockAccount),
			  const TypeMatcher<List<AccountTransaction>>(),
		  );
	  });

	  test('returns null if the transaction call returns an error', ()
	  async {
		  when(
			  mockHttp.doGetAndGetJsonResponse(any, any),
		  ).thenAnswer(
					  (_)
			  async => null,
		  );

		  expect(
			  await trueLayerApiAdapter.retrieveTransactions('abc', mockAccount),
			  null,
		  );
	  });
  });
}
