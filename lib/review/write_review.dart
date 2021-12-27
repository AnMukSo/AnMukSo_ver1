import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/review/see_my_review.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/review/review_pill_info.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';
import 'review.dart';

class WriteReview extends StatefulWidget {
  String foodItemSeq;
  WriteReview({this.foodItemSeq});

  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  FirebaseAuth auth = FirebaseAuth.instance;

  final myControllerEffect = TextEditingController();
  final myControllerSideEffect = TextEditingController();

  @override
  void dispose() {
    myControllerEffect.dispose();
    myControllerSideEffect.dispose();
    super.dispose();
  }

  final firestoreInstance = Firestore.instance;

  String id = '';
  String effect = '';
  String sideEffect = '';
  String effectText = '';
  double starRating = 0;
  String sideEffectText = '';
  List<String> favoriteSelected = [];
  var noFavorite = 0;
  DateTime regDate = DateTime.now();
  String _entpName = ''; //약 제조사
  String _itemName = ''; //약 이름

  String starRatingText = '';

  void setItemNames(itemName, entpName) {
    _itemName = itemName;
    _entpName = entpName;
  }

  void _registerReview(nickName) {
    FirebaseFirestore.instance.collection("Reviews").add({
      "seqNum": widget.foodItemSeq,
      "uid": auth.currentUser.uid,
      "effect": effect,
      "sideEffect": sideEffect,
      "starRating": starRating,
      "effectText": effectText,
      "sideEffectText": sideEffectText,
      "favoriteSelected": favoriteSelected,
      "noFavorite": noFavorite,
      "registrationDate": DateTime.now(),
      "entpName": _entpName,
      "itemName": _itemName,
      "nickName": nickName,
    });
  }

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);
    return Scaffold(
        backgroundColor: gray0_white,
        // appBar: CustomAppBarWithGoToBack('리뷰 쓰기', Icon(Icons.close), 3),
        appBar: AppBar(
          title: Text(
            "리뷰 쓰기",
            style:
                Theme.of(context).textTheme.headline5.copyWith(color: gray800),
          ),
          elevation: 0.5,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.close),
            color: primary300_main,
            onPressed: () {
              _CancleConfirmReportDialog();
              // Navigator.pop(context);
            },
          ),
        ),
        body: ChangeNotifierProvider(
            create: (context) => Review(),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: ListView(
                children: <Widget>[
                  ReviewPillInfo(widget.foodItemSeq),
                  _rating(),
                  _effect(),
                  _sideEffect(),
                  _write(),
                ],
              ),
            )));
  }


  Widget _rating() {
    return Container(
//          height: 150,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("상품을 먹어 보셨나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            SizedBox(height: 10),
            RatingBar.builder(
              itemSize: 48,
              glow: false,
              initialRating: starRating != null ? starRating : 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
//              unratedColor: Colors.grey[500],
              unratedColor: gray75,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) =>
                  // Icon(Icons.star, color: primary300_main),
                  Image.asset(
                'assets/an_icon_resize/An_Star_On.png',
                width: 28,
                height: 28,
              ),

              onRatingUpdate: (rating) {
                starRating = rating;
                setState(() {
                  //if(starRating == 0)
                  //  starRatingText = "선택하세요.";
                  if (starRating == 1) starRatingText = "1점 (별로에요)";
                  if (starRating == 2) starRatingText = "2점 (그저그래요)";
                  if (starRating == 3) starRatingText = "3점 (괜찮아요)";
                  if (starRating == 4) starRatingText = "4점 (좋아요)";
                  if (starRating == 5) starRatingText = "5점 (최고예요)";
                });
              },
            ),
            SizedBox(height: 10),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.caption.copyWith(
                      color: gray300_inactivated,
                      fontSize: 12,
                    ),
                children: <TextSpan>[
                  TextSpan(
                    text: starRatingText.isEmpty
                        ? "평가해주세요"
                        : '${starRatingText.split(" ")[0]}',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        color: gray300_inactivated,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: starRatingText.isEmpty
                        ? ""
                        : ' ' + '${starRatingText.split(" ")[1]}',
                  ),
                ],
              ),
            ),
          ],
        ));
  }



  Widget _effect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.8,
          color: gray75,
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("상품의 맛은 어땠나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            width: 40,
                            height: 40,
                            // child: Image.asset('assets/icons/sentiment_satisfied.png.png'),
                            child: Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            decoration: BoxDecoration(
                                color:
                                    effect == "bad" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            effect = "bad";
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "별로에요",
                      style: effect == "bad"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary300_main, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
                Container(width: 30),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(
                              Icons.sentiment_neutral_rounded,
                              color: Color(0xffF7F7F7),
                              size: 30,
                            ),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:
                                    effect == "soso" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          effect = "soso";
                          setState(() {
                            effect = "soso";
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "보통이에요",
                      style: effect == "soso"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary300_main, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
                Container(width: 30),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(Icons.sentiment_satisfied_rounded,
                                color: Color(0xffF7F7F7), size: 30),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color:
                                    effect == "good" ? primary300_main : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            effect = "good";
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "좋아요",
                      style: effect == "good"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary300_main, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
            _textField("effect", myControllerEffect)
          ],
        ));
  }

  Widget _textFieldForSideEffect(TextEditingController myControllerEffect) {
    if (sideEffect == "no") {
      // myControllerSideEffect.text = " ";
      return Container();
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Container(
            width: 400,
//                height: 100,
            child: TextField(
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray750_activated,
                    ),
                maxLength: 500,
                controller: myControllerEffect,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  hintText: "알러지 반응에 대한 후기를 남겨주세요 (최소 10자 이상)\n",
                  hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                        color: gray300_inactivated,
                      ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: gray75),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(4.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary300_main),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(4.0)),
                  ),
                  filled: true,
                  fillColor: gray50,
                ))),
      );
    }
  }

  Widget _textField(String type, txtController) {
    String hintText;
    if (type == "effect")
      hintText = "맛에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    else if (type == "sideEffect")
      hintText = "알러지 반응에 대한 후기를 남겨주세요 (최소 10자 이상)\n";
    double bottom = 20;
    // if (type == "overall") bottom += 70;
    return Padding(
      // padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      padding: EdgeInsets.fromLTRB(0, 20, 0, bottom),
      child: Container(
          child: TextField(
              maxLength: 500,
              controller: txtController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: new InputDecoration(
                hintText: hintText,
                hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray300_inactivated,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: gray75),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(4.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primary300_main),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(4.0)),
                ),
                filled: true,
                fillColor: gray50,
              ))),
    );
  }

  Widget _sideEffect() {
    return Container(
//          height: 280,
        padding: EdgeInsets.fromLTRB(20, 25, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 0.6,
          color: Colors.grey[300],
        ))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
//              crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("알러지 반응은 없었나요?",
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray900, fontSize: 16)),
            Padding(padding: EdgeInsets.only(top: 15)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(
                              Icons.sentiment_dissatisfied_rounded,
                              size: 30,
                              color: Color(0xffF7F7F7),
                            ),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
//                              color: widget.review.sideEffect == "yes" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "yes"
                                    ? primary300_main
                                    : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            sideEffect = "yes";
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "알러지 반응 있어요",
                      style: sideEffect == "yes"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary300_main, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                    // Text("있어요", style: sideEffect == "yes"?
                    // TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    // TextStyle(color:Colors.black87)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                  child: Text("VS",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: gray500, fontSize: 14)),
                ),
                Column(
                  children: <Widget>[
                    GestureDetector(
                        child: Container(
                            child: Icon(Icons.sentiment_satisfied_rounded,
                                color: Color(0xffF7F7F7), size: 30),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
//                                                    color: widget.review.sideEffect == "no" ? Colors.greenAccent[100]: Colors.grey[300],
                                color: sideEffect == "no"
                                    ? primary300_main
                                    : gray75,
                                shape: BoxShape.circle)),
                        onTap: () {
                          setState(() {
                            sideEffect = "no";
                          });
                        }),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Text(
                      "알러지 반응 없어요",
                      style: sideEffect == "no"
                          ? Theme.of(context).textTheme.caption.copyWith(
                              color: primary300_main, fontSize: 12)
                          : Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(color: gray0_white, fontSize: 12),
                    )
                    // Text("없어요", style: sideEffect == "no"?
                    // TextStyle(fontWeight: FontWeight.bold, color: Colors.black87) :
                    // TextStyle(color:Colors.black87)),
                  ],
                ),
              ],
            ),
            _textFieldForSideEffect(myControllerSideEffect)
          ],
        ));
  }


  Widget _write() {
    TheUser user = Provider.of<TheUser>(context);
    String _warning = '';
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: AMSSubmitButton(
          context: context,
          isDone: true,
          textString: '완료',
          onPressed: () async {
            sideEffectText = myControllerSideEffect.text;
            effectText=myControllerEffect.text;
            if (sideEffectText.length < 10 && sideEffect == "yes")
              _warning = "알러지 반응에 대한 리뷰를 10자 이상 작성해주세요";
            if (sideEffect.isEmpty) _warning = "알러지 반응 별점을 등록해주세요";
            if (effectText.length < 10) _warning = "맛에 대한 리뷰를 10자 이상 작성해주세요";
            if (effect.isEmpty) _warning = "맛 별점을 등록해주세요";
            if (starRatingText.isEmpty) _warning = "별점을 등록해주세요";

            if ((sideEffectText.length < 10 && sideEffect == "yes") ||
                effectText.length < 10 ||
                sideEffect.isEmpty ||
                effect.isEmpty ||
                starRatingText.isEmpty)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    _warning,
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            else {
              String nickName =
                  await DatabaseService(uid: user.uid).getNickName();
              _registerReview(nickName);

              Navigator.pop(context);
              GotoSeeOrCheckDialog();
            }
          },
        ),
      ),
    );
  }

  //##TODO:    - [ ] 작성한 리뷰 보러가기 - edit review
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
                    // TextSpan(
                    //     text: boldBodyString,
                    //     style: Theme.of(context).textTheme.headline4.copyWith(
                    //         color: gray700, fontWeight: FontWeight.w700)),
                    TextSpan(text: "리뷰 작성이 완료되었습니다"),
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
                      .copyWith(color: primary300_main),
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

  Future<void> _CancleConfirmReportDialog() async {
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
              Text("저장하지 않고 나가시겠어요?",
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
                        Navigator.pop(context);
                        Navigator.pop(context);
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
