import 'package:flutter/material.dart';
import 'package:ungqueue/utility/my_style.dart';

class MyServiceUser extends StatefulWidget {
  @override
  _MyServiceUserState createState() => _MyServiceUserState();
}

class _MyServiceUserState extends State<MyServiceUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().dartColor,
        title: Text('Service for User'),
      ),
      drawer: Drawer(
        child: MyStyle().buildSignOut(context),
      ),
    );
  }

  
}
