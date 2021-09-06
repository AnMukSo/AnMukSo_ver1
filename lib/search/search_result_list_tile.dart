import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/search/search.dart';
import 'package:an_muk_so/models/food.dart';

import 'package:flutter/material.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/theme/colors.dart';

class SearchResultTile extends StatelessWidget {
  final Food food;
  final int index;
  final int totNum;

  SearchResultTile({this.food, this.index, this.totNum});


  //이름 길었을 때 필요한 부분만 짤라서 보여주려고 하는 거였는데 모든 조건들이 적용 되지는 않음
  String _checkLongName(String data) {
    String newItemName = data;
    List splitName = [];
    if (data.contains('(')) {
      newItemName = data.replaceAll('(', '(');
      if (newItemName.contains('')) {
        splitName = newItemName.split('(');
        // print(splitName);
        newItemName = splitName[0];
      }
    }

    if (newItemName.length > 22) {
      newItemName = newItemName.substring(0, 20);
      newItemName = newItemName + '...';
    }

    return newItemName;
  }

  //(2) 하이라이팅을 위한
  Widget _highlightText(BuildContext context, String text) {
    return RichText(textScaleFactor: 1.08, text: searchMatch(text),
      overflow: TextOverflow.ellipsis,
    );
  }
  //(2) 여기까지

  @override
  Widget build(BuildContext context) {
    int forCheckLast = 0;
    if(index != null){
      forCheckLast = index + 1;
    }

    double mw = MediaQuery.of(context).size.width;

    String searchList;
    TheUser user = Provider.of<TheUser>(context);

    CollectionReference userSearchList = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('searchList');

    Future<void> addRecentSearchList() async {
      try {
        assert(_checkLongName(food.itemName) != null);

        searchList = _checkLongName(food.itemName);
        assert(searchList != null);
        //drug 이름 누르면 저장 기능
        userSearchList.add({
          'searchList': searchList,
          'time': DateTime.now(),
          'itemSeq': food.itemSeq
        });
      } catch (e) {
        print('Error: $e');
      }
    }

    QuerySnapshot _query;
    return GestureDetector(
      onTap: () async => {
        _query = await userSearchList
            .where('searchList', isEqualTo: _checkLongName(food.itemName))
            .get(),
        if (_query.docs.length == 0)
          {
            addRecentSearchList(),
          },
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(food.itemSeq),
            )),
      },
      child: StreamBuilder<Food>(
          stream: DatabaseService(itemSeq: food.itemSeq).foodData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Food foodStreamData = snapshot.data;
              String newName = foodStreamData.rankCategory;
              //카테고리 길이 체크
              if (newName.length > 30) {
                newName = newName.substring(0, 27);
                newName = newName + '...';
              }
              return forCheckLast == totNum ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border(bottom: BorderSide(width: 0.6, color: gray50))),
                    height: 70.0,
                    child: Material(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(16, 5, 15, 5),
                              width: 90,
                              child: Container(
                                  padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                                  child: SizedBox(
                                      child: FoodImage(
                                          foodItemSeq: foodStreamData.itemSeq))
                              ),
                            ),
                            Container(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child:
                                        _highlightText(
                                            context,
                                            _checkLongName(
                                                foodStreamData.itemName))),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: SizedBox(
                                      height: 25,
                                      child: CategoryButton(
                                        str: newName,
                                        forsearch: true,
                                      )),
                                ),
                              ],
                            )),
                          ],
                        )),
                  ),
                  Container(height: 40)
                ],
              )
              : Container(
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(width: 0.6, color: gray50))),
                height: 70.0,
                child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(16, 5, 15, 5),
                          width: 90,
                          child: Container(
                              padding: EdgeInsets.zero, //fromLTRB(5, 0, 5, 5),
                              child: SizedBox(
                                  child: FoodImage(
                                      foodItemSeq: foodStreamData.itemSeq))
                          ),
                        ),
                        Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw > 390 ? mw - 120 : mw - 150,
                                    child:
                                    _highlightText(
                                        context,
                                        _checkLongName(
                                            foodStreamData.itemName))),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3.0),
                                  child: SizedBox(
                                      height: 25,
                                      child: CategoryButton(
                                        str: newName,
                                        forsearch: true,
                                      )),
                                ),
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
}
