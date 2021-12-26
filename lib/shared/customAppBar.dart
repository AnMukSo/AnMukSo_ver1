import 'package:an_muk_so/search/search.dart';
import 'package:flutter/material.dart';
//import 'package:an_muk_so/home/search_screen.dart';
//import 'package:an_muk_so/ranking/Page/ranking_content_page.dart';
import 'package:an_muk_so/theme/colors.dart';

class CustomAppBarWithGoToBack extends StatelessWidget
    with PreferredSizeWidget {
  final Size preferredSize;

  final String title;
  final Icon customIcon;
  final double elevation;

  CustomAppBarWithGoToBack(
    this.title,
    this.customIcon,
    this.elevation, {
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
      ),
      elevation: elevation,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: customIcon,
        color: primary300_main,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class CustomAppBarWithGoToRanking extends StatelessWidget
    with PreferredSizeWidget {
  final Size preferredSize;

  final String title;
  final Icon customIcon;
  final double elevation;
  final String filter;
  final String category;

  CustomAppBarWithGoToRanking(
    this.title,
    this.customIcon,
    this.elevation, {
    this.filter,
    this.category,
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (filter != null) {
      return AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
        ),
        elevation: elevation,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: customIcon,
          color: primary300_main,
          onPressed: () {
            Navigator.pop(context);
            //리뷰와 별점순 관련해서 페이지 라우트 좀더 매끄럽게 하기 위해
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) =>
            //           // TestRanking(categoryName: numCategory[index] + categories[index])
            //           RankingContentPage(
            //             categoryName: category,
            //             filter: filter,
            //           )),
            // );
          },
        ),
      );
    } else {
      return AppBar(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
        ),
        elevation: elevation,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: customIcon,
          color: primary300_main,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}

class CustomAppBarWithArrowBackAndSearch extends StatelessWidget
    with PreferredSizeWidget {
  final Size preferredSize;
  final String title;
  final double elevation;

  CustomAppBarWithArrowBackAndSearch(
    this.title,
    this.elevation, {
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
      ),
      elevation: elevation,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [

    /*
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon:
            Icon(
              Icons.search,
              color: primary300_main,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SearchScreen()),
            ),
          ),
        ),
    */
    Padding(
    padding: const EdgeInsets.only(right: 10.0),
    child: IconButton(
    icon:
    SizedBox(
    height: 50,
    width: 50,
    child: Image(image: AssetImage('assets/icons/An_Search.png'))),
    onPressed: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => SearchScreen()),
    ),
    ),)
        //for test home
      ],
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: primary300_main,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ResultAppBarBarcode extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;
  final int type;

  ResultAppBarBarcode({Key key, this.type})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        type == 1 ? '바코드 인식 결과' : '케이스 인식 결과',
        style: Theme.of(context).textTheme.headline5.copyWith(color: gray800),
      ),
      elevation: 0.5,
      titleSpacing: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        color: primary300_main,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: IconButton(
              icon: ImageIcon(
                AssetImage('assets/icons/home_icon.png'),
                color: primary300_main,
                // color: gray100,
              ),
              onPressed: () => Navigator.pushNamed(context, '/bottom_bar')),
        ),
        //for test home
      ],
    );
  }
}
