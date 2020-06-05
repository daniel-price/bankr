import 'dart:collection';

class AccountProviderReferenceDataCache {
  static final HashMap<String, AccountProviderReferenceData> _accountProvidersById = factoryHashmap();

  AccountProviderReferenceDataCache();

  static HashMap<String, AccountProviderReferenceData> factoryHashmap() {
    HashMap<String, AccountProviderReferenceData> accountProvidersById = HashMap();
    accountProvidersById['ob-monzo'] = AccountProviderReferenceData(1 * 365, 1 * 365, false, 'assets/providers/monzo.svg');
    accountProvidersById['ob-santander'] = AccountProviderReferenceData(2 * 365, 2 * 365, true, 'assets/providers/santander.svg');
    return accountProvidersById;
  }

  static AccountProviderReferenceData getAccountProvider(String providerId) {
    return _accountProvidersById[providerId];
  }
}

class AccountProviderReferenceData {
  final int _dataAccessSavingsDays;
  final int _dataCardsDays;
  final bool _canRequestAllDataAtAnyTime;
  final String _logoSvg;

  AccountProviderReferenceData(this._dataAccessSavingsDays, this._dataCardsDays, this._canRequestAllDataAtAnyTime, this._logoSvg);

  int get dataAccessSavingsDays => _dataAccessSavingsDays;

  int get dataCardsDays => _dataCardsDays;

  bool get canRequestAllDataAtAnyTime => _canRequestAllDataAtAnyTime;

  String get logoSvg => _logoSvg;
}
