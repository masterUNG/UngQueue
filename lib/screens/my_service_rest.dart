import 'package:flutter/material.dart';
import 'package:ungqueue/utility/my_style.dart';

class MyServiceRest extends StatefulWidget {
  @override
  _MyServiceRestState createState() => _MyServiceRestState();
}

class _MyServiceRestState extends State<MyServiceRest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service for Restaurant'),
      ),drawer: Drawer(child: MyStyle().buildSignOut(context),),
    );
  }
}
