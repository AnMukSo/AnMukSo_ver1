import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/theme/colors.dart';

class ReviewPillInfo extends StatefulWidget {
  String seqNum;
  ReviewPillInfo(this.seqNum);

  @override
  _ReviewPillInfoState createState() => _ReviewPillInfoState();
}

String _shortenName(String drugName) {
  String newName;
  List splitName = [];

  if (drugName.contains('(')) {
    splitName = drugName.split('(');
    newName = splitName[0];
    return newName;
  } else
    return drugName;
}

class _ReviewPillInfoState extends State<ReviewPillInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 30, 20, 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
          width: 12,
          color: gray50,
        ))),
        child: Row(
          children: <Widget>[
            SizedBox(
              child: FoodImage(foodItemSeq: widget.seqNum),
              width: 88.0,
            ),
            Padding(padding: EdgeInsets.only(left: 15)),

            // Text(widget.review.effectText),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<Food>(
                    stream:
                        DatabaseService(itemSeq: widget.seqNum).foodData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Food food = snapshot.data;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(food.entpName,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline
                                    .copyWith(
                                        color: gray300_inactivated,
                                        fontSize: 10)),
                            Container(
                              width: MediaQuery.of(context).size.width - 155,
                              padding: new EdgeInsets.only(right: 10.0),
                              child: Text(_shortenName(food.itemName),
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(color: gray900)),
                            ),
                            Container(
                              height: 2,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                RatingBarIndicator(
                                  rating: food.totalRating * 1.0,
                                  itemBuilder: (context, index) => ImageIcon(
                                    AssetImage('assets/icons/star.png'),
                                    color: yellow,
                                  ),
                                  itemCount: 5,
                                  itemSize: 16.0,
                                  unratedColor: gray75,
                                  //unratedColor: Colors.amber.withAlpha(50),
                                  direction: Axis.horizontal,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                ),
                                Container(width: 5),
                                Text(
                                  food.totalRating.toStringAsFixed(2),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      .copyWith(color: gray900, fontSize: 12),
                                ),
                                Container(width: 3),
                                Text(
                                    "(" +
                                        food.numOfReviews.toStringAsFixed(0) +
                                        "개)",
                                    style: Theme.of(context)
                                        .textTheme
                                        .overline
                                        .copyWith(
                                            color: gray300_inactivated,
                                            fontSize: 10)),
                              ],
                            ),
                            CategoryButton(str: food.rankCategory)
                          ],
                        );
                      } else
                        return Container();
                    }),
              ],
            )
          ],
        ));
  }
}
