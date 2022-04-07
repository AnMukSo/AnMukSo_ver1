import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/category_button.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/image.dart';
import 'package:an_muk_so/shared/ok_dialog.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isGeneral = true;

class GeneralEdit extends StatefulWidget {
  final String foodItemSeq;
  final String expirationString;

  const GeneralEdit({Key key, this.foodItemSeq, this.expirationString})
      : super(key: key);

  @override
  _GeneralEditState createState() => _GeneralEditState();
}

class _GeneralEditState extends State<GeneralEdit> {
  // variables for general case
  DateTime _pickedDateTime = DateTime.now();
  String _pickedString = DateFormat('yyyy.MM.dd').format(DateTime.now());

  // variables for prepared case
  DateTime _madeDateTime = DateTime.now();
  int _addDays = 0;
  DateTime _finalDateTime = DateTime.now().add(Duration(days: 60));
  String _finalString =
      DateFormat('yyyy.MM.dd').format(DateTime.now().add(Duration(days: 60)));
  bool _isSelf = false;

  @override
  void initState() {
    _isGeneral = true;
    _isSelf = true;

    // change String to DateTime
    String dateOfUserDrug = '';
    List<String> getOnlyDate = widget.expirationString.split('.');

    for (int i = 0; i < getOnlyDate.length; i++) {
      dateOfUserDrug = dateOfUserDrug + getOnlyDate[i];
    }

    String dateWithT = dateOfUserDrug.substring(0, 8) + 'T' + '000000';
    DateTime expirationTime = DateTime.parse(dateWithT);

    _pickedDateTime = expirationTime;
    _pickedString = DateFormat('yyyy.MM.dd').format(_pickedDateTime);

    _finalDateTime = expirationTime;
    _finalString = DateFormat('yyyy.MM.dd').format(_finalDateTime);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('사용기한 수정하기',  Image(
          image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
      backgroundColor: Colors.white,
      body: StreamBuilder<Food>(
        stream: DatabaseService(itemSeq: widget.foodItemSeq).foodData,
        builder: (context, snapshot) {
          TheUser user = Provider.of<TheUser>(context);
          Food food = snapshot.data;

          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  children: [
                    _topInfo(context, food),
                    SizedBox(height: 20),
                   _generalCase(
                            context,
                            food,
                            user,
                          )
                  ],
                ),
              ),
            );
          } else {
            return LinearProgressIndicator();
          }
        },
      ),
    );
  }

  String _shortenName(String drugName) {
    List splitName = [];

    if (drugName.contains('(')) {
      splitName = drugName.split('(');
      return splitName[0];
    } else
      return drugName;
  }

  Widget _topInfo(BuildContext context, food) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          child: FoodImage(foodItemSeq: food.itemSeq),
        ),
        SizedBox(height: 20),
        Text(
          food.entpName,
          style: Theme.of(context).textTheme.caption,
        ),
        SizedBox(height: 2),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: Text(
            _shortenName(food.itemName),
            style: Theme.of(context).textTheme.headline5,
            textAlign: TextAlign.center,
          ),
        ),
        CategoryButton(str: food.rankCategory),
      ],
    );
  }

  Widget _generalCase(context, food, user) {
    return Column(
      children: [
        _pickDay(),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 8, 8),
                child: Text(
                  '일반 상품인가요?',
                  style: TextStyle(
                    color: primary500_light_text,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              onTap: () {
                setState(() {
                  _isGeneral = false;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        _submitButton(context, user, food, _pickedString, _pickedDateTime)
      ],
    );
  }

  Widget _pickDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '유통기한',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          height: 4,
        ),
        FlatButton(
          padding: EdgeInsets.zero,
          child: Container(
            height: 45,
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: gray75),
                borderRadius: BorderRadius.circular(4)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${DateFormat('yyyy').format(_pickedDateTime)}년 ${DateFormat('MM').format(_pickedDateTime)}월 ${DateFormat('dd').format(_pickedDateTime)}일',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: gray750_activated),
                ),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
          onPressed: () {
            DatePicker.showDatePicker(context,
                showTitleActions: true,
                theme: DatePickerTheme(
                    cancelStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: gray600),
                    doneStyle: Theme.of(context)
                        .textTheme
                        .bodyText2
                        .copyWith(color: primary500_light_text),
                    itemStyle: Theme.of(context).textTheme.headline5),
                minTime: DateTime.now(),
                maxTime: DateTime(2100, 12, 31),
                onChanged: (date) {}, onConfirm: (date) async {
              setState(() {
                _pickedDateTime = date;
                _pickedString =
                    DateFormat('yyyy.MM.dd').format(_pickedDateTime);
              });
            },
                currentTime: _pickedDateTime,
                locale: LocaleType.ko); // need currentTime setting?
          },
        )
      ],
    );
  }





  Widget _submitButton(context, TheUser user, Food food,
      String expirationString, DateTime expirationDateTime) {
    String newName = food.itemName;
    List splitName = [];

    if (newName.contains('(')) {
      splitName = newName.split('(');
      newName = splitName[0];
    }

    List<String> searchNameList = newName.split('');
    List<String> searchListOutput = [];

    for (int i = 0; i < searchNameList.length; i++) {
      if (i != searchNameList.length - 1) {
        searchListOutput.add((searchNameList[i]));
      }
      List<String> temp = [searchNameList[i]];
      for (int j = i + 1; j < searchNameList.length; j++) {
        temp.add(searchNameList[j]);
        searchListOutput.add((temp.join()));
      }
    }

    bool _isPast = false;

    if (expirationDateTime.year < DateTime.now().year)
      _isPast = true;
    else if (expirationDateTime.year == DateTime.now().year &&
        expirationDateTime.month < DateTime.now().month)
      _isPast = true;
    else if (expirationDateTime.year == DateTime.now().year &&
        expirationDateTime.month == DateTime.now().month &&
        expirationDateTime.day < DateTime.now().day) _isPast = true;

    return AMSSubmitButton(
      context: context,
      isDone: true,
      textString: '수정하기',
      onPressed: () async {
        if (_isPast) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                '사용기한이 지났습니다. 다시 확인해주세요',
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black.withOpacity(0.87)));
        } else {
          OkDialog(
            context: context,
            dialogIcon: Icon(Icons.check, color: primary300_main),
            bodyString: '사용기한이 수정되었습니다',
            buttonName: '확인',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ).showWarning();

          await DatabaseService(uid: user.uid).addSavedList(
              food.itemName,
              food.itemSeq,
              food.rankCategory,
              expirationString,
              searchListOutput);
        }
      },
    );
  }
}
