import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/review.dart';
import 'package:an_muk_so/shared/loading.dart';
import 'package:an_muk_so/review/review_box.dart';
import 'package:an_muk_so/theme/colors.dart';
import 'edit_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ReviewList extends StatefulWidget {
  String searchText;
  String filter;
  String drugItemSeq;
  String type;
  Review review;
  ReviewList(this.searchText, this.filter, this.drugItemSeq,
      {this.type, this.review});

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return widget.type == "mine"
        ? ListView.builder(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (context, index) {
              return _buildListItem(context, widget.review);
            },
          )
        : StreamBuilder<List<Review>>(
            stream: ReviewService().getReviews(widget.drugItemSeq),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Review> reviews = snapshot.data;
                List<Review> searchResults = [];
                for (Review review in reviews) {
                  if (review.effectText.contains(widget.searchText) ||
                      review.sideEffectText.contains(widget.searchText)) {
                    searchResults.add(review);
                  }
                }
                return ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, searchResults[index]);
                  },
                );
              } else
                return Loading();
            },
          );
  }

  Widget _buildListItem(BuildContext context, Review review) {
    FirebaseAuth auth = FirebaseAuth.instance;
    List<String> names = List.from(review.favoriteSelected);

    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 21.5),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.6, color: gray75))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _starAndIdAndMore(review, context, auth),
          _review(review),
          Container(height: 11.5),
          _dateAndFavorite(
              DateFormat('yyyy.MM.dd').format(review.registrationDate.toDate()),
              names,
              auth,
              review)
        ]));
  }

  Widget _starAndIdAndMore(review, context, auth) {
    TheUser user = Provider.of<TheUser>(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
      child: Row(
        children: <Widget>[
          RatingBar.builder(
            initialRating: review.starRating * 1.0,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 16,
            glow: false,
            itemPadding: EdgeInsets.symmetric(horizontal: 0.2),
            unratedColor: gray75,
            itemBuilder: (context, _) =>
                ImageIcon(
              AssetImage('assets/icons/star.png'),
              color: yellow,
            ),
          ),
          SizedBox(width: 10),
          Text(review.nickName,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: gray500, fontSize: 12)),
          Expanded(child: Container()),
          IconButton(
            padding: EdgeInsets.only(right: 0),
            icon: Icon(Icons.more_horiz, color: gray500, size: 19),
            onPressed: () {
              if (user.uid == review.uid) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return _popUpMenu(review);
                    });
              } else if (auth.currentUser.uid != review.uid) {
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return _popUpMenuAnonymous(review, user);
                    });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _popUpMenu(review) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditReview(review, "edit")));
                  },
                  child: Center(
                      child: Text(
                    "수정하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            Padding(
              // padding: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _IYMYCancleConfirmDeleteDialog(
                      review,
                    );
                  },
                  child: Center(
                      child: Text(
                    "삭제하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            // Divider(thickness: 1, color: gray100),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(color: Theme.of(context).hintColor),
                      top: BorderSide(color: gray100)),
                ),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "닫기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray300_inactivated),
                    ))),
              ),
            )
          ],
        ));
  }

  Widget _reportReviewPopup(
    review,
  ) {
    var mqWidth = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )),
        child: Wrap(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text("리뷰 신고하기",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: primary500_light_text, fontSize: 14)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              // padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.6 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        1, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "광고, 홍보 / 거래 시도",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        2, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "욕설, 음란어 사용",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        3, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "약과 무관한 리뷰 작성",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        4, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "개인 정보 노출",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
              child: Container(
                // height: (mqWidth*0.6)/4.6,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                child: MaterialButton(
                    onPressed: () {
                      _IYMYCancleConfirmReportDialog(
                        review,
                        5, /*user*/
                      );
                    },
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                          "기타 (명예훼손)",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray900),
                        )),
                      ],
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                // height: (mqWidth*0.6)/4.5,
                height: mqWidth <= 320 ? (mqWidth * 0.6) / 4.7 : null,
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(color: Theme.of(context).hintColor),
                      top: BorderSide(color: gray100)),
                ),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "닫기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray300_inactivated),
                    ))),
              ),
            )
          ],
        ));
  }

  Future<void> _IYMYCancleConfirmDeleteDialog(record) async {
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
              SizedBox(height: 16),
              /* BODY */
              Text("선택한 리뷰를 삭제하시겠어요?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* LEFT ACTION BUTTON */
                  ElevatedButton(
                    child: Text(
                      "취소",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  /* RIGHT ACTION BUTTON */
                  ElevatedButton(
                      child: Text(
                        "확인",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        await ReviewService(documentId: record.documentId)
                            .deleteReviewData();
                        Navigator.of(context).pop();
                        if (widget.type == "mine") Navigator.of(context).pop();

                        //OK Dialog
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.zero,
                              contentPadding: EdgeInsets.all(16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Icon(Icons.check, color: primary300_main),
                                  SizedBox(height: 16),
                                  /* BODY */
                                  Text(
                                    "리뷰가 삭제되었습니다",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: gray700),
                                  ),
                                  SizedBox(height: 16),
                                  /* BUTTON */
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          elevation: 0,
                                          primary: gray50,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              side: BorderSide(color: gray75))),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })
                                ],
                              ),
                            );
                          },
                        );
                      })
                ],
              )
            ],
          ),
        );
      },
    );

  }

  Future<void> _IYMYCancleConfirmReportDialog(
    review,
    report,
    /*user*/
  ) async {
    User user = FirebaseAuth.instance.currentUser;

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
              SizedBox(height: 16),
              /* BODY */
              Text("신고하시겠어요?",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* LEFT ACTION BUTTON */
                  ElevatedButton(
                    child: Text(
                      "취소",
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  /* RIGHT ACTION BUTTON */
                  ElevatedButton(
                      child: Text(
                        "확인",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        await ReviewService(documentId: review.documentId)
                            .reportReview(review, report, user.uid);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        IYMYGotoSeeOrCheckDialog("안먹소 운영진에게\n신고가 접수되었어요");

                        // var reviewReported = await ReviewService(documentId: review.documentId).checkReviewIsReported();
                        //
                        // if(reviewReported == false) {
                        //   await ReviewService(documentId: review.documentId).reportReview(review, report, user.uid);
                        //   Navigator.of(context).pop();
                        //   IYMYGotoSeeOrCheckDialog("이약모약 운영진에게\n신고가 접수되었어요");
                        // }
                        //
                        // else if(reviewReported == true) {
                        //   await ReviewService(documentId: review.documentId).reportAlreadyReportedReview(review, user.uid, report);
                        //   Navigator.of(context).pop();
                        //   IYMYGotoSeeOrCheckDialog("이미 해당 리뷰를 신고하셨습니다");
                        // }
                      })
                ],
              )
            ],
          ),
        );
      },
    );

  }

  Widget IYMYGotoSeeOrCheckDialog(alertContent) {
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
              Icon(Icons.check, color: primary300_main),
              SizedBox(height: 13),
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    TextSpan(text: alertContent),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '주말, 공휴일에는 확인이 지연될 수 있습니다',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: gray300_inactivated),
                    ),
                  ],
                ),
              ),
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

  Widget _reviewBox(review, type) {
    return Container(
        padding: EdgeInsets.all(9.5),
        decoration: BoxDecoration(
            color: gray50,
            border: Border.all(color: gray50),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type == "effect"
                      ? "효과"
                      : type == "sideEffect"
                          ? "부작용"
                          : "총평",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(color: gray900, fontSize: 12),
                ),
                Container(width: 3),
                _face(
                  type == "effect"
                      ? review.effect
                      : type == "sideEffect"
                          ? review.sideEffect
                          : "",
                ),
              ],
            ),
            Container(height: 4),
            Text(
              type == "effect"
                  ? review.effectText
                  : type == "sideEffect",
                      // ? review.sideEffectText
                      // : "",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: gray600, fontSize: 14),
            ),
          ],
        ));
  }

  Widget _face(face) {
    if (face == "good" || face == "no")
      return Icon(
        Icons.sentiment_satisfied_rounded,
        color: primary300_main,
        size: 16,
      );
    if (face == "soso")
      return Icon(
        Icons.sentiment_neutral_rounded,
        color: yellow_line,
        size: 16,
      );
    if (face == "bad" || face == "yes")
      return Icon(
        Icons.sentiment_very_dissatisfied_rounded,
        color: warning,
        size: 16,
      );
  }

  Widget _review(review) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 6),

          //effect
          widget.filter == "sideEffectOnly"
              ? Container()
              // : _reviewBox(review, "effect"),
              : ReviewBox(context: context, review: review, type: "effect"),
          Container(height: 6),

          //side effect
          widget.filter == "effectOnly"
              ? Container()
              // : _reviewBox(review, "sideEffect"),
              : ReviewBox(context: context, review: review, type: "sideEffect"),
          Container(height: 6),

/*          //overall
          widget.filter == "sideEffectOnly" || widget.filter == "effectOnly"
              ? Container()
              // : _reviewBox(review, "overall"),
              : review.overallText == ""
                  ? Container()
                  : ReviewBox(
                      context: context, review: review, type: ""),
          review.overallText == "" ? Container() : Container(height: 6),*/
        ],
      ),
    );
  }

  Widget _dateAndFavorite(regDate, names, auth, review) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 5, 0),
      child: Row(
        children: <Widget>[
          Text(regDate,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: gray500, fontSize: 12)),
//        Padding(padding: EdgeInsets.all(18)),
          Expanded(child: Container()),
          Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new GestureDetector(
                    child: new Icon(
                      names.contains(auth.currentUser.uid)
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt,
                      color: names.contains(auth.currentUser.uid)
                          ? primary400_line
                          : Color(0xffDADADA),
                      size: 20,
                    ),
                    onTap: () async {
                      if (names.contains(auth.currentUser.uid)) {
                        await ReviewService(documentId: review.documentId)
                            .decreaseFavorite(
                                review.documentId, auth.currentUser.uid);
                      } else {
                        await ReviewService(documentId: review.documentId)
                            .increaseFavorite(
                                review.documentId, auth.currentUser.uid);
                      }
                    })
              ],
            ),
          ),
          Container(width: 3),
          Text((review.noFavorite).toString(),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(color: gray400, fontSize: 12)),
          SizedBox(width: 15)
        ],
      ),
    );
  }

  Widget _popUpMenuAnonymous(review, user) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(12.0),
              topRight: const Radius.circular(12.0),
            )),
        child: Wrap(
          children: <Widget>[
            Padding(
              // padding: const EdgeInsets.only(top: 4.0),
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return _reportReviewPopup(review /*, user*/);
                        });
                  },
                  child: Center(
                      child: Text(
                    "신고하기",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: gray900),
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                      // bottom: BorderSide(color: Theme.of(context).hintColor),
                      top: BorderSide(color: gray100)),
                ),
                child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Center(
                        child: Text(
                      "취소",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray300_inactivated),
                    ))),
              ),
            )
          ],
        ));
  }
}
