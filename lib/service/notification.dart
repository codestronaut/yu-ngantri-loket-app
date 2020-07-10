import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  Future sendNotification(String receiver, String title, String body) async {
    var token = await getToken(receiver);
    print('token: $token'); // LOG

    final postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {"body": "$body", "title": "$title"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAA26efWHM:APA91bF4HoWOcYgfE1u9bx0WpR4jNCkyBXj6bk8Fn2qpXNluYSc10d5jgpGzmTdmIy9csZIr9IMA4W2GpWJdcqppv-9jVD_Wd7y5ypz3tjwLEAc6w4smokRR15YvwF_YV8ZaKYFms1hB'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(postUrl, data: data);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Notifikasi terkirim');
      } else {
        print('notification sending failed');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future getToken(String uid) async {
    final Firestore _db = Firestore.instance;

    var token;
    await _db.collection('users').document(uid).get().then((value) {
      token = value.data['device_token'];
    });

    return token;
  }
}
