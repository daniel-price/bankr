import 'package:equatable/equatable.dart';

abstract class AccountsScreenEvent extends Equatable {
  const AccountsScreenEvent();

  @override
  List<Object> get props => [];
}

class AccountsLoaded extends AccountsScreenEvent {}

class AccountsRefreshed extends AccountsScreenEvent {
  final String _uuidProvider;

  AccountsRefreshed(this._uuidProvider);

  String get uuidProvider => _uuidProvider;

  @override
  List<Object> get props => [_uuidProvider];
}

class AllAccountsRefreshed extends AccountsScreenEvent {
}