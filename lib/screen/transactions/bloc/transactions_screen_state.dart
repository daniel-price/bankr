import 'package:bankr/data/repository/transaction_repository.dart';
import 'package:equatable/equatable.dart';

abstract class TransactionsScreenState extends Equatable {
  const TransactionsScreenState();

  @override
  List<Object> get props => [];
}

class StateInitial extends TransactionsScreenState {}

class StateSuccess extends TransactionsScreenState {
  final List<DateTransactionsInfo> _dateTransactionsInfos;

  List<DateTransactionsInfo> get dateTransactionsInfos => _dateTransactionsInfos;

  StateSuccess(this._dateTransactionsInfos);

  @override
  List<Object> get props => [_dateTransactionsInfos];
}
