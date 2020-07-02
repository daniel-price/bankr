import 'package:bankr/screen/accounts/download_info.dart';
import 'package:equatable/equatable.dart';

abstract class DownloadState extends Equatable {
	const DownloadState();

	@override
	List<Object> get props => [];
}

class StateInitial extends DownloadState {}

class StateSuccess extends DownloadState {
	final List<DownloadInfo> _downloadInfos;

	StateSuccess(this._downloadInfos);

	List<DownloadInfo> get downloadInfos => _downloadInfos;

	@override
	List<Object> get props => _downloadInfos;
}
