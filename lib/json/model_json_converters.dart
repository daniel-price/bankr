import 'package:bankr/json/i_json_converter.dart';
import 'package:bankr/model/access_token_model.dart';
import 'package:bankr/model/account.dart';
import 'package:bankr/model/account_transaction.dart';

class AccessTokenModelJsonConverter extends IJsonConverter<AccessToken> {
  AccessToken fromMap(Map<String, dynamic> map) {
    return AccessToken(map['accessToken'] as String, DateTime.fromMillisecondsSinceEpoch(map['expiresAt'] as int), map['tokenType'] as String, map['refreshToken'] as String, map['scope'] as String,
        map['id'] as int);
  }

  Map<String, dynamic> toMap(AccessToken accessToken) {
    return <String, dynamic>{
      'id': accessToken.key,
      'accessToken': accessToken.accessToken,
      'expiresAt': accessToken.expiresAt.millisecondsSinceEpoch,
      'tokenType': accessToken.tokenType,
      'refreshToken': accessToken.refreshToken,
      'scope': accessToken.scope,
    };
  }
}

class AccountModelJsonConverter extends IJsonConverter<Account> {
  Account fromMap(Map<String, dynamic> map) {
    return Account(
      map['updateTimestamp'] as String,
      map['accountId'] as String,
      map['accountType'] as String,
      map['name'] as String,
      map['currency'] as String,
      map['iban'] as String,
      map['swiftBic'] as String,
      map['number'] as String,
      map['sortCode'] as String,
      map['providerName'] as String,
      map['providerId'] as String,
      map['logoUri'] as String,
      map['idAccessToken'] as int,
      map['id'] as int,
    );
  }

  Map<String, dynamic> toMap(Account account) {
    return <String, dynamic>{
      'updateTimestamp': account.updateTimestamp,
      'accountId': account.accountId,
      'accountType': account.accountType,
      'name': account.name,
      'currency': account.currency,
      'iban': account.iban,
      'swiftBic': account.swiftBic,
      'number': account.number,
      'sortCode': account.sortCode,
      'providerName': account.providerName,
      'providerId': account.providerId,
      'logoUri': account.logoUri,
      'idAccessToken': account.keyAccessToken,
      'id': account.key,
    };
  }
}

class AccountTransactionModelJsonConverter extends IJsonConverter<AccountTransaction> {
  AccountTransaction fromMap(Map<String, dynamic> map) {
    return AccountTransaction(
      map['timestamp'] as String,
      map['description'] as String,
      map['transactionType'] as String,
      map['transactionCategory'] as String,
      map['amount'] as double,
      map['currency'] as String,
      map['transactionId'] as String,
      map['idAccount'] as int,
      map['id'] as int,
    );
  }

  Map<String, dynamic> toMap(AccountTransaction transaction) {
    return <String, dynamic>{
      'timestamp': transaction.timestamp,
      'description': transaction.description,
      'transactionType': transaction.transactionType,
      'transactionCategory': transaction.transactionCategory,
      'amount': transaction.amount,
      'currency': transaction.currency,
      'transactionId': transaction.transactionId,
      'idAccount': transaction.idAccount,
      'id': transaction.key,
    };
  }
}
