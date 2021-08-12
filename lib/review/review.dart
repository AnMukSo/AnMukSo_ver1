import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Review extends ChangeNotifier{


  String effect = '';
  String sideEffect = '';
  num starRating = 0;

  String getEffect() => effect;
  String getSideEffect() => sideEffect;
  num getStarRating() => starRating;

  void effectToBad() {
    effect = "bad";
    notifyListeners();
  }

  void effectToSoSo() {
    effect = "soso";
    notifyListeners();
  }

  void effectToGood() {
    effect = "good";
    notifyListeners();
  }

  void sideEffectToYes() {
    sideEffect = "yes";
    notifyListeners();
  }

  void sideEffectToNo() {
    sideEffect = "no";
    notifyListeners();
  }



}


