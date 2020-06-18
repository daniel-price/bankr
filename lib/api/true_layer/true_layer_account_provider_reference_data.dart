import 'dart:collection';

import 'package:bankr/util/constants.dart';

/**
 * Hard-coded provider information which can not be retrieved through the API, which is persisted on the AccountProvider on retrieval:
 * -Transaction history limit, from https://truelayer.zendesk.com/hc/en-us/articles/360003168153-How-far-back-can-I-pull-transactions-
 * -Provider icons in a format appropriate for flutter_svg (the svg retrieved from the API uses the <style> element which is not supported: https://github.com/dnfield/flutter_svg/issues/105,
 * e.g. API response https://truelayer-client-logos.s3-eu-west-1.amazonaws.com/banks/banks-icons/ob-nationwide-icon.svg can be converted using https://jakearchibald.github.io/svgomg/
 */
class TrueLayerAccountProviderReferenceData {
  final int _dataAccessSavingsDays;
  final int _dataCardsDays;
  final bool _canRequestAllDataAtAnyTime;
  final String _logoSvg;

  TrueLayerAccountProviderReferenceData(this._dataAccessSavingsDays, this._dataCardsDays, this._canRequestAllDataAtAnyTime, this._logoSvg);

  int get dataAccessSavingsDays => _dataAccessSavingsDays;

  int get dataCardsDays => _dataCardsDays;

  bool get canRequestAllDataAtAnyTime => _canRequestAllDataAtAnyTime;

  String get logoSvg => _logoSvg;
}

HashMap<String, TrueLayerAccountProviderReferenceData> factoryAccountProviderReferenceDataById ()
{
  HashMap<String, TrueLayerAccountProviderReferenceData> accountProvidersById = HashMap();
  accountProvidersById['ob-bos'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_MONTH, false, 'assets/providers/bos.svg');
  accountProvidersById['ob-barclays'] = TrueLayerAccountProviderReferenceData(2 * DAYS_IN_YEAR, 2 * DAYS_IN_YEAR, true, 'assets/providers/barclays.svg');
  accountProvidersById['ob-danske'] = TrueLayerAccountProviderReferenceData(25 * DAYS_IN_MONTH, 25 * DAYS_IN_MONTH, false, 'assets/providers/danske.svg');
  accountProvidersById['ob-first-direct'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, null, false, 'assets/providers/first-direct.svg');
  accountProvidersById['ob-halifax'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_MONTH, false, 'assets/providers/halifax.svg');
  accountProvidersById['ob-hsbc'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, null, false, 'assets/providers/hsbc.svg');
  accountProvidersById['ob-hsbc-business'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, null, true, 'assets/providers/hsbc-business.svg');
  accountProvidersById['ob-lloyds'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_MONTH, false, 'assets/providers/lloyds.svg');
  accountProvidersById['ob-mbna'] = TrueLayerAccountProviderReferenceData(null, 6 * DAYS_IN_MONTH, false, 'assets/providers/mbna.svg');
  accountProvidersById['ob-monzo'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_YEAR, false, 'assets/providers/monzo.svg');
  accountProvidersById['ob-ms'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, null, false, 'assets/providers/ms.svg');
  accountProvidersById['ob-nationwide'] = TrueLayerAccountProviderReferenceData(15 * DAYS_IN_MONTH, 90, false, 'assets/providers/nationwide.svg');
  accountProvidersById['ob-natwest'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_YEAR, true, 'assets/providers/natwest.svg');
  accountProvidersById['ob-revolut'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_YEAR, false, 'assets/providers/revolut.svg');
  accountProvidersById['ob-rbs'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 6 * DAYS_IN_YEAR, true, 'assets/providers/rbs.svg');
  accountProvidersById['ob-santander'] = TrueLayerAccountProviderReferenceData(2 * DAYS_IN_YEAR, 2 * DAYS_IN_YEAR, true, 'assets/providers/santander.svg');
  accountProvidersById['ob-ulster'] = TrueLayerAccountProviderReferenceData(6 * DAYS_IN_YEAR, 2 * DAYS_IN_YEAR, true, 'assets/providers/ulster.svg');
  accountProvidersById['ob-tsb'] = TrueLayerAccountProviderReferenceData(5 * DAYS_IN_YEAR, 2 * DAYS_IN_YEAR, false, 'assets/providers/tsb.svg');
  return accountProvidersById;
}
