import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_ngantri_loket/models/user.dart';
import 'package:yu_ngantri_loket/screens/authenticate/authenticate.dart';
import 'home/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
