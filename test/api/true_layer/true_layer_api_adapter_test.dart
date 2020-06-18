import 'dart:convert';

import 'package:bankr/api/true_layer/true_layer_account_provider_reference_data.dart';
import 'package:bankr/api/true_layer/true_layer_api_adapter.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:mockito/mockito.dart';
import 'package:oauth_http/oauth_http.dart';
import 'package:test/test.dart';

import '../../fake_data_generator.dart';

class FakeOAuthHttp extends Mock implements OAuthHttp {}

void main() {
  group('retrieveAccountProvider', () {
    test('return an account balance if api returns valid json', () async {
      var accountBalanceResults = generateResponseFromJsonString(
          '{"results":[{"client_id":"test","credentials_id":"6L7RxyPKX0THy1tw93PB4V+8DB+KjnX9Pxa451yXPu0=","consent_status":"Authorised","consent_status_updated_at":"2020-05-24T15:44:40.077Z","consent_created_at":"2020-05-24T14:44:40.077Z","consent_expires_at":"2020-08-24T14:44:40.077Z","provider":{"display_name":"Lloyds Bank","logo_uri":"https://auth.truelayer.com/img/banks/banks-icons/lloyds-icon.svg","provider_id":"lloyds"},"scopes":["info","accounts","balance","transactions","cards","offline_access"],"privacy_policy":"Feb2019"}]}');
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(accountBalanceResults);

      var balance = await trueLayerApiAdapter.retrieveAccountProvider('uuidAccessToken');

      expect(balance, TypeMatcher<AccountProvider>());
    });

    test('return null if api results are null', () async {
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(null);

      var balance = await trueLayerApiAdapter.retrieveAccountProvider('uuidAccessToken');

      expect(balance, null);
    });
  });

  group('retrieveAccounts', () {
    test('return some accounts if api returns valid json', () async {
      var accountsResults = generateResponseFromJsonString(
          '{"results":[{"update_timestamp":"2017-02-07T17:29:24.740802Z","account_id":"f1234560abf9f57287637624def390871","account_type":"TRANSACTION","display_name":"Club Lloyds","currency":"GBP","account_number":{"iban":"GB35LOYD12345678901234","number":"12345678","sort_code":"12-34-56","swift_bic":"LOYDGB2L"},"provider":{"display_name":"Lloyds Bank","logo_uri":"https://auth.truelayer.com/img/banks/banks-icons/lloyds-icon.svg","provider_id":"lloyds"}},{"update_timestamp":"2017-02-07T17:29:24.740802Z","account_id":"f1234560abf9f57287637624def390872","account_type":"SAVINGS","display_name":"Club Lloyds","currency":"GBP","account_number":{"iban":"GB35LOYD12345678901235","number":"12345679","sort_code":"12-34-57","swift_bic":"LOYDGB2L"},"provider":{"display_name":"Lloyds Bank","logo_uri":"https://auth.truelayer.com/img/banks/banks-icons/lloyds-icon.svg","provider_id":"lloyds"}}]}');
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(accountsResults);

      var accounts = await trueLayerApiAdapter.retrieveAccounts('uuidAccessToken', 'uuidProvider');

      expect(accounts, TypeMatcher<List<Account>>());
    });

    test('return null if api results are null', () async {
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(null);

      var accounts = await trueLayerApiAdapter.retrieveAccounts('uuidAccessToken', 'uuidProvider');

      expect(accounts, null);
    });
  });

  group('retrieveBalance', () {
    test('return an account balance if api returns valid json', () async {
      var accountBalanceResults =
          generateResponseFromJsonString('{"results":[{"currency":"GBP","available":1161.2,"current":1161.2,"overdraft":1000,"update_timestamp":"2017-02-07T17:33:30.001222Z"}]}');
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(accountBalanceResults);

      var account = generateFakeAccount('accountId');
      var balance = await trueLayerApiAdapter.retrieveBalance('uuidAccessToken', account);

      expect(balance, TypeMatcher<AccountBalance>());
    });

    test('return null if api results are null', () async {
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(null);

      var account = generateFakeAccount('accountId');
      var balance = await trueLayerApiAdapter.retrieveBalance('uuidAccessToken', account);

      expect(balance, null);
    });
  });

  group('retrieveTransactions', () {
    test('return AccountTransactions if api returns valid json', () async {
      var accountBalanceResults = generateResponseFromJsonString(
          '{"results":[{"transaction_id":"03c333979b729315545816aaa365c33f","timestamp":"2018-03-06T00:00:00","description":"GOOGLE PLAY STORE","amount":-2.99,"currency":"GBP","transaction_type":"DEBIT","transaction_category":"PURCHASE","transaction_classification":["Entertainment","Games"],"merchant_name":"Google play","running_balance":{"amount":1238.6,"currency":"GBP"},"meta":{"bank_transaction_id":"9882ks-00js","provider_transaction_category":"DEB"}},{"transaction_id":"3484333edb2078e77cf2ed58f1dec11e","timestamp":"2018-02-18T00:00:00","description":"PAYPAL EBAY","amount":-25.25,"currency":"GBP","transaction_type":"DEBIT","transaction_category":"PURCHASE","transaction_classification":["Shopping","General"],"merchant_name":"Ebay","meta":{"bank_transaction_id":"33b5555724","provider_transaction_category":"DEB"}}]}');
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(accountBalanceResults);

      var account = generateFakeAccount('accountId');
      var balance = await trueLayerApiAdapter.retrieveTransactions('uuidAccessToken', account);

      expect(balance, TypeMatcher<List<AccountTransaction>>());
    });

    test('return null if api results are null', () async {
      TrueLayerApiAdapter trueLayerApiAdapter = factoryTrueLayerApiAdapterForResults(null);

      var account = generateFakeAccount('accountId');
      var balance = await trueLayerApiAdapter.retrieveTransactions('uuidAccessToken', account);

      expect(balance, null);
    });
  });
}

List generateResponseFromJsonString(String jsonString) {
  var jsonMap = json.decode(jsonString);
  return jsonMap['results'];
}

TrueLayerApiAdapter factoryTrueLayerApiAdapterForResults(List response) {
  var accountProviderReferenceDataById = factoryAccountProviderReferenceDataById();
  var fakeOAuthHttp = FakeOAuthHttp();
  when(
    fakeOAuthHttp.doGet(any, any),
  ).thenAnswer(
    (_) async => response,
  );
  var trueLayerApiAdapter = TrueLayerApiAdapter(fakeOAuthHttp, accountProviderReferenceDataById);
  return trueLayerApiAdapter;
}
