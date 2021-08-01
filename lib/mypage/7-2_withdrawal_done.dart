import 'package:flutter/material.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

class WithdrawalDonePage extends StatefulWidget {
  @override
  _WithdrawalDonePageState createState() => _WithdrawalDonePageState();
}

class _WithdrawalDonePageState extends State<WithdrawalDonePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('회원 탈퇴', Icon(Icons.close), 0.5),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            children: [
              _information(),
              SizedBox(height: 20),
              _submitButton(context)
            ],
          ),
        ));
  }

  Widget _information() {
    String str1 = '탈퇴가 완료되었습니다';
    String str2 = '더 좋은 이약모약 서비스를 위해 노력하겠습니다';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 80),
        Text(
          str1,
          style: Theme.of(context).textTheme.headline4.copyWith(color: gray700),
        ),
        SizedBox(height: 5),
        Text(
          str2,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(height: 120),
      ],
    );
  }

  Widget _submitButton(context) {
    return AMSSubmitButton(
        context: context,
        isDone: true,
        textString: '첫 화면으로',
        onPressed: () async {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/start', (Route<dynamic> route) => false);
        });
  }
}
