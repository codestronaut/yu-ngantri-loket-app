import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference for loket service
  final CollectionReference counterCollection =
      Firestore.instance.collection('counter_data');

  // update user data
  Future updateUserData(String service, String counterNumber) async {
    return await counterCollection.document(uid).setData({
      'id': uid,
      'teller': counterNumber,
      'service': service,
    });
  }
}
