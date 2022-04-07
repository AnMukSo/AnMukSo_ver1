import 'package:flutter/material.dart';
import 'package:an_muk_so/login/register_withEmail.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/shared/customAppBar.dart';

final AuthService _auth = AuthService();

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('회원가입',  Image(
            image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              //Text('내 약이 궁금할 땐'),
              Container(
                child: SizedBox(
                  child: Image.asset('assets/login/login_logo.png'),
                  width: 120,
                  height: 60,
                ),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                child: Image.asset('assets/login/with_email.png'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterWithEmailPage()),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }
}
