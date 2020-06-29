import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:equatable/equatable.dart';

abstract class AccountsPanelState extends Equatable {
  const AccountsPanelState();

  @override
  List<Object> get props => [];
}

class StateInitial extends AccountsPanelState {}

class StateAccountsAndDownloadsLoaded extends AccountsPanelState {
  final List<ProviderInfo> _providerInfos;
  final List<DownloadInfo> _downloadInfos;

  List<ProviderInfo> get providerInfos => _providerInfos;

  List<DownloadInfo> get downloadInfos => _downloadInfos;

  StateAccountsAndDownloadsLoaded(this._providerInfos, this._downloadInfos);

  @override
  List<Object> get props {
    List retval = List();

    retval.addAll(providerInfos);
    retval.addAll(downloadInfos);
    return retval;
  }
}

class DownloadInfo {
  final String _uuid;
  final String _message;

  String get uuid => _uuid;

  DownloadInfo(this._uuid, this._message);

  String get message => _message;
}
