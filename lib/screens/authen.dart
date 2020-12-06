import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/user_model.dart';
import 'package:ungqueue/screens/my_service_rest.dart';
import 'package:ungqueue/screens/my_service_user.dart';
import 'package:ungqueue/screens/register.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/utility/normal_dialog.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  bool status = true;
  String email, password;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkStatus();
  }

  Future<Null> checkStatus() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        if (event != null) {
          String uid = event.uid;
          print('uid Login = $uid');
          await FirebaseFirestore.instance
              .collection('user')
              .doc(uid)
              .snapshots()
              .listen((event) {
            UserModel model = UserModel.fromMap(event.data());
            print('type Login = ${model.type}');
            switch (model.type) {
              case 'Resturant':
                routeToService(MyServiceRest());
                break;
              case 'User':
                routeToService(MyServiceUser());
                break;
              default:
            }
          });
        } else {
          setState(() {
            status = false;
          });
        }
      });
    });
  }

  void routeToService(Widget widget) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Register',
        backgroundColor: MyStyle().dartColor,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Register(),
            )),
        child: Icon(
          Icons.account_circle,
          size: 48,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.white, MyStyle().primaryColor],
            radius: 1.0,
          ),
        ),
        child: Center(
          child:
              status ? MyStyle().showProgress() : buildSingleChildScrollView(),
        ),
      ),
    );
  }

  SingleChildScrollView buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyStyle().buildLogo(),
          MyStyle().buildTitleH1('Ung Queue'),
          buildTextFieldUser(),
          buildTextFieldPassword(),
          buildLogin()
        ],
      ),
    );
  }

  Container buildLogin() {
    return Container(
        margin: EdgeInsets.only(top: 16),
        width: 250,
        child: RaisedButton(
          color: MyStyle().dartColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
            if (email == null ||
                email.isEmpty ||
                password == null ||
                password.isEmpty) {
              normalDialog(context, 'Have Stace ? Please Fill Every Blank');
            } else {
              checkAuthen();
            }
          },
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget buildTextFieldUser() => Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyStyle().lightColor,
        ),
        width: 250,
        child: TextField(keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value.trim(),
          decoration: InputDecoration(
            hintText: 'User :',
            prefixIcon: Icon(Icons.email),
            border: InputBorder.none,
          ),
        ),
      );

  Widget buildTextFieldPassword() => Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyStyle().lightColor,
        ),
        width: 250,
        child: TextField(
          onChanged: (value) => password = value.trim(),
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password :',
            prefixIcon: Icon(Icons.lock),
            border: InputBorder.none,
          ),
        ),
      );

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String uid = value.user.uid;
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          UserModel model = UserModel.fromMap(event.data());
          switch (model.type) {
            case 'Resturant':
              routeToService(MyServiceRest());
              break;
            case 'User':
            routeToService(MyServiceUser());
              break;
            default:
          }
        });
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }
}
