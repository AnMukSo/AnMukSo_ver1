import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/review/edit_review.dart';
import 'package:an_muk_so/services/review.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/shared/loading.dart';
import 'package:an_muk_so/review/review_box.dart';
import 'package:an_muk_so/theme/colors.dart';
import 'package:intl/intl.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  // String _shortenName(String drugName) {
  //   String newName;
  //   List splitName = [];
  //
  //   if (drugName.contains('(')) {
  //     splitName = drugName.split('(');
  //     newName = splitName[0];
  //   }
  //
  //   return drugName;
  // }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
        appBar: CustomAppBarWithGoToBack('리뷰', Image(
            image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
        backgroundColor: gray0_white,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: StreamBuilder<List<Review>>(
                stream: ReviewService().getUserReviews(user.uid.toString()),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Review> reviews = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          child: Text("리뷰 " + reviews.length.toString() + "개"),
                        ),
                        Divider(
                          color: gray75,
                          height: 1,
                        ),
                        reviews.length == 0
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
                                    Text("아직 작성된 리뷰가 없어요")
                                  ],
                                ))
                            : // ReviewList(_searchText, "all", widget.drugItemSeq),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: reviews.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return _review(context, reviews[index]);
                                }),
                      ],
                    );
                  } else
                    return Loading();
                },
              ),
            )
          ],
        ));
  }

  Widget _review(BuildContext context, review) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewPage(review.seqNum),
          ),
        ),
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.6, color: gray75),
          ),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 60,
                      child: FoodImage(foodItemSeq: review.seqNum),
                    ),
                    Container(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.thumb_up,
                          color: gray300_inactivated,
                          size: 16,
                        ),
                        Container(
                          width: 5,
                        ),
                        //TODO: 좋아요 개수
                        Text(review.noFavorite.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                .copyWith(color: gray400, fontSize: 12))
                      ],
                    )
                  ],
                ),
                Container(
                  width: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 95,
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review.entpName,
                              style: Theme.of(context)
                                  .textTheme
                                  .overline
                                  .copyWith(
                                      color: gray300_inactivated,
                                      fontSize: 11)),
                          Container(
                            height: 1,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 143,
                            child: Text(review.itemName,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle2
                                    .copyWith(color: gray900, fontSize: 14)),
                          ),
                          Container(
                            height: 2,
                          ),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: review.starRating * 1.0,
                                itemBuilder: (context, index) => Icon(
                                  // _selectedIcon ??
                                  Icons.star,
                                  color: yellow,
                                ),
                                itemCount: 5,
                                itemSize: 18.0,
                                unratedColor: gray75,
                                //unratedColor: Colors.amber.withAlpha(50),
                                direction: Axis.horizontal,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 0),
                              ),
                              Container(
                                width: 4.5,
                              ),
                              Text(
                                  DateFormat('yy.MM.dd')
                                      .format(review.registrationDate.toDate()),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(
                                          color: gray300_inactivated,
                                          fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        padding: EdgeInsets.only(right: 0),
                        // constraints: BoxConstraints(),
                        icon: Icon(Icons.more_horiz, color: gray500, size: 19),
                        onPressed: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return _popUpMenu(review);
                              });
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(60, 0, 16, 0),
              child: Column(
                children: [
                  Container(height: 6),
                  ReviewBox(context: context, review: review, type: "effect"),
                  Container(height: 6),
                  ReviewBox(context: context, review: review, type: "sideEffect"),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget _popUpMenu(
    review,
  ) {
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
              padding: const EdgeInsets.only(top: 4.0),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            //TODO
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
              padding: const EdgeInsets.only(bottom: 4),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showDeleteDialog(review);
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

  Future<void> _showDeleteDialog(record) async {
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
}
