import 'package:an_muk_so/camera/no_result.dart';
import 'package:an_muk_so/home/home.dart';
import 'package:an_muk_so/shared/dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'general_edit.dart';
import 'package:an_muk_so/review/food_info.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/search/search.dart';
import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/theme/colors.dart';

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class CartPage extends StatefulWidget {
  String appBarForSearch;

  CartPage({this.appBarForSearch});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  //barcode 숫자를 알기 위함
  String _scanBarcode = 'Unknown';

  //barcode init start
  @override
  void initState() {
    super.initState();
  }

  //scaning barcode start

  Future<void> scanBarcodeNormal() async {
    String barcodeNum;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeNum = await FlutterBarcodeScanner.scanBarcode(
        //바코드 화면에 보여질 parameter들
          '#ff6666', '취소', true, ScanMode.BARCODE);
      print(barcodeNum);
      if (barcodeNum == null) {
        AMSDialog(
            context: context,
            bodyString: '바코드 인식이 어렵습니다\n다시 촬영해주세요',
            leftButtonName: '취소',
            leftOnPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomePage()));
            },
            rightButtonName: '확인',
            rightOnPressed: () {
              Navigator.pop(context);
            }).showWarning();
      } else {
        var data = await DatabaseService()
            .itemSeqFromBarcode(barcodeNum);

        //Navigator.pop(context);
        //Navigator.pop(context);
        if (data != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReviewPage(data)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NoResult()));
        }
      }
    } on PlatformException {
      barcodeNum = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeNum;
    });
  }
  //scaning barcode system done


  @override
  Widget build(BuildContext context) {

    if (widget.appBarForSearch == 'search') {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(context),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: _buildBody(context),
      );
    }
  }

  Widget _buildBody(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<List<SavedFood>>(
        stream: DatabaseService(uid: user.uid).savedFoods,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _buildList(context, snapshot.data);
        });
  }

  Widget _buildList(BuildContext context, List<SavedFood> snapshot) {
    int count = snapshot.length;
    if (count == 0) {
      return _noFoodPage();
    }

    return Column(
      children: [
        //SearchBar(),
        Container(
          height: 45,
          margin: EdgeInsets.only(left: 16, top: 0, bottom: 8, right: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Text('나의 장바구니',
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(color: gray800)),
                  SizedBox(width: 8),
                  // theme 추가
                  Spacer(),
                  InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return _popUpAddFood(context);
                          });
                    },
                    child: Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        width: 95,
                        height: 28,
                        decoration: BoxDecoration(
                          border: Border.all(color: primary400_line),
                          color: primary300_main,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: gray0_white, size: 16),
                                Text(
                                  '상품 추가',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(color: gray0_white),
                                ),
                                SizedBox(width: 2)
                              ],
                            ))),
                  ),
                ],
              ),
            ),
          ),
        ),
        Divider(height: 3, thickness: 0.5, indent: 1, endIndent: 0),
        Expanded(
          child:
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: snapshot.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, snapshot[index], index + 1, count);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
      BuildContext context, SavedFood data, int index, int totalNum) {
    TheUser user = Provider.of<TheUser>(context);

    double mw = MediaQuery.of(context).size.width;

    //TODO: 시간 계산하기 위한 코드 시작
    String dateOfUserFood = '';
    List<String> getOnlyDate = data.expiration.split('.');

    for (int i = 0; i < getOnlyDate.length; i++) {
      dateOfUserFood = dateOfUserFood + getOnlyDate[i];
    }

    String dateWithT = dateOfUserFood.substring(0, 8) + 'T' + '000000';
    DateTime expirationTime = DateTime.parse(dateWithT);

    String dateNow = DateFormat('yyyyMMdd').format(DateTime.now());
    List<String> getOnlyDateOfNow = dateNow.split('.');

    for (int i = 0; i < getOnlyDateOfNow.length; i++) {
      dateNow = dateNow + getOnlyDateOfNow[i];
    }

    String dateNowWithT = dateNow.substring(0, 8) + 'T' + '000000';
    DateTime rightNowTime = DateTime.parse(dateNowWithT);

    final difference = expirationTime.difference(rightNowTime).inDays;


    //사용기한 7일 남음
    if (difference < 8 && difference > -1) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0),
                  //width: double.infinity,
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            width: 88,
                            child: FoodImage(foodItemSeq: data.itemSeq)),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningRemainMessage(context, difference),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 0.6, color: gray50))),
                height: 20,
              )
            ],
          ),
        )
            : Container(
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.6, color: gray50))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0),
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            width: 88,
                            child: FoodImage(foodItemSeq: data.itemSeq)),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: yellow),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningRemainMessage(context, difference),
                ),
              )
            ],
          ),
        ),
      );
    }
    //사용기한 지남
    else if (difference < 0) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0),
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            child: Container(
                                width: 88,
                                child: FoodImage(
                                    foodItemSeq: data.itemSeq))),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: warning),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningOverDayMessage(context, difference),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(width: 0.6, color: gray50))),
                height: 20,
              )
            ],
          ),
        )
            : Container(
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.6, color: gray50))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0),
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            child: Container(
                                width: 88,
                                child: FoodImage(
                                    foodItemSeq: data.itemSeq))),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(33, 0, 16, 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: warning),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: _warningOverDayMessage(context, difference),
                ),
              )
            ],
          ),
        ),
      );
    }
    //사용기한 아직 넉넉함
    else
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(data.itemSeq),
            ),
          ),
        },
        child: index == totalNum
            ? Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16.0,
                  ),
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            child: Container(
                                width: 88,
                                child: FoodImage(
                                    foodItemSeq: data.itemSeq))),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.6, color: gray50))),
                  height: 20)
            ],
          ),
        )
            : Container(
          decoration: BoxDecoration(
              border:
              Border(bottom: BorderSide(width: 0.6, color: gray50))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 16.0,
                  ),
                  height: 90,
                  child: Material(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: SizedBox(
                            width: 15,
                            child: Center(
                              child: Text(index.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                      color: gray600, fontSize: 11)),
                            ),
                          ),
                        ),
                        Container(
                            child: Container(
                                width: 88,
                                child: FoodImage(
                                    foodItemSeq: data.itemSeq))),
                        Container(
                            padding: EdgeInsets.only(left: 12, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: mw - 200,
                                    child: Text(data.itemName,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color:
                                            gray750_activated))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 3),
                                  child: Container(
                                      height: 23,
                                      child: CategoryButton(
                                          str: data.rankCategory,
                                          fromHome: 'home')),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Row(
                                  children: [
                                    Text('${data.expiration}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                    Text('까지 ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            .copyWith(
                                            color: gray600,
                                            fontSize: 11)),
                                  ],
                                )
                              ],
                            )),
                        Spacer(),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: gray500,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _popUpMenu(
                                        context, data, user);
                                  });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  Widget _popUpAddFood(context) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          )),
      child: Wrap(
        children: <Widget>[
          Container(
            height: 45,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    child: Text(
                      '상품 추가하기',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: primary500_light_text),
                      textAlign: TextAlign.start,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () async {
               // Navigator.pop(context);
                scanBarcodeNormal();
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/barcode_icon_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "바코드 인식",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: MaterialButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/search');
              },
              child: Row(
                children: <Widget>[
                  SizedBox(height: 10),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Image.asset('assets/icons/search_grey.png'),
                  ),
                  SizedBox(width: 15),
                  Container(
                    child: Center(
                      child: Text(
                        "상품 이름 검색",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray900),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(thickness: 1, color: gray100),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                    child: Text("닫기",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: gray300_inactivated)))),
          )
        ],
      ),
    );
  }

  Widget _popUpMenu(context, data, user) {
    return Container(
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(12.0),
            topRight: const Radius.circular(12.0),
          )),
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          fullscreenDialog: true,
                          builder: (context) {
                              return GeneralEdit(
                                  foodItemSeq: data.itemSeq,
                                  expirationString: data.expiration);
                          }));
                },
                child: Center(
                    child: Text(
                      "유통기한 수정하기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray900),
                    ))),
          ),
          Padding(
            // padding: EdgeInsets.only(bottom: 4.0),
            padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
            child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  showWarning(context, '정말 삭제하시겠어요?', '취소', '삭제',
                      'deleteUserFood', user.uid, data.itemSeq);
                },
                child: Center(
                  child: Text("삭제하기",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: gray900)),
                )),
          ),
          // Divider(thickness: 1, color: gray100),

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: gray100)),
              ),
              child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Center(
                      child: Text("닫기",
                          style: Theme.of(context).textTheme.bodyText1.copyWith(
                              color: gray300_inactivated, fontSize: 16)))),
            ),
          )
        ],
      ),
    );
  }

  void showWarning(
      BuildContext context,
      String bodyString,
      String leftButtonName,
      String rightButtonName,
      String actionCode,
      String uid,
      String record) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          // title:
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700)),
              SizedBox(height: 28),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      leftButtonName,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: primary400_line),
                    ),
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(120, 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        elevation: 0,
                        primary: gray50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: gray75))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                      child: Text(
                        rightButtonName,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(color: gray0_white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(120, 40),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          primary: primary300_main,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide(color: primary400_line))),
                      onPressed: () async {
                        Navigator.pop(context);

                        showOkWarning(
                          context,
                          Icon(Icons.check, color: primary300_main),
                          '장바구니에서 삭제되었습니다',
                          '확인',
                        );

                        await DatabaseService(uid: uid)
                            .deleteSavedFoodData(record);
                      })
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void showOkWarning(BuildContext context, Widget dialogIcon, String bodyString,
      String buttonName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              dialogIcon,
              SizedBox(height: 16),
              /* BODY */
              Text(
                bodyString,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: gray700),
              ),
              SizedBox(height: 16),
              /* BUTTON */
              ElevatedButton(
                child: Text(
                  buttonName,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: primary400_line),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(260, 40),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    elevation: 0,
                    primary: gray50,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: gray75))),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget _warningRemainMessage(context, dayRemain) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 70,
      height: 30,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_yellow.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(text: '사용기한이 '),
                    TextSpan(
                      text: '$dayRemain일',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' 남았습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _warningOverDayMessage(context, difference) {
    List<String> dayOver = difference.toString().split('-');
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      width: MediaQuery.of(context).size.width - 70,
      height: 30,
      decoration: BoxDecoration(
        color: gray50,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                  width: 15,
                  height: 15,
                  child: Image.asset('assets/icons/warning_red.png')),
              SizedBox(width: 6),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(fontSize: 12),
                  children: <TextSpan>[
                    TextSpan(text: '사용기한이 '),
                    TextSpan(
                      text: '${dayOver[1]}일',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' 지났습니다'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _noFoodPage() {
    return Column(children: [
      //SearchBar(),
      Container(
        height: 45,
        margin: EdgeInsets.only(left: 16, top: 0, bottom: 8, right: 16),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Container(
            child: Row(
              children: <Widget>[
                Text('나의 장바구니',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: gray800)),
                SizedBox(width: 8),
                // theme 추가
                Spacer(),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return _popUpAddFood(context);
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      width: 95,
                      height: 26,
                      decoration: BoxDecoration(
                        border: Border.all(color: primary400_line),
                        color: primary300_main,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: gray0_white, size: 16),
                          Text(
                            '상품 추가',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .copyWith(color: gray0_white),
                          ),
                          SizedBox(width: 2)
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(right: 13),
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
                height: 45,
                child: Image(image: AssetImage('assets/images/msg_box.png'))),
          ],
        ),
      ),
      SizedBox(height: 70,),
      Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  height: 150,
                  child: Image(image: AssetImage('assets/images/background_nothing.png'))),
            ],
          ),
        ),
      ),
      Spacer(),
      Container(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 75.0),
            child: SizedBox(
                height: 45,
                child: Image(image: AssetImage('assets/images/bottom_msg_box.png'))),
          )),
    ]);
  }
}

// class SearchBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
//       child: SizedBox(
//           height: 40,
//           child: FlatButton(
//             padding: EdgeInsets.zero,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 12.0, top: 5, bottom: 4, right: 5),
//                   child: SizedBox(
//                     height: 24,
//                     width: 24,
//                     child: Image.asset('assets/icons/search_icon.png'),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 7.0),
//                   child: Text(
//                     "어떤 상품을 찾고 계세요?",
//                     style: Theme.of(context)
//                         .textTheme
//                         .bodyText2
//                         .copyWith(color: gray300_inactivated),
//                   ),
//                 ),
//               ],
//             ),
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => SearchScreen(),
//                   ));
//             },
//             textColor: gray300_inactivated,
//             color: gray50,
//             shape: OutlineInputBorder(
//                 borderSide: BorderSide(
//                     style: BorderStyle.solid, width: 1.0, color: gray75),
//                 borderRadius: BorderRadius.circular(8.0)),
//           )),
//     );
//   }
// }

