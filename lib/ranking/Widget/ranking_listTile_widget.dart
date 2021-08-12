import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:an_muk_so/models/food.dart';

import 'package:flutter/material.dart';
import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/theme/colors.dart';

class RankingTile extends StatelessWidget {
  final Food food;
  final int index;
  final String filter;
  final String category;

  RankingTile({this.food, this.index, this.filter, this.category});

  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;

    //디자이너님이 그냥 숫자로만
    Widget _upToThree(index) {
      return Center(
        child: Text(index.toString(),
            style: Theme.of(context)
                .textTheme
                .overline
                .copyWith(fontSize: 10, color: gray750_activated)),
      );
    }

    return ListTile(
      minVerticalPadding: 0.5,
      contentPadding: EdgeInsets.zero,
      //누르면 상품 정보 페이지로 넘어가기
      onTap: () => {
        Navigator.pop(context),
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ReviewPage(food.itemSeq, filter: filter, type: category),
          ),
        ),
      },
      title: StreamBuilder<Food>(
        //TODO:Datebase 부분 설계
          stream: DatabaseService(itemSeq: food.itemSeq).foodData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Food foodStreamData = snapshot.data;
              String foodRating = foodStreamData.totalRating.toStringAsFixed(2);
              return Container(
                decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(width: 0.6, color: gray50))),
                height: 100.0,
                child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Container(
                            margin: EdgeInsets.only(left: 16, right: 5),
                            child: _upToThree(index),
                          ),
                        ),
                        Container(
                          width: 88,
                          padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Container(
                              padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                              child: SizedBox(
                                //TODO: image storage에 넣어둬야함
                                    child: FoodImage(
                                        foodItemSeq: foodStreamData.itemSeq)
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.0),
                                  child: Text(foodStreamData.entpName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .overline
                                          .copyWith(
                                              fontSize: 10,
                                              color: gray300_inactivated)),
                                ),
                                Container(
                                  width: mw - 160,
                                  child: Text(
                                      foodStreamData.itemName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: gray900)),
                                ),
                                Row(
                                  children: [
                                    _getRateStar(foodStreamData.totalRating),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(foodRating,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2
                                            .copyWith(color: gray900)),
                                    Text(' (${foodStreamData.numOfReviews}개)',
                                        style: Theme.of(context)
                                            .textTheme
                                            .overline
                                            .copyWith(
                                                fontSize: 10,
                                                color: gray300_inactivated)),
                                  ],
                                ),
                                Expanded(
                                    child: Row(
                                  children: [
                                    //TODO:shared 부분에 추가해야함
                                    CategoryButton(
                                        str: foodStreamData.rankCategory,
                                        //forRanking: 'ranking'
                                    )
                                  ],
                                )),
                              ],
                            )),
                      ],
                    )),
              );
            } else
              return Container(); //LinearProgressIndicator();
          }),
    );
  }

  Widget _getRateStar(RatingResult) {
    return RatingBarIndicator(
      rating: RatingResult * 1.0,
      direction: Axis.horizontal,
      itemCount: 5,
      itemSize: 14,
      itemPadding: EdgeInsets.symmetric(horizontal: 0),
      unratedColor: gray75,
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: yellow,
      ),
    );
  }
}
