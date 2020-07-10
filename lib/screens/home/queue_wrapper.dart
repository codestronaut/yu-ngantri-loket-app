import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yu_ngantri_loket/screens/home/queue_list.dart';
import 'package:yu_ngantri_loket/service/auth.dart';

class QueueWrapper extends StatefulWidget {
  QueueWrapper({Key key}) : super(key: key);

  @override
  _QueueWrapperState createState() => _QueueWrapperState();
}

class _QueueWrapperState extends State<QueueWrapper> {
  final AuthService _auth = AuthService();
  String counterNumber = '';
  String serviceCode = '';  
  String tellerName = '';

  getUserData() async {
    await Firestore.instance
        .collection('counter_data')
        .document(await _auth.getUser())
        .get()
        .then((value) {
      setState(() {
        counterNumber = value.data['teller'];
        serviceCode = value.data['service'].toString().split('.')[0];
        tellerName = "$counterNumber$serviceCode";
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: PreferredSize(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Selamat Datang',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 18.0,
                  color: Color(0xFF536DFE),
                ),
              ),
              Text(
                'Teller $counterNumber$serviceCode',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                  color: Colors.amber[600],
                ),
              ),
            ],
          ),
        ),
        preferredSize: Size.fromHeight(kToolbarHeight),
      ),
      body: SafeArea(
        child: QueueList(),
      ),
    );
  }
}
