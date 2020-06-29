import 'package:equatable/equatable.dart';

abstract class AccountsScreenEvent extends Equatable {
  const AccountsScreenEvent();

  @override
  List<Object> get props => [];
}

class EventRebuildAccounts extends AccountsScreenEvent {}

class EventRefreshAccounts extends AccountsScreenEvent {
  final String _uuidProvider;

  EventRefreshAccounts(this._uuidProvider);

  String get uuidProvider => _uuidProvider;

  @override
  List<Object> get props => [_uuidProvider];
}

class EventDownloadStarted extends AccountsScreenEvent {
  const EventDownloadStarted();
}

class EventDownloadSuccess extends AccountsScreenEvent {
  const EventDownloadSuccess();
}

class EventDownloadFailed extends AccountsScreenEvent {
  const EventDownloadFailed();
}

class EventClearDownloadCard extends AccountsScreenEvent {
  final String _uuid;

  const EventClearDownloadCard(this._uuid);

  String get uuid => _uuid;
}
