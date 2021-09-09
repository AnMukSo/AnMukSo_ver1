import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/review.dart';

import 'package:an_muk_so/mypage/1_edit_privacy.dart';
import 'package:an_muk_so/mypage/3_notice.dart';
import 'package:an_muk_so/mypage/4_inquiry.dart';
import 'package:an_muk_so/mypage/5_policy_terms.dart';
import 'package:an_muk_so/mypage/6_policy_privacy.dart';
import 'package:an_muk_so/mypage/7_others.dart';
import 'package:an_muk_so/mypage/my_reviews.dart';
import 'package:an_muk_so/mypage/my_favorites.dart';

import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/auth.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/services/review.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/loading.dart';
import 'package:an_muk_so/theme/colors.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return (user == null)
        ? Loading()
        : Scaffold(
      appBar: CustomAppBarWithGoToBack('마이페이지', Icon(Icons.close), 0.5),
      backgroundColor: Colors.white,
      body:

      StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _topMyInfo(userData),
                  Container(
                    color: gray50,
                    height: 10,
                  ),
                  _myPageMenu('회원정보 수정', context,
                      EditPrivacyPage(userData: userData)),
                  Container(
                    color: gray50,
                    height: 2,
                  ),
                  // _myPageMenu('키워드 알림 설정', context,
                  //     EditHealthPage(userData: userData)),
                  Container(
                    color: gray50,
                    height: 10,
                  ),
                  // TODO: 공지사항, 1:1문의, 이용약관, 환경설정 페이지
                  _myPageMenu('공지사항', context, NoticePage()),
                  Container(
                    color: gray50,
                    height: 2,
                  ),
                  _myPageMenu('1:1 문의', context, InquiryPage()),
                  Container(
                    color: gray50,
                    height: 2,
                  ),
                  _myPageMenu('이용약관', context, PolicyTermPage()),
                  Container(
                    color: gray50,
                    height: 2,
                  ),
                  _myPageMenu('개인정보 처리방침', context, PolicyPrivacyPage()),
                  Container(
                    color: gray50,
                    height: 10,
                  ),
                  _myPageMenu('기타', context, Others()),
                  Container(
                    color: gray50,
                    height: 2,
                  ),
                ],
              ),
            );
          } else {
            return Loading();
          }
        },
      ),
    );
  }

  Widget _topMyInfo(userData) {
    TheUser user = Provider.of<TheUser>(context);

    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: gray900),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${userData.nickname}',
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(color: gray900),
                          ),
                          TextSpan(
                            text: '님, \n오늘도 건강하세요!',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(_auth.userEmail,
                        style: Theme.of(context).textTheme.caption)
                  ],
                ),
                // TODO: image picker
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: primary300_main,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            //TODO: 이부분은 리뷰랑 찜 부분 됐을 때 하기!!

            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // TODO: 리뷰 갯수뷰
                  StreamBuilder<List<Review>>(
                    stream: ReviewService().getUserReviews(user.uid.toString()),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Review> reviews = snapshot.data;
                        return Row(
                          children: [
                            _myMenu('리뷰', reviews.length.toString(), context,
                                MyReviews()),
                            SizedBox(width: 10)
                          ],
                        );
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                  Container(
                    height: 44,
                    child: VerticalDivider(
                      color: gray75,
                    ),
                  ),
                  StreamBuilder<UserData>(
                    stream: DatabaseService(uid: user.uid).userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List favoriteList = snapshot.data.favoriteList;
                        return Row(
                          children: [
                            SizedBox(width: 10),
                            _myMenu('찜', favoriteList.length.toString(),
                                context, MyFavorites()),
                          ],
                        );
                      } else
                        return CircularProgressIndicator();
                    },
                  ),
                  //_myMenu('1:1 문의', '0', context, MyReviews())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _myMenu(String name, String count, BuildContext context, var nextPage) {
  return InkWell(
    child: Container(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(name,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(color: gray500)),
          Text(count,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: primary500_light_text)),
        ],
      ),
    ),
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextPage),
    ),
  );
}

Widget _myPageMenu(String name, BuildContext context, var nextPage) {
  return InkWell(
      child: Container(
        height: 48,
        padding: EdgeInsets.fromLTRB(20.0, 0, 12.0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray900, fontWeight: FontWeight.normal)),
            Icon(
              Icons.navigate_next,
              color: gray100,
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      });
}
