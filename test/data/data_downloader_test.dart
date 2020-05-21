import 'package:bankr/api/i_api_adapter.dart';
import 'package:bankr/data/data_downloader.dart';
import 'package:bankr/data/data_saver.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_data_generator.dart';

class MockDataSaver extends Mock implements DataSaver {
  int savedAccounts = 0;
  int savedAccountTransactions = 0;

  void saveAccounts(List<Account> accounts) {
    savedAccounts += accounts.length;
  }

  void saveAccountTransactions(List<AccountTransaction> transactions) {
    savedAccountTransactions += transactions.length;
  }
}

class MockApiAdapter extends Mock implements IApiAdapter {}

void main() {
  group("downloadData", () {
    test("return true if data received and saved", () async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      var accounts = generateFakeAccounts("fakeAccounts");
      var accountTransactions = generateFakeAccountTransactions("fakeAccountTransactions");
      when(
        mockApiAdapter.retrieveAccounts(any),
      ).thenAnswer((_) async => accounts);
      when(
        mockApiAdapter.retrieveTransactions(any, any),
      ).thenAnswer((_) async => accountTransactions);
      expect(await dataDownloader.downloadData(1), true);
      expect(mockDataSaver.savedAccounts, accounts.length);
      expect(mockDataSaver.savedAccountTransactions, accountTransactions.length * accounts.length);
    });

    test("return false if accounts not returned and make sure nothing saved", () async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      when(
        mockApiAdapter.retrieveAccounts(any),
      ).thenAnswer((_) async => null);
      expect(await dataDownloader.downloadData(1), false);
      expect(mockDataSaver.savedAccounts, 0);
      expect(mockDataSaver.savedAccountTransactions, 0);
    });

    test("return false if accounts not returned and make sure nothing saved", () async {
      var mockDataSaver = MockDataSaver();
      var mockApiAdapter = MockApiAdapter();
      var dataDownloader = DataDownloader(mockApiAdapter, mockDataSaver);
      var accounts = generateFakeAccounts("fakeAccountTransactions");
      when(
        mockApiAdapter.retrieveAccounts(any),
      ).thenAnswer((_) async => accounts);
      when(
        mockApiAdapter.retrieveTransactions(any, any),
      ).thenAnswer((_) async => null);
      expect(await dataDownloader.downloadData(1), false);
      expect(mockDataSaver.savedAccounts, 0);
      expect(mockDataSaver.savedAccountTransactions, 0);
    });
  });
}
