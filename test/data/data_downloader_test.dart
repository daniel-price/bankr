import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/download/data_saver.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_data_generator.dart';

class MockDataSaver extends Mock implements DataSaver {
  List<Account> savedAccounts = List<Account>();
  List<AccountTransaction> savedAccountTransactions = List<AccountTransaction>();

  Future<List<Account>> saveAccounts(List<Account> accounts) async {
    savedAccounts.addAll(accounts);
    return savedAccounts;
  }

  Future<List<AccountTransaction>> saveAccountTransactions (List<AccountTransaction> transactions)
  async {
    savedAccountTransactions.addAll(transactions);
    return savedAccountTransactions;
  }
}

class MockApiAdapter extends Mock implements IApiAdapter {}

void main() {
  group("downloadData", () {
    test("return true if data received and saved", () async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      //TODO - add retrievers and savers
      var accounts = generateFakeAccounts("fakeAccounts");
      var accountTransactions = generateFakeAccountTransactions("fakeAccountTransactions");
      var accountBalance = generateFakeAccountBalance();
      when(
        mockApiAdapter.retrieveAccounts(any, any),
      ).thenAnswer((_) async => accounts);
      when(
        mockApiAdapter.retrieveTransactions(any, any),
      ).thenAnswer((_) async => accountTransactions);
      when(
        mockApiAdapter.retrieveBalance(any, any),
      ).thenAnswer((_)
      async => accountBalance);
      //TODO
      //expect(await dataDownloader.download('uuid'), true);
      expect(mockDataSaver.savedAccounts.length, accounts.length);
      expect(mockDataSaver.savedAccountTransactions.length, accountTransactions.length * accounts.length);
    });

    test("return false if accounts not returned and make sure nothing saved", () async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      //TODO
      //var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      when(
        mockApiAdapter.retrieveAccounts(any, any),
      ).thenAnswer((_) async => null);
      //TODO
      //expect(await dataDownloader.downloadDataFirstTime('uuid'), false);
      expect(mockDataSaver.savedAccounts.length, 0);
      expect(mockDataSaver.savedAccountTransactions.length, 0);
    });

    test("return false if transactions not returned and make sure nothing saved", ()
    async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      //TODO
      //var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      var accounts = generateFakeAccounts("fakeAccountTransactions");
      var accountBalance = generateFakeAccountBalance();
      when(
        mockApiAdapter.retrieveAccounts(any, any),
      ).thenAnswer((_) async => accounts);
      when(
        mockApiAdapter.retrieveBalance(any, any),
      ).thenAnswer((_)
      async => accountBalance);
      when(
        mockApiAdapter.retrieveTransactions(any, any),
      ).thenAnswer((_) async => null);
      //TODO
      //expect(await dataDownloader.downloadDataFirstTime('uuid'), false);
      expect(mockDataSaver.savedAccounts.length, 0);
      expect(mockDataSaver.savedAccountTransactions.length, 0);
    });

    test("return false if balance not returned and make sure nothing saved", ()
    async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      //TODO
      //var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      var accounts = generateFakeAccounts("fakeAccountTransactions");
      when(
        mockApiAdapter.retrieveAccounts(any, any),
      ).thenAnswer((_)
      async => accounts);
      when(
        mockApiAdapter.retrieveBalance(any, any),
      ).thenAnswer((_)
      async => null);
      //TODO
      //expect(await dataDownloader.downloadDataFirstTime('uuid'), false);
      expect(mockDataSaver.savedAccounts.length, 0);
      expect(mockDataSaver.savedAccountTransactions.length, 0);
    });
  });
}
