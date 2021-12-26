import 'package:flutter/material.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/shared/constants.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isFilled = false;
final AuthService _auth = AuthService();

class FindPassword extends StatefulWidget {
  @override
  _FindPasswordState createState() => _FindPasswordState();
}

class _FindPasswordState extends State<FindPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('비밀번호 재설정', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 40, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '비밀번호 재설정\n이메일을 보내드려요',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '가입 시 입력한 이메일 주소를 입력해주세요.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      '아이디 (이메일)',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: primary400_line,
                      decoration: textInputDecoration.copyWith(
                          hintText: 'abc@anmukso.com'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _isFilled = true;
                          });
                        } else {
                          setState(() {
                            _isFilled = false;
                          });
                        }
                      },
                      validator: (String value) {
                        if (value.isEmpty) {
                          return '이메일을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    AMSSubmitButton(
                      context: context,
                      isDone: _isFilled,
                      textString: '전송하기',
                      onPressed: () async {
                        if (_isFilled && _formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .sendPasswordResetEmail(_emailController.text);
                          if (result is String) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  result,
                                  textAlign: TextAlign.center,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                Colors.black.withOpacity(0.87)));
                          }
                          if (result == null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  '이메일이 전송되었습니다.',
                                  textAlign: TextAlign.center,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor:
                                Colors.black.withOpacity(0.87)));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/start', (Route<dynamic> route) => false);
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
