import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ungqueue/models/queue_model.dart';
import 'package:ungqueue/models/restaurant_model.dart';
import 'package:ungqueue/utility/my_style.dart';
import 'package:ungqueue/utility/normal_dialog.dart';

class DetailDesk extends StatefulWidget {
  final RestaurantModel model;
  final int deskPosition;
  final String uidRest;
  DetailDesk({Key key, this.model, this.deskPosition, this.uidRest})
      : super(key: key);
  @override
  _DetailDeskState createState() => _DetailDeskState();
}

class _DetailDeskState extends State<DetailDesk> {
  RestaurantModel model;
  int deskPosition;
  String uidRest, datereceive, timereceive;
  DateTime dateTime;
  bool statusLoad = true;
  bool statusHaveData = true;
  List<QueueModel> queueModels = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    model = widget.model;
    deskPosition = widget.deskPosition;
    uidRest = widget.uidRest;

    readDetailDesk();
  }

  Future<Null> readDetailDesk() async {
    statusHaveData = true;

    if (queueModels.length != 0) {
      queueModels.clear();
    }

    await Firebase.initializeApp().then((value) async {
      await FirebaseFirestore.instance
          .collection('restaurant')
          .doc(uidRest)
          .collection('deskposition$deskPosition')
          .snapshots()
          .listen((event) {
        setState(() {
          statusLoad = false;
        });

        if (event.docs.length == 0) {
          setState(() {
            statusHaveData = false;
          });
        } else {
          for (var item in event.docs) {
            QueueModel model = QueueModel.fromMap(item.data());
            setState(() {
              queueModels.add(model);
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildOutlineButton(),
      appBar: AppBar(
        backgroundColor: MyStyle().dartColor,
        title: Text('${model.name} โต้ะ $deskPosition'),
      ),
      body: statusLoad
          ? MyStyle().showProgress()
          : statusHaveData
              ? ListView.builder(
                  itemCount: queueModels.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(queueModels[index].datereceive),
                      Text(queueModels[index].timereceive),
                    ],
                  ),
                )
              : Center(child: Text('โต้ะนี่ ยังว่าง คะ')),
    );
  }

  OutlineButton buildOutlineButton() {
    return OutlineButton(
      onPressed: () {
        dateTime = DateTime.now();
        print('dateTime = $dateTime');
        chooseDate();
        // buildShowDialog();
      },
      child: MyStyle().buildTitleH1('จองโต้ะ $deskPosition'),
    );
  }

  Future<Null> chooseDate() async {
    await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: dateTime,
            lastDate: DateTime(dateTime.year + 1))
        .then((value) async {
      datereceive = DateFormat('dd-MM-yyyy').format(value);
      print('datereceive = $datereceive');

      TimeOfDay timeOfDay = TimeOfDay.now();
      await showTimePicker(context: context, initialTime: timeOfDay)
          .then((value) {
        timereceive = value.format(context);
        print('timereceive = $timereceive');
        buildShowDialog();
      });
    });
  }

  Future<Null> buildShowDialog() async {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: ListTile(
          leading: Image.asset('images/logo.png'),
          title: Text('คุณต้องการจอง โต้ะ $deskPosition จริงๆ นะคะ'),
        ),
        children: [
          Text('วัน-เดือน-ปี = $datereceive'),
          Text('เวลา = $timereceive'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  addReceive();
                  Navigator.pop(context);
                },
                child: Text('Confirm'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Concel'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> addReceive() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen(
        (event) async {
          String uiduser = event.uid;
          print('uiduser = $uiduser');

          QueueModel model = QueueModel(
              uiduser: uiduser,
              datereceive: datereceive,
              timereceive: timereceive);

          Map<String, dynamic> data = model.toMap();
          await FirebaseFirestore.instance
              .collection('restaurant')
              .doc(uidRest)
              .collection('deskposition$deskPosition')
              .doc()
              .set(data)
              .then((value) {
            readDetailDesk();
            normalDialog(context, 'คุณจอง Queue สำเร็จแล้ว');
          });
        },
      );
    });
  }
}
