import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

import 'Page/ranking_content_page.dart';

String getCategory; //카테고리 받아오기 위함

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: CustomAppBarWithArrowBackAndSearch('전체상품', 0.5), //test
        backgroundColor: Colors.white,
        body: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    border:
                    Border(bottom: BorderSide(width: 0.6, color: gray50))),
                child: ListTile(
                  dense: true,
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                  title: SizedBox(
                      height: 20,
                      child: Text(
                        //원래
                        //categories[index],

                        rank_cateogry[index], //test
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray900),
                      )),
                   onTap: () {
                    getCategory = rank_cateogry[index]; //test
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          RankingContentPage(
                            categoryName: rank_cateogry[index],
                            filter: '리뷰 많은 순',
                          )),
                    );
                   },
                ),
              );
            },
            separatorBuilder: (context, index) {
              //return Divider(color: gray50, thickness: 0.5,);
              return Container();
            },
            itemCount: rank_cateogry.length));
  }
}

//TEST RANK CATEGORY 확인 코드 시작
final rank_cateogry = [
  '전체',
  '과자류',
  '면류',
  '육가공품',
  '빙과류',
  '즉석식품',
  '음료수',
  '냉장식품',
  '냉동식품',
  '제빵류',
  '소스,장류',
  '건강식품',
];


//TEST RANK CATEGORY 확인 코드 끝


