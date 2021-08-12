//ㅇㅋ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/ranking/Load/ranking_firebase_api.dart';
import 'package:an_muk_so/models/food.dart';


class FoodsTotalRankingProvider extends ChangeNotifier {
  final _foodsSnapshot = <DocumentSnapshot>[];
  final filterOrSort;
  String _errorMessage = '';
  int documentLimit = 15; //리미트 걸어둔
  bool _hasNext = true; //그 다음 상품이 존재하는지
  bool _isFetchingFoods = false;

  FoodsTotalRankingProvider(this.filterOrSort); //fetch 한 애들인지

  String get errorMessage => _errorMessage;

  bool get hasNext => _hasNext;

  List<Food> get foods => _foodsSnapshot.map((snap) {
    final food = snap.data();

    return Food(
      entpName: food['ENTP_NAME'],
      itemName: food['ITEM_NAME'],
      itemSeq: food['ITEM_SEQ'],
      totalRating: food['totalRating'],
      numOfReviews: food['numOfReviews'],

    );
  }).toList();

  Future fetchNextFoods( ) async { //fetch 해오기 위함
    if (_isFetchingFoods) return; //fetch한 user라면 그냥 아무것도 없는 거를 return한다.

    _errorMessage = '';
    _isFetchingFoods = true;

    try { //여기서 user들을 불러온다
      final snap = await FirebaseApi.getFoods(documentLimit, filterOrSort,
        startAfter: _foodsSnapshot.isNotEmpty ? _foodsSnapshot.last : null,

      );
      _foodsSnapshot.addAll(snap.docs);

      //limit보다 적다면 notify리스너를 통해서 가져온다
      if (snap.docs.length < documentLimit) _hasNext = false;
      notifyListeners();
    } catch (error) {
      _errorMessage = error.toString();
      notifyListeners();
    }

    _isFetchingFoods = false;
  }
}
