import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/mypage/3_notice.dart';
import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:an_muk_so/services/db.dart';



import 'package:an_muk_so/theme/colors.dart';
import 'package:an_muk_so/main.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String videoID = 'WUrEimln4as'; // 여기는 원래 두는 코드로 두고 업데이트 되는 걸로 확인 해보

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //배경 색 지정 완료
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                children: [
                  //새로운 소식 배너
                  Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.white,
                      ),
                      Container(
                        height: 25,
                        alignment: Alignment.topLeft,
                        //padding: EdgeInsets.only(left: 16),
                        color: Colors.white,
                        child: Text('새로운 소식',
                            style: Theme.of(context).textTheme.headline5),
                      ),
                      //TODO: 이부분에 공지 제목 DB필요함 글씨가 몇자 이상일 때...으로 표현 되는 것도 감안해야한다.
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoticePage(),
                            ),
                          ),
                        },
                        child: SizedBox(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            width: double.infinity - 32,
                            height: 50,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: NoticeContentBox(context)
                                // Text( NoticeContents,
                                //     style: Theme.of(context).textTheme.headline5,),
                                ),
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
                    height: 28,
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Text(
                      '새로운 제품',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  //새로운 제품 DB에서 불러올 것들
                  _newList(context),
                  //
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    //padding: EdgeInsets.only(left: 3),
                    color: Colors.white,
                    child: Text(
                      '안먹소 먹거리 정보 채널 ( YOUTUBE )',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  _getVideoId(context),
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Bank')
                          .doc('later')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container();
                        }
                        bool later = snapshot.data.data()['later'];
                        return Column(
                          children: [
                            later
                                ? _bankTitleBox(context, 'title') : Container(),
                            later ? _bankBox(context, 'bank1') : Container(),
                            SizedBox(
                              height: 10,
                            ),
                            later ? _bankBox(context, 'bank2') : Container(),
                          ],
                        );
                      }),
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

  Widget _getVideoId(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('VideoId')
          .doc('id')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        videoID = snapshot.data.data()['id'];
        print('videoID == $videoID');

        YoutubePlayerController _controller = YoutubePlayerController(
            initialVideoId: videoID, //여기에 안먹소 유투브 링크 주소 넣기
            flags: YoutubePlayerFlags(autoPlay: false, mute: false));
        //return Container(child: Text(videoID),); //(child: Text(snapshot.data.data()['id']),);
        return SizedBox(
            child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: primary300_main,
        ));
      },
    );
  }

  Widget NoticeContentBox(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Notices')
            .doc('0')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          String content = snapshot.data.data()['title'];

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        content,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  )),
            ],
          );
        });
  }

  Widget _bankBox(BuildContext context, bankNum) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Bank')
            .doc(bankNum)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          String bank = snapshot.data.data()['bank'];
          String account = snapshot.data.data()['account'];
          String name = snapshot.data.data()['name'];

          return SizedBox(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity - 32,
              //\height: ,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.black, width: 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            '$bank $account \n $name',
                            style: Theme.of(context).textTheme.subtitle1,
                          )
                        ],
                      )),
                ],
              ),
            ),
          );
        });
  }

  Widget _bankTitleBox(BuildContext context, title) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Bank')
            .doc(title)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          String bankTitle = snapshot.data.data()['bankTitle'];

          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 26, bottom: 9),
                alignment: Alignment.topLeft,
                color: Colors.white,
                child: Text(
                  '$bankTitle',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ],
          );
        });
  }

  Widget _newList(BuildContext context) {
    return StreamBuilder<List<NewFood>>(
        stream: DatabaseService().listOfNewFoodData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildNewList(context, snapshot.data);
        });
  }

  Widget _buildNewList(BuildContext context, List<NewFood> snapshot) {
    int count = snapshot.length;

    if (count == 0) {
      return Container(
        width: MediaQuery.of(context).size.height - 32,
        decoration: BoxDecoration(border: Border.all(color: gray75)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "[추후 제품 업데이트 예정]",
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
      );
    }
    String _shortenName(String name) {
      if (name.length > 7) {
        name = name.substring(0, 7);
        name = name + '...';
      }

      return name;
    }

    return GridView.builder(
        physics: new NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1 / 1.2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0),
        itemCount: snapshot.length,
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
                          child: Container(
                              width: 88,
                              child: FoodImage(
                                  foodItemSeq: snapshot[index].itemSeq)),
                        ),
                      ),
                      Text(
                        _shortenName(snapshot[index].itemName),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                onTap: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReviewPage(snapshot[index].itemSeq),
                    ),
                  ),
                },
              ),
            ],
          );
        });
  }
}
