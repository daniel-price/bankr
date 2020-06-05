import 'package:bankr/api/true_layer_api_adapter.dart';
import 'package:bankr/data/json/i_json_converter.dart';
import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_balance.dart';
import 'package:bankr/data/model/account_transaction.dart';

class AccountJsonConverter extends IJsonConverter<Account> {
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
      map['uuidAccessToken'] as String,
      map['uuidProvider'] as String,
      map['uuid'] as String,
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
      'uuidAccessToken': account.uuidAccessToken,
      'uuidProvider': account.uuidProvider,
      'uuid': account.uuid,
    };
  }
}

class AccountBalanceJsonConverter extends IJsonConverter<AccountBalance> {
  AccountBalance fromMap(Map<String, dynamic> map) {
    return AccountBalance(
      map['currency'] as String,
      map['available'] as double,
      map['current'] as double,
      map['overdraft'] as double,
      map['updateTimestamp'] as String,
      map['uuidAccount'] as String,
      map['uuid'] as String,
    );
  }

  Map<String, dynamic> toMap(AccountBalance accountBalance) {
    return <String, dynamic>{
      'currency': accountBalance.currency,
      'available': accountBalance.available,
      'current': accountBalance.current,
      'overdraft': accountBalance.overdraft,
      'updateTimestamp': accountBalance.updateTimestamp,
      'uuidAccount': accountBalance.uuidAccount,
      'uuid': accountBalance.uuid,
    };
  }
}

class AccountTransactionJsonConverter extends IJsonConverter<AccountTransaction> {
  AccountTransaction fromMap(Map<String, dynamic> map) {
    return AccountTransaction(
      map['timestamp'] as String,
      map['description'] as String,
      map['transactionType'] as String,
      map['transactionCategory'] as String,
      map['amount'] as double,
      map['currency'] as String,
      map['transactionId'] as String,
      map['merchantName'] as String,
      map['uuidAccount'] as String,
      map['uuid'] as String,
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
      'merchantName': transaction.merchantName,
      'uuidAccount': transaction.uuidAccount,
      'uuid': transaction.uuid,
    };
  }
}

class AccountProviderJsonConverter extends IJsonConverter<AccountProvider>
{
  AccountProvider fromMap (Map<String, dynamic> map)
  {
    return AccountProvider(
      map['displayName'] as String,
      map['logoUri'] as String,
      map['providerId'] as String,
      map['dataAccessSavingsDays'] as int,
      map['dataCardsDays'] as int,
      map['canRequestAllDataAtAnyTime'] as bool,
      map['logoSvg'] as String,
      map['uuid'] as String,
    );
  }

  Map<String, dynamic> toMap (AccountProvider provider)
  {
    return <String, dynamic>{
      'displayName': provider.displayName,
      'logoUri': provider.logoUri,
      'providerId': provider.providerId,
      'dataAccessSavingsDays': provider.dataAccessSavingsDays,
      'dataCardsDays': provider.dataCardsDays,
      'canRequestAllDataAtAnyTime': provider.canRequestAllDataAtAnyTime,
      'logoSvg': provider.logoSvg,
      'uuid': provider.uuid,
    };
  }
}
