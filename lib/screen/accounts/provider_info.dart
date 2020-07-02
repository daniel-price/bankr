import 'package:bankr/data/model/account.dart';
import 'package:bankr/data/model/account_provider.dart';
import 'package:bankr/data/model/account_provider_update_audit.dart';
import 'package:bankr/screen/accounts/account_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProviderInfo {
  final AccountProvider _accountProvider;
  final AccountProviderUpdateAudit _accountProviderUpdateAudit;
  final List<AccountInfo> _accountRows;
  final bool _refreshing;

  ProviderInfo(this._accountProvider, this._accountProviderUpdateAudit, this._accountRows, this._refreshing);

  String get lastUpdatedDesc {
    var lastUpdatedDescPrefix = _getLastUpdatedDescPrefix();
    var lastUpdatedDescSuffix = _getLastUpdatedDescSuffix();

    return '$lastUpdatedDescPrefix $lastUpdatedDescSuffix';
  }

  String get providerDesc => _accountProvider.displayName;

  String get totalBalanceDesc {
    double totalBalance = getTotalBalance();

    return getBalanceDesc(totalBalance);
  }

  double getTotalBalance() {
    var totalBalance = 0.0;
    for (AccountInfo accountRow in _accountRows) {
      var accountBalance = accountRow.accountBalance;
      var current = accountBalance.current;
      totalBalance += current;
    }
    return totalBalance;
  }

  get accountProvider => _accountProvider;

  get accountProviderUpdateAudit => _accountProviderUpdateAudit;

  String get providerId => _accountProvider.providerId;

  List<Account> get accounts {
    List<Account> accounts = List();
    for (AccountInfo accountRow in accountRows) {
      var account = accountRow.account;
      accounts.add(account);
    }
    return accounts;
  }

  get uuidProvider => _accountProvider.uuid;

  get accountProviderImage {
    if (_refreshing) {
      return SpinKitFadingCircle(
        color: Colors.blueGrey,
        size: 40,
      );
    }
    return getImage(_accountProvider, 40);
  }

  String _getLastUpdatedDescPrefix() {
    if (_accountProviderUpdateAudit.success) {
      return 'Last updated';
    }
    return 'Failed to update';
  }

  List<AccountInfo> get accountRows => _accountRows;

  _getLastUpdatedDescSuffix() {
    var now = DateTime.now();
    var updatedTime = _accountProviderUpdateAudit.updatedTime;
    var difference = now.difference(updatedTime);
    var differenceInDays = difference.inDays;
    if (differenceInDays > 0) {
      if (differenceInDays == 1) {
        return '1 day ago';
      }
      return '$differenceInDays days ago';
    }

    var differenceInHours = difference.inHours;
    if (differenceInHours > 0) {
      if (differenceInHours == 1) {
        return '1 hour ago';
      }
      return '$differenceInHours hours ago';
    }

    var differenceInMinutes = difference.inMinutes;
    if (differenceInMinutes > 0) {
      if (differenceInMinutes == 1) {
        return 'a minute ago';
      }
      return '$differenceInMinutes minutes ago';
    }

    return 'less than a minute ago';
  }
}

String getBalanceDesc(double totalBalance) => '£' + totalBalance.toStringAsFixed(2);

Widget getImage(AccountProvider accountProvider, double height) {
  if (accountProvider.logoSvg != null) {
    return SvgPicture.asset(
      accountProvider.logoSvg,
      height: height,
    );
  }

  return SvgPicture.network(
    accountProvider.logoUri,
    placeholderBuilder: (BuildContext context) => const CircularProgressIndicator(),
    height: height,
  );
}
