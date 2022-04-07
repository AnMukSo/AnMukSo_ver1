import 'package:an_muk_so/login/register_withEmail.dart';
import 'package:flutter/material.dart';

import 'register.dart';
import 'find_password.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/shared/constants.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;

final AuthService _auth = AuthService();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(builder: (BuildContext context) {
        return ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            _EmailPasswordForm(),
          ],
        );
      }),
    );
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String error = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 60, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: SizedBox(
                child: Image.asset('assets/logo/An_Logo.png'),
                width: 200,
                height: 176,
              ),
              padding: EdgeInsets.all(16),
              alignment: Alignment.center,
            ),
            SizedBox(height: 20),
            _emailField(),
            SizedBox(height: 10),
            _passwordField(),
            SizedBox(height: 30),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _submitButton(),
                Spacer(),
                _registerSubmitButton(),
              ],
            ),
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _findPasswordButton(),
              ],
            ),
            SizedBox(height: 10),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      controller: _emailController,
      cursorColor: primary400_line,
      decoration: textInputDecoration.copyWith(hintText: '이메일'),
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isIdFilled = true;
          });
        } else {
          setState(() {
            _isIdFilled = false;
          });
        }
      },
      validator: (String value) {
        if (value.isEmpty) {
          return '아이디(이메일)을 입력해주세요';
        } else if (!value.contains('@')) {
          return '올바른 이메일을 입력해주세요';
        }
        return null;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordController,
      cursorColor: primary400_line,
      decoration: textInputDecoration.copyWith(
          hintText: '비밀번호',
          suffixIcon:
          IconButton(
              icon: _isSecret ?
              SizedBox(
                height: 25,
                  child: Image(image: AssetImage('assets/An_Icon/An_Eye_Off.png'))) :
              SizedBox(
                  height: 25,
                  child: Image(image: AssetImage('assets/An_Icon/An_Eye_On.png'))),
              onPressed: () {
                setState(() {
                  _isSecret = !_isSecret;
                });
              }
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.visibility,
          //     color: _isSecret ? gray200 : Colors.black87,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       _isSecret = !_isSecret;
          //     });
          //   },
          // )
      ),
      obscureText: _isSecret ? true : false,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            _isPasswordFilled = true;
          });
        } else {
          setState(() {
            _isPasswordFilled = false;
          });
        }
      },
      validator: (value) => value.isEmpty ? '비밀번호를 입력해주세요' : null,
    );
  }

  Widget _submitButton() {
    return LoginAMSSubmitButton(
      context: context,
      isDone: _isIdFilled && _isPasswordFilled,
      textString: '로그인',
      textColor: gray800,
      onPressed: () async {
        if (_isIdFilled &&
            _isPasswordFilled &&
            _formKey.currentState.validate()) {
          dynamic result = await _auth.signInWithEmail(
              _emailController.text, _passwordController.text);

          if (result is String) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  result,
                  textAlign: TextAlign.center,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.black.withOpacity(0.87)));
          } else if (result == null) {
            setState(() {
              // loading = false;
              error = 'Could not sign in with those credentials';
            });
          }
        }
      },
    );
  }
  Widget _registerSubmitButton() {
    return RegisterAndFindPasswordButton(
      context: context,
      textString: '회원가입',
      boxColor: gray800,
      textColor: gray0_white,
      onPressed: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterWithEmailPage()),
        );
      },
    );
  }

  Widget _findPasswordButton() {
    return RegisterAndFindPasswordButton(
      context: context,
      textString: '비밀번호 재설정',
      boxColor: gray500,
      textColor: gray0_white,
      onPressed: () async {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FindPassword()),);
      },
    );
  }


}
