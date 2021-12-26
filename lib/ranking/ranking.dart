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
  '냉장/냉동/간편식',
  '라면/면류',
  '과자/시리얼',
  '빙과/아이스크림',
  '베이커리/잼',
  '즉석식품/통조림',
  '우유/유제품/유아식',
  '커피/원두/차',
  '생수/음료/주류',
  '김치/반찬/밀키트',
  '장류/양념/오일',
  '쌀/잡곡/견과',
  '정육/계란',
  '수산물/건어물',
  '과일/채소',
  '건강식품',
  '반려동물사료',
  '세제/화장품/잡화'
];


//TEST RANK CATEGORY 확인 코드 끝


