import 'package:bankr/screen/accounts/download_info.dart';
import 'package:equatable/equatable.dart';

abstract class DownloadEvent extends Equatable {
	const DownloadEvent();

	@override
	List<Object> get props => [];
}


class DownloadStarted extends DownloadEvent {
	const DownloadStarted();
}

class DownloadCardDismissed extends DownloadEvent {
	final DownloadInfo _downloadInfo;

	const DownloadCardDismissed(this._downloadInfo);

	DownloadInfo get downloadInfo => _downloadInfo;


	@override
	List<Object> get props => [downloadInfo];
}
