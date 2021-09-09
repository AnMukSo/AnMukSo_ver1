import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:an_muk_so/services/db.dart';

//import 'package:an_muk_so/models/drug.dart';
import 'package:an_muk_so/models/user.dart';

//import 'package:an_muk_so/shared/image.dart';

import 'package:an_muk_so/theme/colors.dart';
import 'package:an_muk_so/main.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {

  YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: 'MaRpEllkmPs', //여기에 안먹소 유투브 링크 주소 넣기
      flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //배경 색 지정 완료
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
            padding: const EdgeInsets.fromLTRB(16,0,16,0),
            child: Column(
              children: [
                //새로운 소식 배너
                Column(
                  children: [
                    Container(height: 50, color: Colors.white,),
                    Container(
                      height: 25,
                      alignment: Alignment.topLeft,
                      //padding: EdgeInsets.only(left: 16),
                      color: Colors.white,
                      child: Text('새로운 소식',
                        style: Theme.of(context).textTheme.headline5),

                    ),
                    //TODO: 이부분에 공지 제목 DB필요함 글씨가 몇자 이상일 때...으로 표현 되는 것도 감안해야한다.
                    SizedBox(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity - 32,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('2021년 8월 아토피 캠프 공지 입니다.',
                              style: Theme.of(context).textTheme.headline5,),
                        ),
                      ),
                    ),
                  ],
                ),
                // 새로운 소식, 새로운 제품 사이 공백
                Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                //새로운 제품
                Container(
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  child: Text('새로운 제품',
                    style: Theme.of(context).textTheme.headline5,),

                ),
                //새로운 제품 DB에서 불러올 것들
                GridView.builder(
                    physics: new NeverScrollableScrollPhysics(),
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
                             print('새로운 제품 ${entries[index]}');
                            },
                          ),
                        ],
                      );
                    }),
                //
                Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                //TODO: 유투브 링크 타고 갈 수 있도록 화면 보여주는 것과, 그 유투브로 이동할 수 있게끔 하는 것!!
                Container(
                  height: 25,
                  alignment: Alignment.centerLeft,
                  //padding: EdgeInsets.only(left: 3),
                  color: Colors.white,
                  child: Text('안먹소 먹거리 정보 채널 ( YOUTUBE )',
                    style: Theme.of(context).textTheme.headline5,),
                  ),
                SizedBox(
                  child:    YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: primary300_main,
                  )
                ),
                Column(
                  children: [
                    Container(
                      padding:EdgeInsets.only(top: 26, bottom: 9),
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      child: Text('후원 계좌',
                          style: Theme.of(context).textTheme.headline5,),
                    ),
                    SizedBox(
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity - 32,
                        height: 76,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.black, width: 2)),
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