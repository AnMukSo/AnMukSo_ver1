// dandan 브런치를 만들어보자현
//todo 배경 색 맞춰줘야함.
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
//import 'package:an_muk_so/camera/camera_page.dart';

import 'package:an_muk_so/services/db.dart';

//import 'package:an_muk_so/models/drug.dart';
import 'package:an_muk_so/models/user.dart';

//import 'package:an_muk_so/shared/image.dart';

import 'package:an_muk_so/theme/colors.dart';
import 'package:an_muk_so/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
            padding: const EdgeInsets.fromLTRB(5,0,5,0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 60),
                ),
                Column(
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 3),
                      color: Colors.white,
                      child: Text('새로운 소식',
                        style: Theme.of(context).textTheme.headline6,),

                    ),
                    SizedBox(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: 343,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        child: Text('     2021년 8월 아토피 캠프 공지 입니다.',
                            style: Theme.of(context).textTheme.headline5,),
                      ),
                    ),
                  ],
                ),
                //새로운 소식 배너
                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                // 새로운 소식, 새로운 제품 사이 공백
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 3),
                  color: Colors.white,
                  child: Text('새로운 제품',
                    style: Theme.of(context).textTheme.headline6,),

                ),
                GridView.builder(
                  shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 150,
                        childAspectRatio: 1 / 1.2,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0),
                    itemCount: entries.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Container(
                                    child: SizedBox(
                                        width: 110,
                                        height: 110,
                                        child: Image.asset(entries2[index])),
                                  ),
                                  Text(entries[index],
                                    style: Theme.of(context).textTheme.subtitle2,
                                      ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => MyApp()),
                              );
                            },
                          ),
                        ],
                      );
                    }),
                //
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 3),
                  color: Colors.white,
                  child: Text('안먹소 먹거리 정보 채널 ( YOUTUBE )',
                    style: Theme.of(context).textTheme.headline6,),
                  ),
                SizedBox(
                  child: Container(
                      alignment: Alignment.center,
                      width: 343,
                      height: 228,
                      child: Image.asset('assets/snacks/tasteOfNature.png')
                    // AssetImage('assets/snacks/octopus.png'),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.fromLTRB(3,10, 0.0, 3),
                      color: Colors.white,
                      child: Text('후원 계좌',
                          style: Theme.of(context).textTheme.headline6,),

                    ),
                    SizedBox(
                      child: Container(
                        alignment: Alignment.center,
                        width: 342,
                        height: 76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black, width: 3)),
                        child: Text('우리은행 1002-101-21-2229 안전한 먹거리 소비자 연합\n'
                            '    카카오 1242-445-6446 안전한 먹거리 소비자 연합',
                        style: Theme.of(context).textTheme.subtitle1,),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 100, 0.0, 0),
                  color: Colors.white,
                ),
                //하단 공백
              ],
            ),
        ),
          ),
    ],
      ),
    );
  }
}


final entries = [
  '농심 새우깡',
  '농심 양파링',
  '농심 포스틱',
  '롯데 칙촉',
  '오리온 초코송이',
  '농심 자갈치',
];
//상품명 리스

final entries2 = [
  'assets/snacks/shrimp.png',
  'assets/snacks/onionRing.png',
  'assets/snacks/postick.png',
  'assets/snacks/chickchock.png',
  'assets/snacks/chocolate.png',
  'assets/snacks/octopus.png',
];
//상품 사진 경로 리스트