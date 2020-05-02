import 'package:bankr/screen/access_tokens_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bankr',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: SAccessTokens(),
    );
  }
}
