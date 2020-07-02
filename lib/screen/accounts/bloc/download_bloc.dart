
import 'package:bankr/data/download/data_downloader.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_bloc.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_event.dart';
import 'package:bankr/screen/accounts/bloc/download_event.dart';
import 'package:bankr/screen/accounts/bloc/download_state.dart';
import 'package:bankr/screen/accounts/download_info.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_bloc.dart';
import 'package:bankr/screen/transactions/bloc/transactions_screen_event.dart';
import 'package:bloc/bloc.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
	final List<DownloadInfo> _downloadInfos = List();
	final DataDownloader _dataDownloader;
	final TransactionsScreenBloc _transactionsScreenBloc;
	final AccountsScreenBloc _accountsScreenBloc;

  DownloadBloc(this._dataDownloader, this._transactionsScreenBloc, this._accountsScreenBloc);

	@override
	DownloadState get initialState => StateInitial();

	@override
	Stream<DownloadState> mapEventToState(DownloadEvent event) async* {
		if (event is DownloadStarted) {
			var downloadInfo = DownloadInfo('Downloading...');
			_downloadInfos.add(downloadInfo);
			yield StateSuccess(List.from(_downloadInfos));
			final String uuidAccessToken = await _dataDownloader.downloadAllData();

			if (uuidAccessToken == null) {
				_downloadInfos.add(DownloadInfo('Something went wrong - please try again.'));
			} else {
				_transactionsScreenBloc.add(TransactionsScreenLoaded());
				_accountsScreenBloc.add(AccountsLoaded());
			}

			_downloadInfos.remove(downloadInfo);
			yield StateSuccess(List.from(_downloadInfos));
		}

		if (event is DownloadCardDismissed) {
			var downloadInfo = event.downloadInfo;
			_downloadInfos.remove(downloadInfo);
			yield StateSuccess(List.from(_downloadInfos));
		}
	}
}