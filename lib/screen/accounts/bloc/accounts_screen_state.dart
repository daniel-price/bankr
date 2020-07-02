import 'package:bankr/screen/accounts/provider_info.dart';
import 'package:equatable/equatable.dart';

abstract class AccountsScreenState extends Equatable {
  const AccountsScreenState();

  @override
  List<Object> get props => [];
}

class StateInitial extends AccountsScreenState {}

class StateSuccess extends AccountsScreenState {
  final List<ProviderInfo> _providerInfos;

  StateSuccess(this._providerInfos);

  List<ProviderInfo> get providerInfos => _providerInfos;

  @override
  List<Object> get props => _providerInfos;
}
