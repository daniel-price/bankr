import 'package:bankr/data/data_saver.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_transaction.dart';
import 'package:bankr/data/model/i_persist.dart';
import 'package:bankr/data/repository/i_dao.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../fake_data_generator.dart';

class MockDao<E extends IPersist> extends Mock implements IDao<E> {
  List<E> saved = List<E>();

  void insert(E saveableI) {
    saved.add(saveableI);
  }

  Future<List<E>> getAll() async {
    return saved;
  }
}

void main() {
  var accountDao = MockDao<Account>();
  var accountTransactionDao = MockDao<AccountTransaction>();
  var dataSaver = DataSaver(accountDao, accountTransactionDao);

  group("saveAccounts", () {
    test(
      "saves only new accounts",
      () async {
        var accounts = generateFakeAccounts("fakeAccounts1");

        await dataSaver.saveAccounts(accounts);
        accounts.addAll(generateFakeAccounts("fakeAccounts2"));
        await dataSaver.saveAccounts(accounts);

        var savedAccounts = await accountDao.getAll();
        expect(savedAccounts.length, accounts.length);
      },
    );
  });

  group("saveTransactions", () {
    test(
      "saves only new accounts",
      () async {
        var accountTransactions = generateFakeAccountTransactions("fakeAccountsTransactions1");

        await dataSaver.saveAccountTransactions(accountTransactions);
        accountTransactions.addAll(generateFakeAccountTransactions("fakeAccountsTransactions2"));
        await dataSaver.saveAccountTransactions(accountTransactions);

        var savedAccountTransactions = await accountTransactionDao.getAll();
        expect(savedAccountTransactions.length, accountTransactions.length);
      },
    );
  });
}
