import 'package:bankr/providers_factory.dart';
import 'package:bankr/screen/access_tokens_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main ()
async {
	WidgetsFlutterBinding.ensureInitialized(); //need this to
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
		    home: SAccessTokens(),
	    ),
    );
  }
}
