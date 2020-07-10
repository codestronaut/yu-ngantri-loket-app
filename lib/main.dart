import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_ngantri_loket/models/user.dart';
import 'package:yu_ngantri_loket/screens/wrapper.dart';
import 'package:yu_ngantri_loket/service/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yu-Ngantri Loket',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF536DFE),
          accentColor: Color(0xFFFFFFFF),
        ),
        home: Wrapper(),
      ),
    );
  }
}
