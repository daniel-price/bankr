import 'package:bankr/config/providers_factory.dart';
import 'package:bankr/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProvidersFactory.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
	    providers: ProvidersFactory.providers,
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
