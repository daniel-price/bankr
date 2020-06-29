import 'dart:collection';

import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/repository/account_repository.dart';
import 'package:bankr/screen/accounts/bloc/accounts_panel_event.dart';
import 'package:bankr/screen/accounts/bloc/accounts_panel_state.dart';
import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';

class AccountsPanelBloc extends Bloc<AccountsScreenEvent, AccountsPanelState> {
  final ProviderInfoRepository _accountRepository;
  final DataDownloader _dataDownloader;

  HashMap<String, ProviderInfo> _providerInfos = HashMap();
  HashMap<String, DownloadInfo> _downloadInfos = HashMap();

  AccountsPanelBloc(this._accountRepository, this._dataDownloader) : assert(_accountRepository != null, _dataDownloader != null);

  @override
  AccountsPanelState get initialState => StateInitial();

  @override
  Stream<AccountsPanelState> mapEventToState(AccountsScreenEvent event) async* {
    if (event is EventRebuildAccounts) {
      yield StateInitial();
      var providerInfos = await _accountRepository.getProviderInfos();
      _providerInfos = HashMap();
      for (ProviderInfo providerInfo in providerInfos) {
        _providerInfos[providerInfo.uuidProvider] = providerInfo;
      }
      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
    }

    if (event is EventRefreshAccounts) {
      var uuidProvider = event.uuidProvider;
      var providerInfo = _providerInfos[uuidProvider];
      _providerInfos[uuidProvider] = new ProviderInfo(providerInfo.accountProvider, providerInfo.accountProviderUpdateAudit, providerInfo.accountRows, true);
      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
      await _dataDownloader.update(providerInfo.accountProvider, providerInfo.accounts);
      var newProviderInfo = await _accountRepository.getProviderInfo(uuidProvider);
      _providerInfos[uuidProvider] = newProviderInfo;
      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
    }

    if (event is EventDownloadStarted) {
      var v4 = Uuid().v4();
      _downloadInfos[v4] = DownloadInfo(v4, 'Downloading...');
      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
      final String uuidAccessToken = await _dataDownloader.downloadAllData();

      if (uuidAccessToken == null) {
        _downloadInfos[v4] = DownloadInfo(v4, 'Something went wrong - please try again.');
      } else {
        _downloadInfos.remove(v4);
        var providerInfo = await _accountRepository.getProviderInfoForUuidAccessToken(uuidAccessToken);
        _providerInfos[providerInfo.uuidProvider] = providerInfo;
      }

      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
    }

    if (event is EventClearDownloadCard) {
      var uuid = event.uuid;
      _downloadInfos.remove(uuid);
      yield StateAccountsAndDownloadsLoaded(_providerInfos.values.toList(), _downloadInfos.values.toList());
    }
  }
}
