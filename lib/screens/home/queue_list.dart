import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yu_ngantri_loket/service/auth.dart';
import 'package:yu_ngantri_loket/service/notification.dart';

class QueueList extends StatefulWidget {
  QueueList({Key key}) : super(key: key);

  @override
  _QueueListState createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  final AuthService _auth = AuthService();
  final NotificationService _notify = NotificationService();
  String serviceType;
  String queueUserId;
  String topTicketNumber;
  String date;
  String counterNumber;
  String serviceCode;
  String tellerName;
  bool isLoading = false;
  bool isDisable = false;

  _getUserData() async {
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

  _getQueueData() async {
    await Firestore.instance
        .collection('counter_data')
        .document(await _auth.getUser())
        .get()
        .then((value) {
      if (value != null) {
        setState(() {
          serviceType = value.data['service'];
          print(serviceType);
          Firestore.instance
              .collection('waiting_room_queue')
              .orderBy('date')
              .where('service', isEqualTo: serviceType)
              .limit(1)
              .getDocuments()
              .then((value) {
            value.documents.forEach((element) {
              if (element.exists) {
                print(element.data['id'].toString());
                setState(() {
                  topTicketNumber = element.data['ticket_number'];
                  print(topTicketNumber);
                  queueUserId = element.data['id'];
                  date = element.data['date'];
                });
              }
            });
          });
        });
      }
    });

    if (topTicketNumber != null) {
      isLoading = false;
    }

    if (topTicketNumber == null) {
      isLoading = false;
    }

    print(topTicketNumber);
  }

  _getMovedQueueData() async {
    await Firestore.instance
        .collection('served_queue')
        .where('teller_number', isEqualTo: 'teller ' + tellerName)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        setState(() {
          topTicketNumber = element.data['ticket_number'];
          queueUserId = element.data['id'];
        });
      });
    });

    if (topTicketNumber != null) {
      isLoading = false;
    }
  }

  @override
  void initState() {
    _getUserData();
    _getQueueData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Antrian Teratas',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 16.0,
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Nomor Antrian',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            topTicketNumber != null
                                ? topTicketNumber
                                : '---', // dummy
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 64.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[950],
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Text(
                            'ID',
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Text(
                            queueUserId != null
                                ? queueUserId
                                : 'Tidak ada antrian', // dummy
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 18.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(
              height: 32.0,
            ),
            ButtonTheme(
              height: 50.0,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: isDisable
                    ? null
                    : () async {
                        await _notify.sendNotification(
                            queueUserId,
                            'Panggilan dari loket $tellerName',
                            'Harap menuju ke loket');

                        Firestore.instance
                            .collection('served_queue')
                            .document(queueUserId)
                            .setData({
                          'id': queueUserId,
                          'date': date,
                          'service': serviceType,
                          'ticket_number': topTicketNumber,
                          'teller_number': 'teller ' + tellerName,
                        });

                        Firestore.instance
                            .collection('waiting_room_queue')
                            .document(queueUserId)
                            .delete();

                        _getMovedQueueData();

                        setState(() {
                          isDisable = true;
                        });
                      },
                color: Color(0xFF536DFE),
                child: Text(
                  'Panggil',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            ButtonTheme(
              height: 50.0,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  await _notify.sendNotification(
                      queueUserId,
                      'Panggilan dari loket $tellerName',
                      'Kepada pengunjung dengan nomor tiket $topTicketNumber, segera menuju ke loket $tellerName');
                },
                color: Colors.amber[600],
                child: Text(
                  'Panggil Ulang',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            ButtonTheme(
              height: 50.0,
              minWidth: double.infinity,
              child: RaisedButton(
                onPressed: () async {
                  Firestore.instance
                      .collection('served_queue')
                      .document(queueUserId)
                      .delete();

                  Fluttertoast.showToast(
                      msg: 'Layanan untuk $topTicketNumber selesai');

                  setState(() {
                    isLoading = true;
                    isDisable = false;
                    topTicketNumber = null;
                    queueUserId = null;
                  });
                  _getUserData();
                  _getQueueData();
                },
                color: Colors.white,
                child: Text(
                  'Selesai',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
