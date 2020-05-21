import 'package:bankr/data/json/model_json_converters.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_data_generator.dart';

void main() {
  group("accountJsonConverter", () {
    test("doing toMap and fromMap gives the original account", () {
      var originalAccount = generateFakeAccount("accountId1");
      var accountJsonConverter = AccountJsonConverter();
      var map = accountJsonConverter.toMap(originalAccount);
      var finalAccount = accountJsonConverter.fromMap(map);

      expect(originalAccount.updateTimestamp, finalAccount.updateTimestamp);
      expect(originalAccount.accountId, finalAccount.accountId);
      expect(originalAccount.accountType, finalAccount.accountType);
      expect(originalAccount.name, finalAccount.name);
      expect(originalAccount.currency, finalAccount.currency);
      expect(originalAccount.iban, finalAccount.iban);
      expect(originalAccount.swiftBic, finalAccount.swiftBic);
      expect(originalAccount.number, finalAccount.number);
      expect(originalAccount.sortCode, finalAccount.sortCode);
      expect(originalAccount.providerName, finalAccount.providerName);
      expect(originalAccount.providerId, finalAccount.providerId);
      expect(originalAccount.logoUri, finalAccount.logoUri);
      expect(originalAccount.keyAccessToken, finalAccount.keyAccessToken);
      expect(originalAccount.key, finalAccount.key);
    });
  });

  group("accountTransactionJsonConverter", () {
    test("doing toMap and fromMap gives the original transaction", () {
      var originalAccountTransaction = generateFakeAccountTransaction("transactionId1");
      var transactionJsonConverter = AccountTransactionJsonConverter();
      var map = transactionJsonConverter.toMap(originalAccountTransaction);
      var finalAccountTransaction = transactionJsonConverter.fromMap(map);

      expect(originalAccountTransaction.timestamp, finalAccountTransaction.timestamp);
      expect(originalAccountTransaction.description, finalAccountTransaction.description);
      expect(originalAccountTransaction.transactionType, finalAccountTransaction.transactionType);
      expect(originalAccountTransaction.transactionCategory, finalAccountTransaction.transactionCategory);
      expect(originalAccountTransaction.amount, finalAccountTransaction.amount);
      expect(originalAccountTransaction.currency, finalAccountTransaction.currency);
      expect(originalAccountTransaction.transactionId, finalAccountTransaction.transactionId);
      expect(originalAccountTransaction.keyAccount, finalAccountTransaction.keyAccount);
      expect(originalAccountTransaction.key, finalAccountTransaction.key);
    });
  });
}
