import 'package:an_muk_so/search/search.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/mypage/mypage.dart';
import 'package:an_muk_so/theme/colors.dart';
//import 'package:an_muk_so/home/home.dart';

class AMSAppBar extends StatelessWidget with PreferredSizeWidget {
  final Size preferredSize;

  final String title;

  AMSAppBar(
      this.title, {
        Key key,
      })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title == 'home') {
      return AppBar(
        elevation: 0.5,
        titleSpacing: 8,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image(image: AssetImage('assets/icons/AMS_Logo.png'))),
            ),
            //TODO: 안먹소 글씨 추가해야함
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              iconSize: 50,
              icon:
              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image(image: AssetImage('assets/icons/An_User.png'))),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              ),
            ),
          ),
          //for test home
        ],
      );
    } else //category bar
      return AppBar(
        titleSpacing: 8,
        leading: IconButton(
          icon:
          SizedBox(
              height: 28,
              width: 28,
              child: Image(image: AssetImage('assets/icons/An_Back.png'))),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: gray800),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.5,
        actions: [
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
            ),
          ),
          //for test home
        ],
      );
  }
  /*
  @override
  Widget build(BuildContext context) {
      return AppBar(
        elevation: 0.5,
        titleSpacing: 8,
        title: FlatButton(
          onPressed: (){
           Navigator.pushNamed(context, '/home');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image(image: AssetImage('assets/icons/AMS_Logo.png'))),
              ),
              Text('안먹소', style: Theme.of(context)
                  .textTheme
                  .headline3
                  .copyWith(color: gray900),)
            ],
          ),
        ),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              iconSize: 50,
              icon:
              SizedBox(
                  height: 50,
                  width: 50,
                  child: Image(image: AssetImage('assets/icons/An_User.png'))),
              // Icon(
              //   Icons.person,
              //   color: primary300_main,
              // ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPage()),
              ),
            ),
          ),
          //for test home
        ],
      );
    }
    */
}
