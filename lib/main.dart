import 'package:flutter/material.dart';
import 'package:ungqueue/screens/authen.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Authen(),
    );
  }
}
