import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ungqueue/models/user_model.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/utility/normal_dialog.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<String> types = ['Resturant', 'User'];
  String type, name, email, password;

  Widget buildTextFieldName() => Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyStyle().lightColor,
        ),
        width: 250,
        child: TextField(
          onChanged: (value) => name = value.trim(),
          decoration: InputDecoration(
            hintText: 'Name :',
            prefixIcon: Icon(Icons.fingerprint),
            border: InputBorder.none,
          ),
        ),
      );

  Widget buildTextFieldEmail() => Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyStyle().lightColor,
        ),
        width: 250,
        child: TextField(keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value.trim(),
          decoration: InputDecoration(
            hintText: 'Email :',
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
          decoration: InputDecoration(
            hintText: 'Password :',
            prefixIcon: Icon(Icons.lock),
            border: InputBorder.none,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyStyle().dartColor,
        onPressed: () {
          if (name == null ||
              name.isEmpty ||
              email == null ||
              email.isEmpty ||
              password == null ||
              password.isEmpty) {
            normalDialog(context, 'Have Space ? Please Fill Every Blank');
          } else if (type == null) {
            normalDialog(context, 'No Type ? Please Choose Type');
          } else {
            createAccount();
          }
        },
        child: Icon(
          Icons.cloud_upload,
          size: 48,
        ),
      ),
      appBar: AppBar(
        backgroundColor: MyStyle().dartColor,
        title: Text('Register'),
      ),
      body: Center(
        child: Column(
          children: [
            buildTextFieldName(),
            buildDropdownButton(),
            buildTextFieldEmail(),
            buildTextFieldPassword(),
          ],
        ),
      ),
    );
  }

  Future<Null> createAccount() async {
    await Firebase.initializeApp().then((value) async {
      print('InitializeApp Success');
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        String uid = value.user.uid;
        print('Uid = $uid');
        insertCloudFirestore(uid);
      }).catchError((value) {
        normalDialog(context, value.message);
      });
    });
  }

  Future<Null> insertCloudFirestore(String uid) async {
    UserModel model = UserModel(email: email, name: name, type: type);
    Map<String, dynamic> data = model.toMap();

    await FirebaseFirestore.instance
        .collection('user')
        .doc(uid)
        .set(data)
        .then((value) => Navigator.pop(context));
  }

  Widget buildDropdownButton() => Container(
        margin: EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: MyStyle().lightColor,
        ),
        child: DropdownButton<String>(
          items: types
              .map(
                (e) => DropdownMenuItem(
                  child: Text(e),
                  value: e,
                ),
              )
              .toList(),
          value: type,
          hint: Text('Please Choose Type'),
          onChanged: (value) {
            setState(() {
              type = value;
            });
          },
        ),
      );
}
