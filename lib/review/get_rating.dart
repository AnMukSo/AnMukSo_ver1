import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/services/review.dart';
import 'package:an_muk_so/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'write_review.dart';

class GetRating extends StatefulWidget {
  String foodItemSeq;
  GetRating(this.foodItemSeq);

  @override
  _GetRatingState createState() => _GetRatingState();
}

class _GetRatingState extends State<GetRating> {

  @override
  Widget build(BuildContext context) {
    var mqWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<Food> (
      stream: DatabaseService(itemSeq: widget.foodItemSeq).foodData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return StreamBuilder<List<Review>>(
              stream: ReviewService().getReviews(widget.foodItemSeq),
              builder: (context, snapshot) {
                List<Review> reviews = snapshot.data;
                int length = 0 ;
                num sum = 0;
                double ratingResult = 0;
                double effectGood = 0;
                double effectSoso = 0;
                double effectBad = 0;
                double sideEffectYes = 0;
                double sideEffectNo = 0;

                if(snapshot.hasData) {
                  length = reviews.length;

                  reviews.forEach((review) {
                    sum += review.starRating;
                    review.effect == "good" ? effectGood++ :
                    review.effect == "soso" ? effectSoso++ : effectBad++;
                    review.sideEffect == "yes" ? sideEffectYes++ : sideEffectNo++;
                  });

                  ratingResult = (sum / length);
                  if (ratingResult.isNaN) ratingResult = 0;
                  
                  double good = (effectGood / (effectGood + effectSoso + effectBad))*100;
                  double soso = (effectSoso / (effectGood + effectSoso + effectBad))*100;
                  double bad = (effectBad / (effectGood + effectSoso + effectBad))*100;
                  double yes = (sideEffectYes / (sideEffectYes + sideEffectNo))*100;
                  double no = (sideEffectNo / (sideEffectYes + sideEffectNo))*100;

                  if (good.isNaN) good = 0;
                  if (soso.isNaN) soso = 0;
                  if (bad.isNaN) bad = 0;
                  if (yes.isNaN) yes = 0;
                  if (no.isNaN) no = 0;

                  DatabaseService(itemSeq: widget.foodItemSeq).updateTotalRating(ratingResult, length);

                  return Container(
                      padding: EdgeInsets.fromLTRB(16,20,16,20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("총 평점",
                              style: Theme.of(context).textTheme.subtitle1.copyWith(
                                  color: gray750_activated,
                                  fontSize: 14
                              )),
                          Container(height: 5,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: mqWidth <=320 ? mqWidth/2.4:
                                mqWidth/2-16,
                                child: Row(children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/An_Icon/An_Star_On.png',
                                        width: 28, height: 28,),
                                      Container(width: 5),
                                      Text("",
                                          style: Theme.of(context).textTheme.headline1.copyWith(
                                              color: gray750_activated,
                                              fontSize: 24
                                          )),
                                    ],
                                  ),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(ratingResult.toStringAsFixed(2),
                                          style: Theme.of(context).textTheme.headline1.copyWith(
                                              color: gray750_activated,
                                              fontSize: 24
                                          )),
                                      Column(
                                        children: [
                                          Text(" /5",
                                              style: Theme.of(context).textTheme.headline4.copyWith(
                                                  color: gray300_inactivated,
                                                  fontSize: 16
                                              )),
                                          Container(height:4)
                                        ],
                                      ),
                                    ],) ,
                                ],),
                              ),


                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(good == 0 && soso == 0 && bad == 0 ? "" : "상품평가  ",
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            color: gray600,
                                          )),
                                      Container(height: 6),
                                      Text(good == 0 && soso == 0 && bad == 0 ? "" : "알러지 반응",
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            color: gray600,
                                          )),
                                    ],
                                  ),
                                  Container(width:8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //effect
                                      effectBad > effectSoso && effectBad > effectGood ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                            color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: good == 0 && soso == 0 && bad == 0 ? "" : "별로에요  ",
                                              style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                color: gray600,)),
                                            TextSpan(
                                              text:good == 0 && soso == 0 && bad == 0 ? "" :
                                              bad.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      effectSoso > effectGood && effectSoso > effectBad ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "보통이에요  ",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                soso.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "좋아요  ",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                good.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      ),
                                      Container(height: 6),

                                      //side effect
                                      sideEffectYes > sideEffectNo ?
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "있어요  ",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                yes.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                          :
                                      RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                                              color: gray300_inactivated),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: good == 0 && soso == 0 && bad == 0 ? "" : "없어요  ",
                                                style: Theme.of(context).textTheme.subtitle2.copyWith(
                                                  color: gray600,)),
                                            TextSpan(
                                                text:good == 0 && soso == 0 && bad == 0 ? "" :
                                                no.toStringAsFixed(0) + "%"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ));
                }
                else {
                  return Container();
                }
              }
          );
        }
        else return Container();
      }
    );



  }

}
