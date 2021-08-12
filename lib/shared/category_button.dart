import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

class CategoryButton extends StatelessWidget {
  final String str;
  String fromHome = '';
  String forRanking = '';
  final bool forsearch;
  final bool fromFoodInfo;

  //const
  CategoryButton(
      {this.str,
      this.fromHome,
      this.forsearch,
      this.forRanking,
      this.fromFoodInfo}); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;

    if (forsearch == true) {
      return ElevatedButton(
        child:
        //Text('${_shortenCategory(str)}',
        Text('${(str)}',
        style:
                Theme.of(context).textTheme.caption.copyWith(color: gray500)),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(12, 23),
            padding: EdgeInsets.symmetric(horizontal: 10),
            elevation: 0,
            primary: gray50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: gray75))),
        onPressed: () {},
      );
    }

    return ElevatedButton(
      child:
      //Text('${_shortenCategory(str)}',
      Text('${(str)}',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: gray900)),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(110, 23),
          padding: EdgeInsets.symmetric(horizontal: 10),
          elevation: 0,
          primary: Color(0xFF1EE9E9),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.0),
              side: BorderSide(color: gray75))),
      onPressed: () {},
    );
  }
}

class InFoCategoryButton extends StatelessWidget {
  final String str;
  String fromHome = '';
  String forRanking = '';
  final bool forsearch;
  final bool fromFoodInfo;

  //const
  InFoCategoryButton(
      {this.str,
        this.fromHome,
        this.forsearch,
        this.forRanking,
        this.fromFoodInfo}); // : super(key: key);

  @override
  Widget build(BuildContext context) {
    double mw = MediaQuery.of(context).size.width;

    if (forsearch == true) {
      return ElevatedButton(
        child:
        //Text('${_shortenCategory(str)}',
        Text('${(str)}',
            style:
            Theme.of(context).textTheme.caption.copyWith(color: primary700)),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(12, 23),
            padding: EdgeInsets.symmetric(horizontal: 10),
            elevation: 0,
            primary: gray50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
                side: BorderSide(color: gray75))),
        onPressed: () {},
      );
    }

    return ElevatedButton(
      child:
      //Text('${_shortenCategory(str)}',
      Text('${(str)}',
          style: Theme.of(context)
              .textTheme
              .subtitle2
              .copyWith(color: primary700)),
      style: ElevatedButton.styleFrom(
          minimumSize: Size(12, 23),
          padding: EdgeInsets.symmetric(horizontal: 10),
          elevation: 0,
          primary: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1.0),
              side: BorderSide(color: gray75))),
      onPressed: () {},
    );
  }
}
