import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/mypage/7-1_withdrawal.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/dialog.dart';
import 'package:an_muk_so/theme/colors.dart';

class Others extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return (user == null)
        ? LinearProgressIndicator()
        : Scaffold(
            appBar: CustomAppBarWithGoToBack('기타', Icon(Icons.arrow_back), 0.5),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(height: 12),
                InkWell(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('회원 탈퇴',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: gray900,
                                    fontWeight: FontWeight.normal)),
                        Icon(
                          Icons.navigate_next,
                          color: gray100,
                        ),
                      ],
                    ),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WithdrawalPage(userId: user.uid)),
                  ),
                ),
                Container(
                  color: gray50,
                  height: 2,
                ),
                InkWell(
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('로그아웃',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                    color: gray900,
                                    fontWeight: FontWeight.normal)),
                        Icon(
                          Icons.navigate_next,
                          color: gray100,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    AMSDialog(
                        context: context,
                        bodyString: '정말 로그아웃하시겠어요?',
                        leftButtonName: '취소',
                        leftOnPressed: () {
                          Navigator.pop(context);
                        },
                        rightButtonName: '로그아웃',
                        rightOnPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/start', (Route<dynamic> route) => false);
                        }).showWarning();
                  },
                ),
                Container(
                  color: gray50,
                  height: 2,
                ),
              ],
            ));
  }

}
