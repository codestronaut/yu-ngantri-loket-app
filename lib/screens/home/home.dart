import 'package:flutter/material.dart';
import 'package:yu_ngantri_loket/screens/home/queue_wrapper.dart';
import 'package:yu_ngantri_loket/service/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Yu-',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                  ),
                ),
                Text(
                  'Ngantri',
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            ),
            SizedBox(
              width: 6.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                'Loket',
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0,
                  color: Color(0xFF536DFE),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.white),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            label: Text(
              'Keluar',
              style: TextStyle(
                fontFamily: 'Rubik',
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: QueueWrapper(),
    );
  }
}
