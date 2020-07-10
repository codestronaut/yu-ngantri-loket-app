import 'package:flutter/material.dart';
import 'package:yu_ngantri_loket/models/queue.dart';

class QueueTile extends StatelessWidget {
  final Queue queue;
  QueueTile({this.queue});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(16.0, 6.0, 16.0, 0.0),
        child: ListTile(
          leading: Text(
            queue.ticket,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          title: Text(
            queue.service,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 18.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
