
import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/data/repository/account_repository.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_event.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_state.dart';
import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:bloc/bloc.dart';

class AccountsScreenBloc extends Bloc<AccountsScreenEvent, AccountsScreenState> {
  final ProviderInfoRepository _providerInfoRepository;
  final DataDownloader _dataDownloader;

  AccountsScreenBloc(this._providerInfoRepository, this._dataDownloader) : assert(_providerInfoRepository != null, _dataDownloader != null);

  @override
  AccountsScreenState get initialState => StateInitial();

  @override
  Stream<AccountsScreenState> mapEventToState(AccountsScreenEvent event) async* {
    if (event is AccountsLoaded) {
      yield StateInitial();
      var providerInfos = await _providerInfoRepository.getProviderInfos();
      yield StateSuccess(providerInfos);
    }

    if (event is AccountsRefreshed) {
      var uuidProvider = event.uuidProvider;
      yield* refreshAccount(uuidProvider);
    }

    if (event is AllAccountsRefreshed) {
      var providerInfos = await _providerInfoRepository.getProviderInfos();
      for (ProviderInfo providerInfo in providerInfos) {
        yield* refreshAccount(providerInfo.uuidProvider);
      }
    }
  }

  Stream<AccountsScreenState> refreshAccount(String uuidProvider) async* {
    _providerInfoRepository.addRefreshingProvider(uuidProvider);
    var providerInfosDuringRefresh = await _providerInfoRepository.getProviderInfos();
    yield StateSuccess(providerInfosDuringRefresh);
    var providerInfo = await _providerInfoRepository.getProviderInfo(uuidProvider);
    await _dataDownloader.update(providerInfo.accountProvider, providerInfo.accounts);
    _providerInfoRepository.removeRefreshingProvider(uuidProvider);
    var providerInfosAfterRefresh = await _providerInfoRepository.getProviderInfos();
    yield StateSuccess(providerInfosAfterRefresh);
  }

  ProviderInfoRepository get providerInfoRepository => _providerInfoRepository;
}