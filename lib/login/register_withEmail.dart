import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/shared/constants.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isSecret = true;
bool _isIdFilled = false;
bool _isPasswordFilled = false;

class RegisterWithEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RegisterWithEmailPageState();
}

class RegisterWithEmailPageState extends State<RegisterWithEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('회원가입',  Image(
          image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: RegisterForm(),
          ),
        );
      }),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text('환영합니다\n기본정보를 설정해주세요',
                  style: Theme.of(context).textTheme.headline3),
            ),
            SizedBox(
              height: 24,
            ),
            emailField(),
            SizedBox(
              height: 20,
            ),
            passwordField(),
            SizedBox(height: 50.0),
            submitField(context),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget emailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '아이디 (이메일)',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _emailController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(hintText: 'abc@anmukso.com'),
          onChanged: (value) {
            if (value.length > 6) {
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
              return '이메일을 입력해주세요';
            } else if (!value.contains('@')) {
              return '올바른 이메일을 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget passwordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '비밀번호',
          style: Theme.of(context).textTheme.subtitle2,
        ),
        TextFormField(
          controller: _passwordController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(
              hintText: '8자리 이상',
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.visibility,
                  color: _isSecret ? gray200 : gray750_activated,
                ),
                onPressed: () {
                  setState(() {
                    _isSecret = !_isSecret;
                  });
                },
              )),
          obscureText: _isSecret ? true : false,
          onChanged: (value) {
            if (value.length >= 8) {
              setState(() {
                _isPasswordFilled = true;
              });
            } else {
              setState(() {
                _isPasswordFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty || value.length < 8) {
              return '8자리 이상 입력해주세요';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget submitField(context) {
    final TheUser user = Provider.of<TheUser>(context);

    return AMSSubmitButton(
        context: context,
        isDone: _isIdFilled && _isPasswordFilled,
        textString: '안먹소 시작하기',
        onPressed: () async {
          if (_isIdFilled &&
              _isPasswordFilled &&
              _formKey.currentState.validate()) {
            dynamic result = await _auth.signUpWithEmail(
                _emailController.text, _passwordController.text);

            /* 오류 발생시 snackbar로 알려줌 */
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
            }
            /* 정상적으로 넘어간 경우  */
            else {
              await _auth.signOut();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '회원가입이 완료되었습니다.',
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/start', (Route<dynamic> route) => false);
            }
          }
        });
  }
}
