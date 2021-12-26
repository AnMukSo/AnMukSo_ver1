import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/bottom_bar_navigation.dart';

import 'package:an_muk_so/expiration/general_expiration.dart';
// import 'package:an_muk_so/food_info/prepared_expiration.dart';
// import 'package:an_muk_so/food_info/search_highlighting.dart';
// import 'package:an_muk_so/food_info/warning_highlighting.dart';

import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/mypage/my_favorites.dart';
import 'package:an_muk_so/review/review_policy_more.dart';

import 'package:an_muk_so/review/see_my_review.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/services/review.dart';

import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/shared/loading.dart';

import 'package:an_muk_so/review/all_review.dart';
import 'package:an_muk_so/review/get_rating.dart';
import 'package:an_muk_so/review/review_list.dart';
import 'package:an_muk_so/review/write_review.dart';

import 'package:an_muk_so/shared/shortcut_dialog.dart';

import 'package:an_muk_so/theme/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';


List infoEE;
List infoNB;
List infoUD;
String storage;
String entpName;

class ReviewPage extends StatefulWidget {
  final String foodItemSeq;
  String fromRankingTile = '';
  final String filter;
  final String type;

  ReviewPage(this.foodItemSeq, {this.fromRankingTile, this.filter, this.type});

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  _ReviewPageState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  GlobalKey _key1 = GlobalKey();
  GlobalKey _key2 = GlobalKey();
  GlobalKey _key3 = GlobalKey();

  double _getReviewSizes() {
    final RenderBox renderBox1 = _key1.currentContext.findRenderObject();
    final RenderBox renderBox3 = _key3.currentContext.findRenderObject();
    double height = renderBox1.size.height + renderBox3.size.height + 30;
    return height;
  }

  double _getInfoSize() {
    final RenderBox renderBox1 = _key1.currentContext.findRenderObject();
    double height = renderBox1.size.height;
    return height;
  }

  var _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }


  void _onTapInfo() {
    _scrollController.animateTo(_getInfoSize(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
    setState(() {
      InfoTab = true;
    });
  }

  void _onTapReview() {
    setState(() {
      InfoTab = false;
    });
    _scrollController.animateTo(_getReviewSizes(),
        duration: Duration(milliseconds: 400), curve: Curves.easeOut);
  }

  bool InfoTab = true;
  bool _ifZeroReview = true;

  void _noReview() {
    _ifZeroReview = true;
  }

  void _existReview() {
    _ifZeroReview = false;
  }

  bool checkReviewIsZero() {
    return _ifZeroReview;
  }


  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);
    String filter = 'nothing';
    bool check = false;
    if (widget.filter != null) {
      filter = widget.filter;
      check = true;
    }
    String rankingCategory = 'notFromRanking';
    if (widget.type != null) {
      rankingCategory = widget.type;
    }

    return Scaffold(
        backgroundColor: gray0_white,
        appBar: check
            ? CustomAppBarWithGoToRanking('상품 정보', Icon(Icons.arrow_back), 0.5,
                filter: filter, category: rankingCategory)
            : CustomAppBarWithGoToRanking('상품 정보', Icon(Icons.arrow_back), 0.5),
        floatingActionButton: FloatingActionButton(
           // child: Icon(Icons.create),
          //child: ImageIcon(AssetImage('assets/An_Icon/An_Write.png'), color: Colors.red),
           child: SizedBox(
                height: 50,
                width: 50,
                child: Image(image: AssetImage('assets/an_icon_resize/An_Write.png'))),
            backgroundColor: primary300_main,
            elevation: 6.0,
            onPressed: () async {
              if (await ReviewService()
                      .findUserWroteReview(widget.foodItemSeq, user.uid) ==
                  false)
                GotoSeeOrCheckDialog();
              else
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            WriteReview(foodItemSeq: widget.foodItemSeq)));
            }),
        body: StreamProvider<List<Review>>.value(
          value: ReviewService().getReviews(widget.foodItemSeq),
          child: StreamBuilder<Food>(
              stream: DatabaseService(itemSeq: widget.foodItemSeq).foodData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Food food = snapshot.data;
                  return StreamBuilder<UserData>(
                      stream: DatabaseService(uid: user.uid).userData,
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          UserData userData = snapshot2.data;
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child:
                                NotificationListener<ScrollUpdateNotification>(
                              child: CustomScrollView(
                                controller: _scrollController,
                                slivers: <Widget>[
                                  SliverToBoxAdapter(
                                    child:
                                        _topInfo(context, food, user, userData),
                                  ),
                                  SliverAppBar(
                                    elevation: 0,
                                    flexibleSpace: Row(
                                      key: _key2,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          child: InkWell(
                                              child: Center(
                                                  child: Text("상품 정보",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle1
                                                          .copyWith(
                                                            color: InfoTab ==
                                                                    true
                                                                ? primary500_light_text
                                                                : gray300_inactivated,
                                                          ))),
                                              onTap: _onTapInfo
                                              ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: InfoTab == true
                                                          ? primary400_line
                                                          : gray100,
                                                      width: InfoTab == true
                                                          ? 2.0
                                                          : 1.0))),
                                        ),
                                        Container(
                                          child: InkWell(
                                            child: Center(
                                                child: Text("리뷰",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1
                                                        .copyWith(
                                                          color: InfoTab ==
                                                                  true
                                                              ? gray300_inactivated
                                                              : primary500_light_text,
                                                        ))),
                                            onTap: _onTapReview,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      //color: pillInfoTab == true
                                                    color: InfoTab == true
                                                     ? gray100
                                                          : primary400_line,
                                                      width: InfoTab == true
                                                          ? 1.0
                                                          : 2.0))),
                                        )
                                      ],
                                    ),
                                    leading: Container(),
                                    pinned: true,
                                    backgroundColor: Colors.white,
                                  ),
                                  SliverToBoxAdapter(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      _underInfo(context, food, userData),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 10.0,
                                        child: Container(
                                          color: gray50,
                                        ),
                                      ),
                                    ],
                                  )),
                                  SliverToBoxAdapter(
                                    child: _totalRating(),
                                  ),
                                  SliverToBoxAdapter(
                                    child: _drugReviews(),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          return Container();
                        }
                      });
                } else {
                  return Loading();
                }
              }),
        ));
  }

  /* Top Information */
  Widget _topInfo(
      BuildContext context, Food food, TheUser user, UserData userData) {
    bool _isFavorite = userData.favoriteList.contains(food.itemSeq);

    return StreamBuilder<List<SavedFood>>(
      stream: DatabaseService(uid: user.uid).savedFoods,
      builder: (context, snapshot3) {
        if (snapshot3.hasData) {
          List<SavedFood> savedFoods = snapshot3.data;
          bool _isSaved = false;
          for (SavedFood savedFoods in savedFoods) {
            _isSaved = savedFoods.itemSeq.contains(food.itemSeq);
            if (_isSaved == true) break;
          }

          return Column(
            children: [
              Padding(
                key: _key1,
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Center(
                        child: Container(
                          width: 188,
                          child: FoodImage(foodItemSeq: food.itemSeq),
                        ),
                      ),
                      SizedBox(height: 30),
                      Row(
                        children: [
                          Text(food.entpName,
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1
                                  .copyWith(
                                    color: gray300_inactivated,
                                  )),
                        ],
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * (0.8),
                        child: Text(_shortenName(food.itemName),
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                    color: gray750_activated, fontSize: 16)),
                      ),
                      SizedBox(height: 10),
                      Row(children: <Widget>[
                        RatingBarIndicator(
                          rating: food.totalRating * 1.0,
                          itemBuilder: (context, index) =>
                          //TODO: icons에 star이 없는 걸로 아는데 넣어두기
                              ImageIcon(
                            AssetImage('assets/icons/star.png'),
                            color: yellow,
                          ),
                          itemCount: 5,
                          itemSize: 18.0,
                          unratedColor: gray75,
                          direction: Axis.horizontal,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                        ),
                        Container(width: 5),
                        Text(food.totalRating.toStringAsFixed(1),
                            style:
                                Theme.of(context).textTheme.subtitle1.copyWith(
                                      color: gray900,
                                    )),
                        Text(" (" + food.numOfReviews.toStringAsFixed(0) + '개)',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    color: gray300_inactivated, fontSize: 12)),
                        Text(' 안먹소 평가단 기준', style: Theme.of(context).textTheme.subtitle1.copyWith(color: gray700, fontSize: 12),)
                      ]),
                      Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                                height: 24,
                                child: InFoCategoryButton(
                                    str: food.rankCategory, fromFoodInfo: true)),
                            Expanded(
                              child: Container(),
                            ),
                            InkWell(
                              onTap: () async {
                                if (_isFavorite) {
                                  await DatabaseService(uid: user.uid)
                                      .removeFromFavoriteList(food.itemSeq);
                                } else {
                                  ShortCutDialog(
                                    context: context,
                                    dialogIcon:
                                         Icon(Icons.favorite, color: warning),
                                    boldBodyString: '찜 목록',
                                    normalBodyString: '에 추가되었습니다',
                                    //topButtonName: '바로가기',
                                    bottomButtonName: '확인',
                                    onPressedTop: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyFavorites()));
                                    },
                                    onPressedBottom: () {
                                      Navigator.pop(context);
                                    },
                                  ).showWarning();

                                  await DatabaseService(uid: user.uid)
                                      .addToFavoriteList(food.itemSeq);
                                  // _showFavoriteWell(context);
                                }
                              },
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  border: Border.all(color: gray75),
                                  color: gray50,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child:
                                IconButton(
                                  icon: _isFavorite
                                         ? ImageIcon(
                                    AssetImage('assets/An_Icon/An_Heart_On.png'),
                                    color: warning,
                                  )
                                        : ImageIcon(
                                    AssetImage('assets/An_Icon/An_Heart_Off.png'),
                                    color: gray300_inactivated
                                  ),
                                ),
                                // Icon(
                                //   _isFavorite
                                //       ? Icons.favorite
                                //       : Icons.favorite_border,
                                //   color: _isFavorite
                                //       ? warning
                                //       : gray300_inactivated,
                                //   size: 24,
                                //   )
                               ),
                            ),
                            Container(
                              width: 8,
                            ),
                            ButtonTheme(
                              minWidth: 80,
                              height: 36,
                              child: FlatButton(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                color: primary300_main,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add,
                                        color: gray0_white, size: 18),
                                    Text(
                                      '담기',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: gray0_white),
                                    ),
                                    SizedBox(width: 2)
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                      color: primary400_line,
                                    )),
                                onPressed: () {
                                  if (_isSaved) {
                                    ShortCutDialog(
                                      context: context,
                                      dialogIcon: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Image.asset(
                                              'assets/icons/warning_icon_primary.png')
                                      ),
                                      boldBodyString: '',
                                      normalBodyString: '이미 담은 상품입니다',
                                      //topButtonName: '나의 상품 보관함 바로가기',
                                      bottomButtonName: '확인',
                                      onPressedTop: () {
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BottomBar()));
                                        go = 1; //이거도 일단 지켜봐야 하는 변수
                                      },
                                      onPressedBottom: () {
                                        Navigator.pop(context);
                                      },
                                    ).showWarning();
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            fullscreenDialog: true,
                                            builder: (context) {
                                                return GeneralExpiration(
                                                  foodItemSeq: food.itemSeq,
                                                );
                                            }));
                                  }
                                },
                              ),
                            ),
                          ]),
                    ]),
              ),
              SizedBox(
                width: double.infinity,
                height: 10.0,
                child: Container(
                  color: gray50,
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  String _shortenName(String data) {
    String newName = data;
    List splitName = [];

    if (data.contains('(수출')) {
      splitName = newName.split('(수출');
      newName = splitName[0];
    }

    if (data.contains('(군납')) {
      splitName = newName.split('(군납');
      newName = splitName[0];
    }
    return newName;
  }


  /* Under Information */
  Widget _underInfo(BuildContext context, Food food, UserData userData) {
    return Padding(
      key: _key3,
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('주의사항 (알러지 유발 성분)',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                        color: gray750_activated,
                      )),
            ),
            Text(food.warningData,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray600, height: 1.6)),
            SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text('원산지',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                    color: gray750_activated,
                  )),
            ),
            Text(food.itemCountry,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: gray600, height: 1.6)),
            SizedBox(height: 22),

          ]),
    );
  }
/*
  Widget _foodDocInfo(BuildContext context, String foodItemSeq, String type) {
    return StreamBuilder<Food>(
        stream: DatabaseService(itemSeq: foodItemSeq).foodData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Food food = snapshot.data;
            entpName = food.entpName;
            //infoNB = food.warningData;
            if (type == 'WARNING') {
              return       Text(food.warningData,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray600, height: 1.6));
              // return ListView.builder(
              //     padding: EdgeInsets.fromLTRB(0, 0, 0, 16),
              //     physics: const ClampingScrollPhysics(),
              //     shrinkWrap: true,
              //     itemCount: food.warningData.length,
              //     itemBuilder: (BuildContext context, int index) {
              //       return Text(
              //         food.warningData[index].toString(),
              //       );
              //     });
            }  else {
              return Container();
            }
          } else {
            return Container();
          }
        });
  }
*/
  Widget _totalRating() {
    return Column(
      children: [
        GetRating(widget.foodItemSeq),
        Container(
          height: 4,
          color: gray50,
        ),
      ],
    );
  }

  Widget _reviewWarning() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 5),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 15,
                height: 15,
                child: Image.asset('assets/icons/warning_icon_primary.png'),
              ),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: gray300_inactivated, fontSize: 11),
                  children: <TextSpan>[
                    TextSpan(
                        text: "맛과 알러지는 개인에 따라 다를 수 있습니다.",
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                            color: gray600,
                            fontSize: MediaQuery.of(context).size.width <= 320
                                ? 11
                                : 12)),
                  ],
                ),
              ),
              Container(width: 5),

              InkWell(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                          color: gray300_inactivated,
                          fontSize: MediaQuery.of(context).size.width <= 320
                              ? 10
                              : 11,
                          decoration: TextDecoration.underline,
                        ),
                    children: <TextSpan>[
                      TextSpan(text: '더 보기 '),
                    ],
                  ),
                ),
                onTap: () {
                  //TODO: 리뷰 정책 안내
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewPolicyMore()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* Review */
  Widget _drugReviews() {

    return StreamBuilder<Food>(
        stream: DatabaseService(itemSeq: widget.foodItemSeq).foodData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Food food = snapshot.data;
            if (food.numOfReviews > 0)
              _existReview();
            else
              _noReview();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("리뷰 " + food.numOfReviews.toStringAsFixed(0) + "개",
                          style: Theme.of(context).textTheme.subtitle1.copyWith(
                                color: gray750_activated,
                              )),
                      checkReviewIsZero() == true
                          ? Container()
                          : Row(
                              children: [
                                FlatButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AllReview(
                                                  widget.foodItemSeq,
                                                  food.itemName)));
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('전체리뷰 보기',
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    color: gray500,
                                                    fontSize: 12)),
                                        Icon(
                                          Icons.keyboard_arrow_right,
                                          color: gray500,
                                          size: 20,
                                        )
                                      ],
                                    )),
                              ],
                            ),
                    ],
                  ),
                ),
                checkReviewIsZero() == true ? Container() : _searchBar(),
                checkReviewIsZero() == true ? Container() : _reviewWarning(),
                checkReviewIsZero() == true
                    ? Container(
                        height: 310,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Container(
                              height: 30,
                            ),
                            Container(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Center(
                                  child: Text("아직 작성된 리뷰가 없어요",
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: gray300_inactivated),
                                  ),
                                ),
                                Center(
                                  child: Text("리뷰를 작성해주세요",
                                    style: Theme.of(context).textTheme.subtitle2.copyWith(color: gray300_inactivated),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ))
                    : ReviewList(_searchText, "all", widget.foodItemSeq),
              ],
            );
          } else
            return Container();
        });
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 35,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: TextField(
                  focusNode: focusNode,
                  style: TextStyle(fontSize: 15),
                  controller: _filter,
                  decoration: InputDecoration(
                      fillColor: gray50,
                      filled: true,
                      prefixIcon: SizedBox(
                        height: 10,
                        width: 10,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 4),
                          child: Image.asset('assets/icons/search_grey.png'),
                        ),
                      ),
                      hintText: '어떤 리뷰를 찾고계세요?',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                      contentPadding: EdgeInsets.zero,
                      labelStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: gray75)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              style: BorderStyle.solid,
                              width: 1.0,
                              color: gray75),
                          borderRadius: BorderRadius.circular(8.0))),
                )),
          ],
        ),
      ),
    );
  }

  Widget GotoSeeOrCheckDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Icon(Icons.star, color: yellow),
              SizedBox(height: 13),
              /* BODY */
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    TextSpan(text: "해당 상품에 대한 리뷰를\n이미 작성하셨습니다"),
                  ],
                ),
              ),
              SizedBox(height: 3),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "내가 작성한 리뷰 보러가기",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: gray300_inactivated),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: gray300_inactivated,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SeeMyReview(widget.foodItemSeq)));
                  }),
              SizedBox(width: 16),
              /* RIGHT ACTION BUTTON */
              ElevatedButton(
                child: Text(
                  "확인",
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: primary400_line),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(260, 40),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                    primary: gray50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: gray75))),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

}
