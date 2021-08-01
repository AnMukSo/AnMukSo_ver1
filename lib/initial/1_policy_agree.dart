import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/initial/2_get_privacy.dart';
import 'package:an_muk_so/models/user.dart';

import 'package:an_muk_so/mypage/6_policy_privacy.dart';
import 'package:an_muk_so/mypage/5_policy_terms.dart';

import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isTermsAgreed = false;
bool _isPrivacyAgreed = false;

class PolicyAgreePage extends StatefulWidget {
  @override
  _PolicyAgreePageState createState() => _PolicyAgreePageState();
}

class _PolicyAgreePageState extends State<PolicyAgreePage> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          '이용약관',
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
        ),
        elevation: 0.5,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.fromLTRB(8, 16, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topTitle(),
            SizedBox(
              height: 24,
            ),
            allCheckbox(),
            Divider(
              color: Colors.grey,
              indent: 8,
              endIndent: 8,
              // height: 30,
            ),
            termsCheckbox(),
            // SizedBox(
            //   height: 10,
            // ),
            privacyCheckbox(),
            SizedBox(
              height: 50,
            ),
            submitField(user)
          ],
        ),
      ),
    );
  }

  Widget topTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Text(
        '서비스 이용을 위해\n이용약관에 동의해주세요 :)',
        style: Theme.of(context).textTheme.headline3,
      ),
    );
  }

  Widget allCheckbox() {
    return InkWell(
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: gray300_inactivated),
            child: Checkbox(
              value: _isTermsAgreed && _isPrivacyAgreed,
              activeColor: primary300_main,
              onChanged: (value) {
                setState(() {
                  if (_isTermsAgreed != _isPrivacyAgreed) {
                    _isTermsAgreed = true;
                    _isPrivacyAgreed = true;
                  } else {
                    _isTermsAgreed = !_isTermsAgreed;
                    _isPrivacyAgreed = !_isPrivacyAgreed;
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            '전체동의',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
      onTap: () {
        setState(() {
          if (_isTermsAgreed != _isPrivacyAgreed) {
            _isTermsAgreed = true;
            _isPrivacyAgreed = true;
          } else {
            _isTermsAgreed = !_isTermsAgreed;
            _isPrivacyAgreed = !_isPrivacyAgreed;
          }
        });
      },
    );
  }

  Widget termsCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            child: Row(
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: gray300_inactivated),
                  child: Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        _isTermsAgreed = !_isTermsAgreed;
                      });
                    },
                    value: _isTermsAgreed,
                    activeColor: primary300_main,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Text('(필수) 이용약관',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray900)),
              ],
            ),
            onTap: () {
              setState(() {
                _isTermsAgreed = !_isTermsAgreed;
              });
            },
          ),
        ),
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              '보기',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PolicyTermPage()),
            );
          },
        ),
      ],
    );
  }

  Widget privacyCheckbox() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: InkWell(
            child: Row(
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: gray300_inactivated),
                  child: Checkbox(
                    onChanged: (bool value) {
                      setState(() {
                        _isPrivacyAgreed = !_isPrivacyAgreed;
                      });
                    },
                    value: _isPrivacyAgreed,
                    activeColor: primary300_main,
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                Text('(필수) 개인정보 처리방침',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray900)),
              ],
            ),
            onTap: () {
              setState(() {
                _isPrivacyAgreed = !_isPrivacyAgreed;
              });
            },
          ),
        ),
        InkWell(
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                '보기',
                style: Theme.of(context).textTheme.caption,
              )),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PolicyPrivacyPage()),
            );
          },
        ),
      ],
    );
  }

  Widget submitField(user) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: AMSSubmitButton(
        context: context,
        isDone: _isTermsAgreed && _isPrivacyAgreed,
        textString: '다음',
        onPressed: () async {
          if (_isTermsAgreed && _isPrivacyAgreed) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GetPrivacyPage()),
            );
          }
        },
      ),
    );
  }
}
