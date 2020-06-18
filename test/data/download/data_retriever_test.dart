import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/download/data_retriever.dart';
import 'package:bankr/data/download/downloaded_data.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../fake_data_generator.dart';

class FakeApiAdapter extends Mock implements IApiAdapter {}

void main() {
  group('retrieveAllData', () {
    test('returns a DownloadedData if api adapter returns results', () async {
      var accountProvider = generateFakeAccountProvider();
      var accounts = generateFakeAccounts();
      var accountBalance = generateFakeAccountBalance();
      var accountTransactions = generateFakeAccountTransactions();

      DataRetriever dataRetriever = factoryFakeDataRetriever(
        accountProvider: accountProvider,
        accounts: accounts,
        accountBalance: accountBalance,
        accountTransactions: accountTransactions,
      );

      var data = await dataRetriever.retrieveAllData('uuidAccessToken');

      expect(data, TypeMatcher<DownloadedData>());
    });

    test('returns null if api adapter returns null accountProvider', () async {
      DataRetriever dataRetriever = factoryFakeDataRetriever();

      var data = await dataRetriever.retrieveAllData('uuidAccessToken');

      expect(data, null);
    });

    test('returns null if api adapter returns null accounts', () async {
      var accountProvider = generateFakeAccountProvider();

      DataRetriever dataRetriever = factoryFakeDataRetriever(
        accountProvider: accountProvider,
      );

      var data = await dataRetriever.retrieveAllData('uuidAccessToken');

      expect(data, null);
    });

    test('returns null if api adapter returns null accountBalance', () async {
      var accountProvider = generateFakeAccountProvider();
      var accounts = generateFakeAccounts();

      DataRetriever dataRetriever = factoryFakeDataRetriever(
        accountProvider: accountProvider,
        accounts: accounts,
      );

      var data = await dataRetriever.retrieveAllData('uuidAccessToken');

      expect(data, null);
    });

    test('returns null if api adapter returns null transactions', () async {
      var accountProvider = generateFakeAccountProvider();
      var accounts = generateFakeAccounts();
      var accountBalance = generateFakeAccountBalance();

      DataRetriever dataRetriever = factoryFakeDataRetriever(
        accountProvider: accountProvider,
        accounts: accounts,
        accountBalance: accountBalance,
      );

      var data = await dataRetriever.retrieveAllData('uuidAccessToken');

      expect(data, null);
    });
  });
}

DataRetriever factoryFakeDataRetriever({AccountProvider accountProvider, List<Account> accounts, AccountBalance accountBalance, List<AccountTransaction> accountTransactions}) {
  var fakeApiAdapter = FakeApiAdapter();
  when(
    fakeApiAdapter.retrieveAccountProvider(any),
  ).thenAnswer(
    (_) async => accountProvider,
  );
  when(
    fakeApiAdapter.retrieveAccounts(any, any),
  ).thenAnswer(
    (_) async => accounts,
  );
  when(
    fakeApiAdapter.retrieveTransactions(any, any, any),
  ).thenAnswer(
    (_) async => accountTransactions,
  );
  when(
    fakeApiAdapter.retrieveBalance(any, any),
  ).thenAnswer(
    (_) async => accountBalance,
  );
  var dataRetriever = DataRetriever(fakeApiAdapter);
  return dataRetriever;
}
