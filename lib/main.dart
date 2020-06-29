import 'package:bankr/blocs/simple_bloc_delegate.dart';
import 'package:bankr/config/providers_factory.dart';
import 'package:bankr/screen/home_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  var providers = await factoryProviders();
	runApp(MyApp(providers));
}

class MyApp extends StatelessWidget {
	final List<BlocProvider> providers;

	MyApp(this.providers);

	@override
	Widget build(BuildContext context) {
		return MultiBlocProvider(
			providers: providers,
			child: MaterialApp(
				title: 'Bankr',
				theme: ThemeData(
					primarySwatch: Colors.blueGrey,
				),
				home: HomeScreen(),
			),
		);
	}
}
