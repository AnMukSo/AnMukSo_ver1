//ㅇㅋ
import 'package:flutter/material.dart';
import 'package:an_muk_so/ranking/Page/ranking_content_page.dart';
import 'package:an_muk_so/ranking/Provider/ranking_review_provider.dart';
import 'package:an_muk_so/ranking/Provider/ranking_totalRating_provider.dart';
import 'package:an_muk_so/ranking/Widget/ranking_listTile_widget.dart';
import 'package:an_muk_so/theme/colors.dart';

class ListViewReviewWidget extends StatefulWidget {
  final FoodsReviewProvider foodsProvider;
  final String category;

  const ListViewReviewWidget({
    @required this.foodsProvider,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _ListViewReviewWidgetState createState() => _ListViewReviewWidgetState();
}

class _ListViewReviewWidgetState extends State<ListViewReviewWidget> {
  //스크롤 컨트롤
   final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //계속 스크롤을 지켜보고 있는 것
    scrollController.addListener(scrollListener);
    //그 다음 약들 끌어오는 것
    widget.foodsProvider.fetchNextFoods();
  }

  @override
  void dispose() {
    //스크롤컨트롤러 디스포즈 해주기
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    //전체 스크롤 할 수 있는 범위의 반에 도달하면 미리 그 다음 목록들을 불러오기 위한 과정
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      //만약 has next가 있다면 그 다음 것들을 fetch해와라
      if (widget.foodsProvider.hasNext) {
        widget.foodsProvider.fetchNextFoods(); //상품이 더 있다면 next 상품을 load 해라
      }
    }
  }

  //FAB를 눌렀을 때 바로 위로 가게 해두는
   void _onTap(){
     scrollController.animateTo(
       0, duration: Duration(microseconds: 500), curve: Curves.easeInOut,
     );
   }
  //이건 바로 위로 올라가게 하기위한 버튼 보고 있는 지점에서 바로 위로 올라갈 수 있게끔 도와주는
   Widget _FAB(){
     return  Container(
       width: 36,
       height: 36,
       child:
       FloatingActionButton(
         onPressed: (){
           _onTap();
         },
         child: Image.asset(
             'assets/An_Icon/An_Top.png'),
         backgroundColor: gray50,
       ),
     );
   }

  Widget build(BuildContext context) {

    //불러오는 과정에서 엠티일 때 로딩중인 화면 보여기
    if (widget.foodsProvider.foods.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    //약에 대한 로딩이 완료 되었거나 엠티가 아니라면, 가져온 목록들을 보여줄 것이다.
    else
      //이부분 보기 예제 코드와 달라서 예제 코드를 listview builder로 바꿔서 이 버전에 맞춰서 코드 진행해보았는데 변함 없이 잘 스크롤 됨. 이부분이 문제가 아님
      return Scaffold(
         floatingActionButton:
         _FAB(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.foodsProvider.foods.length,
                itemBuilder: (context, index) {
                  //print('${widget.drugsProvider.drugs[index].itemName}');
                    return RankingTile(
                      food: widget.foodsProvider.foods[index],
                      index: (index + 1),
                      filter: '리뷰 많은 순',
                      category : widget.category,
                  );
                },
              ),
            ),
          ],
        ),
      );
    //여기까지는 스크롤 문제 없다.
  }
}

class ListViewTotalRankingWidget extends StatefulWidget {
  final FoodsTotalRankingProvider foodsProvider;
  final String category;

  const ListViewTotalRankingWidget({
    @required this.foodsProvider,
    this.category,
    Key key,
  }) : super(key: key);

  @override
  _ListViewTotalRankingWidgetState createState() =>
      _ListViewTotalRankingWidgetState();
}

class _ListViewTotalRankingWidgetState
    extends State<ListViewTotalRankingWidget> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(scrollListener);
    widget.foodsProvider.fetchNextFoods();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void scrollListener() {
    if (scrollController.offset >=
            scrollController.position.maxScrollExtent / 2 &&
        !scrollController.position.outOfRange) {
      if (widget.foodsProvider.hasNext) {
        widget.foodsProvider.fetchNextFoods(); //user 가 더 있다면 next user를 load 해라
      }
    }
  }

  void _onTap(){
    scrollController.animateTo(
      0, duration: Duration(microseconds: 500), curve: Curves.easeInOut,
    );
  }

  Widget _FAB(){
   return  Container(
      decoration: BoxDecoration(
        border: Border.all(color: gray50),
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: 36,
      height: 36,
      child:
      FittedBox(
        child:
        FloatingActionButton(
          onPressed: (){
            _onTap();
          },
          child: Icon(Icons.arrow_upward, size: 35, color: gray300_inactivated,),
          backgroundColor: gray50,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    if (widget.foodsProvider.foods.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else
      return Scaffold(
        floatingActionButton:
        _FAB(),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: widget.foodsProvider.foods.length,
                itemBuilder: (context, index) {
                  //print('${widget.drugsProvider.drugs[index].itemName}');
                  return RankingTile(
                      food: widget.foodsProvider.foods[index],
                      index: (index + 1),
                      filter: '별점순',
                      category : widget.category,

                  );
                },
              ),
            ),

          ],
        ),
      );
  }

}
