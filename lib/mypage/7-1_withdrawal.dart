import 'package:flutter/material.dart';
import 'package:an_muk_so/mypage/7-2_withdrawal_done.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isAgree = false;

class WithdrawalPage extends StatefulWidget {
  final String userId;

  const WithdrawalPage({Key key, this.userId}) : super(key: key);

  @override
  _WithdrawalPageState createState() => _WithdrawalPageState();
}

class _WithdrawalPageState extends State<WithdrawalPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBarWithGoToBack('회원 탈퇴',  Image(
            image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            SizedBox(height: 24),
            _topWarning(),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            _checkAgreement(),
            SizedBox(height: 40),
            _submitButton(context)
          ],
        ));
  }

  Widget _topWarning() {
    String str1 = '- 탈퇴 시, 안전한 먹거리 소비자 연합에 저장한 내역이 모두 삭제되며 탈퇴 이후 복구가 불가능합니다.';
    String str2 = '- 작성된 리뷰는 삭제되지 않으며, 이를 원치 않을 경우 작성한 리뷰를 모두 삭제하신 후 탈퇴해주세요.';
    String str3 = '- 서비스 탈퇴 후, 전자상거래법과 통신비밀보호법 등 관련 법령에 의거하여 일정기간 개인정보가 보관됩니다.';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            str1,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
          SizedBox(height: 10),
          Text(
            str2,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
          SizedBox(height: 10),
          Text(
            str3,
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: gray750_activated),
          ),
        ],
      ),
    );
  }

  Widget _checkAgreement() {
    return InkWell(
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: gray300_inactivated),
            child: Checkbox(
              value: _isAgree,
              activeColor: primary300_main,
              onChanged: (value) {
                setState(() {
                  _isAgree = !_isAgree;
                });
              },
            ),
          ),
          Text(
            '위 사실을 확인하였습니다.',
            style:
                Theme.of(context).textTheme.bodyText2.copyWith(color: gray900),
          )
        ],
      ),
      onTap: () {
        setState(() {
          _isAgree = !_isAgree;
        });
      },
    );
  }

  Widget _submitButton(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AMSSubmitButton(
          context: context,
          isDone: _isAgree,
          textString: '탈퇴하기',
          onPressed: () async {
            if (_isAgree) {
              await DatabaseService().deleteUser(widget.userId);

              dynamic result = await _auth.withdrawalAccount();

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
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WithdrawalDonePage()),
                );
              }
            }
          }),
    );
  }
}
