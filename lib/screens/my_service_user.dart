import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/models/user_model.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/widget/list_resturant.dart';

class MyServiceUser extends StatefulWidget {
  @override
  _MyServiceUserState createState() => _MyServiceUserState();
}

class _MyServiceUserState extends State<MyServiceUser> {
  String nameLogin;
  Widget currentWidget = ListRestaurnat();
  List<RestaurantModel> restaurantModels = List();
  List<Widget> widgets = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          UserModel model = UserModel.fromMap(event.data());
          setState(() {
            nameLogin = model.name;
          });
        });

        
      });
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyStyle().dartColor,
        title: Text('Service for User'),
      ),
      drawer: Drawer(
        child: Stack(
          children: [
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListRestaurant(context),
              ],
            ),
            MyStyle().buildSignOut(context),
          ],
        ),
      ),
      body: currentWidget,
    );
  }

  ListTile buildListRestaurant(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home_outlined),
      title: Text('แสดง ร้านค้า'),
      onTap: () {
        setState(() {
          currentWidget = ListRestaurnat();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.white, MyStyle().dartColor]),
        ),
        currentAccountPicture: Image.asset('images/logo.png'),
        accountName:
            MyStyle().buildTitleH1(nameLogin == null ? 'Name' : nameLogin),
        accountEmail: MyStyle().buildTitleH2('User Type'));
  }
}
