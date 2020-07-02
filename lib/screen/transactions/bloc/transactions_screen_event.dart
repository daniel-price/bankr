import 'package:equatable/equatable.dart';

abstract class TransactionsScreenEvent extends Equatable {
  const TransactionsScreenEvent();

  @override
  List<Object> get props => [];
}

class TransactionsScreenLoaded extends TransactionsScreenEvent {}
