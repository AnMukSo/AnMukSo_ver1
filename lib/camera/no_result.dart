import 'package:an_muk_so/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:an_muk_so/shared/customAppBar.dart';

class NoResult extends StatefulWidget {
  @override
  _NoResultState createState() => _NoResultState();
}

class _NoResultState extends State<NoResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResultAppBarBarcode(type: 1),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: 32,
                height: 32,
                child: Image.asset('assets/icons/no_result.png')),
            SizedBox(
              height: 10,
            ),
            Text(
              '검색결과가 없습니다',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 2.5      //앱 화면 높이 double Ex> 692.0
              ,),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: ImageIcon(
                AssetImage('assets/icons/home_icon.png'),
                color: primary300_main,
                // color: gray100,
              ),
              label: Text("홈으로 돌아가기",
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    .copyWith(color: primary500_light_text)),
            )
          ],
        ),
      ),
    );
  }
}
