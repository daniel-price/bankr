import 'package:bankr/config/providers_factory.dart';
import 'package:bankr/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var providers = await factoryProviders();
  runApp(MyApp(providers));
}

class MyApp extends StatelessWidget {
  final List<SingleChildWidget> providers;

  MyApp(this.providers);

  @override
	Widget build(BuildContext context) {
		return MultiProvider(
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
