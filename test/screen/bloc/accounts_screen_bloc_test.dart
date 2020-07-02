import 'package:bankr/screen/accounts/bloc/accounts_screen_bloc.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_event.dart';
import 'package:bankr/screen/accounts/bloc/accounts_screen_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
	group('CounterBloc', () {
		AccountsScreenBloc accountsScreenBloc;

		setUp(() {
			accountsScreenBloc = AccountsScreenBloc(null, null);
		});

		test('initial state is 0', () {
			expect(accountsScreenBloc.initialState, StateInitial);
		});

		blocTest(
			'emits [1] when CounterEvent.increment is added',
			build: () async => accountsScreenBloc,
			act: (bloc) async => bloc.add(AccountsLoaded()),
			expect: [1],
		);
	});
}