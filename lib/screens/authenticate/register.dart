import 'package:flutter/material.dart';
import 'package:yu_ngantri_loket/service/auth.dart';
import 'package:yu_ngantri_loket/service/database.dart';
import 'package:yu_ngantri_loket/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({Key key, this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  final List<String> services = [
    'A. Tanpa Kuasa',
    'B. Penerimaan Berkas',
    'C. Penyerahan Produk',
    'D. Informasi'
  ];

  // text field state
  String email = '';
  String password = '';
  String counter_number = '';
  String service_type = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      children: <Widget>[
                        Image(
                          height: 100.0,
                          width: 200.0,
                          image: AssetImage(
                            'images/applogo_secondary.png',
                          ),
                        ),
                        SizedBox(
                          height: 64.0,
                        ),
                        Form(
                          key: _formKey,
                          child: registerForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget registerForm() {
    return new Column(
      children: <Widget>[
        Container(
          height: 50.0,
          child: TextFormField(
            obscureText: false,
            cursorColor: Color(0xFF536DFE),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Alamat Email',
            ),
            validator: (val) => val.isEmpty ? 'Masukkan email' : null,
            onChanged: (val) {
              setState(() {
                email = val;
              });
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 50.0,
          child: TextFormField(
            obscureText: true,
            cursorColor: Color(0xFF536DFE),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Kata Sandi',
            ),
            validator: (val) =>
                val.length < 6 ? 'Masukkan password minimal 6 karakter' : null,
            onChanged: (val) {
              setState(() {
                password = val;
              });
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        Container(
          height: 50.0,
          child: TextFormField(
            cursorColor: Color(0xFF536DFE),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nomor Teller',
            ),
            validator: (val) => val.isEmpty ? 'Masukkan nomor teller' : null,
            onChanged: (val) {
              setState(() {
                counter_number = val;
              });
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        DropdownButtonFormField(
          hint: Text('Layanan'),
          items: services.map((service) {
            return DropdownMenuItem(
              value: service,
              child: Text(service),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              service_type = val;
            });
          },
        ),
        SizedBox(
          height: 24.0,
        ),
        ButtonTheme(
          height: 50.0,
          minWidth: double.infinity,
          child: RaisedButton(
            color: Color(0xFF536DFE),
            child: Text(
              'Daftar',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  loading = true;
                });

                dynamic result =
                    await _auth.signUpWithEmailAndPassword(email, password);
                if (result == null) {
                  setState(() {
                    error = 'Mohon masukkan email yang valid';
                    loading = false;
                  });
                } else {
                  await DatabaseService(uid: await _auth.getUser())
                      .updateUserData(service_type, counter_number);
                }
              }
            },
          ),
        ),
        SizedBox(
          height: 16.0,
        ),
        FlatButton(
          child: Text(
            'Masuk',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            widget.toggleView();
          },
        ),
        SizedBox(
          height: 16.0,
        ),
        Text(
          error,
          style: TextStyle(
            fontFamily: 'Rubik',
            fontSize: 14.0,
            color: Colors.red[400],
          ),
        ),
      ],
    );
  }
}
