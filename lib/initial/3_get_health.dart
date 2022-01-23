import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/constants.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isFind = false;
bool _isFirstFilled = false;
bool _isSecondFilled = false;
bool _isThirdFilled = false;

class GetHealthPage extends StatefulWidget {
  final String nickname;
  final String birthYear;
  final String sex;

  const GetHealthPage({Key key, this.nickname, this.birthYear, this.sex})
      : super(key: key);

  @override
  _GetHealthPageState createState() => _GetHealthPageState();
}

class _GetHealthPageState extends State<GetHealthPage> {
  TextEditingController _selfWritingController = TextEditingController();
  TextEditingController _secondWritingController = TextEditingController();
  TextEditingController _thirdWritingController = TextEditingController();

  List<bool> _isKeywordList = List.generate(10, (_) => false);
  List<String> _keywordList = [];
  List<String> _selfKeywordList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            CustomAppBarWithGoToBack('키워드 알림 설정', Icon(Icons.arrow_back), 0.5),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topTitle(),
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                      child: Theme(
                          data: ThemeData(
                            primaryColor: Colors.teal[400],
                            inputDecorationTheme: InputDecorationTheme(
                                labelStyle: TextStyle(
                              color: Colors.teal[400],
                              fontSize: 18.0,
                            )),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              chooseKeywords(),
                              SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '원하는 키워드가 없으신가요?',
                                    style: TextStyle(
                                      fontFamily: 'Noto Sans KR',
                                      color: Colors.grey,
                                      fontSize: 12.0,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isFind = !_isFind;
                                  });
                                },
                              ),
                              _isFind ? selfWrite() : Container(),
                              _isFind && _isFirstFilled
                                  ? SizedBox(height: 10)
                                  : Container(),
                              _isFind && _isFirstFilled
                                  ? secondWrite()
                                  : Container(),
                              _isFind && _isFirstFilled && _isSecondFilled
                                  ? SizedBox(height: 10)
                                  : Container(),
                              _isFind && _isFirstFilled && _isSecondFilled
                                  ? thirdWrite()
                                  : Container(),
                              SizedBox(
                                height: 40.0,
                              ),
                              submit()
                            ],
                          )))
                ],
              ),
            ),
          );
        }));
  }

  Widget topTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            textAlign: TextAlign.start,
            text: TextSpan(
              style: Theme.of(context).textTheme.headline3,
              children: <TextSpan>[
                TextSpan(
                  text: '단어를 선택해주시면\n',
                ),
                TextSpan(
                  text: '맞춤형 키워드 알림',
                  style: Theme.of(context).textTheme.headline2,
                ),
                TextSpan(
                  text: '을 드려요',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget chooseKeywords() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaQuery.of(context).size.width > 350
              ? Row(
                  children: [
                    Text('알림을 받고싶은 키워드를 선택해주세요 ',
                        style: Theme.of(context).textTheme.subtitle1),
                    Text('(복수선택가능)',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w100))
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('알림을 받고싶은 키워드를 선택해주세요 ',
                        style: Theme.of(context).textTheme.subtitle1),
                    Text('(복수선택가능)',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontWeight: FontWeight.w100))
                  ],
                ),
          SizedBox(height: 12.0),
          Row(
            children: [
              _exclusiveMultiButton(0, _isKeywordList, '없음'),
              SizedBox(width: 6),
              _exclusiveMultiButton(1, _isKeywordList, '임산부'),
              SizedBox(width: 6),
              _exclusiveMultiButton(2, _isKeywordList, '고령자'),
              SizedBox(width: 6),
              _exclusiveMultiButton(3, _isKeywordList, '소아'),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              _exclusiveMultiButton(4, _isKeywordList, '간'),
              SizedBox(width: 6),
              _exclusiveMultiButton(5, _isKeywordList, '신장(콩팥)'),
              SizedBox(width: 6),
              _exclusiveMultiButton(6, _isKeywordList, '심장'),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              _exclusiveMultiButton(7, _isKeywordList, '고혈압'),
              SizedBox(width: 6),
              _exclusiveMultiButton(8, _isKeywordList, '당뇨'),
              SizedBox(width: 6),
              _exclusiveMultiButton(9, _isKeywordList, '유당분해요소 결핍증'),
            ],
          ),
        ],
      ),
    );
  }

  Widget selfWrite() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: TextField(
        controller: _selfWritingController,
        cursorColor: primary400_line,
        decoration: textInputDecoration.copyWith(
            hintText: '키워드 입력하기',
            suffixIcon: IconButton(
              icon: _isFirstFilled
                  ? Icon(
                      Icons.cancel,
                      color: gray300_inactivated,
                    )
                  : Container(),
              onPressed: () {
                setState(() {
                  if (_secondWritingController.text.isNotEmpty) {
                    // 2번째 칸과 3번째 칸이 모두 비어있지 않을 때: 1번째칸에는 2번째칸 내용이, 2번째칸에는 3번째칸 내용이
                    if (_thirdWritingController.text.isNotEmpty) {
                      _selfWritingController.text =
                          _secondWritingController.text;

                      _secondWritingController.text =
                          _thirdWritingController.text;

                      _thirdWritingController.text = '';
                    } else {
                      // 2번째 칸만 비어있지 않을 때: 1번째칸에는 2번째칸 내용이
                      _selfWritingController.text =
                          _secondWritingController.text;
                      _secondWritingController.text = '';
                      _isSecondFilled = false;
                    }
                  }
                  // 1번째 칸 2번째칸 모두 비어있을 때: 1번째칸 내용만 지우면 된다
                  else {
                    _selfWritingController.text = '';
                    _isFirstFilled = false;
                  }
                });
              },
            )),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {
            if (_selfWritingController.text.isEmpty) {
              // 2번째와 3번째가 모두 채워져있을 때: 2-->1, 3-->2, 3-->''
              if (_secondWritingController.text.isNotEmpty &&
                  _thirdWritingController.text.isNotEmpty) {
                _selfWritingController.text = _secondWritingController.text;
                _secondWritingController.text = _thirdWritingController.text;
                _thirdWritingController.text = '';
              }
              // 2번째만 채워져있을 때: 2-->1, 2-->''
              else if (_secondWritingController.text.isNotEmpty) {
                _selfWritingController.text = _secondWritingController.text;
                _secondWritingController.text = '';
                _isSecondFilled = false;
              }
              // 아무것도 채워져있지 않을 때
              else {
                _isFirstFilled = false;
              }
            } else {
              setState(() {
                _isFirstFilled = true;
              });
            }
          });
        },
      ),
    );
  }

  Widget secondWrite() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: TextField(
        controller: _secondWritingController,
        cursorColor: primary400_line,
        decoration: textInputDecoration.copyWith(
            hintText: '키워드 추가 입력하기',
            suffixIcon: IconButton(
              icon: _isSecondFilled
                  ? Icon(
                      Icons.cancel,
                      color: gray300_inactivated,
                    )
                  : Container(),
              onPressed: () {
                setState(() {
                  if (_thirdWritingController.text.isNotEmpty) {
                    _secondWritingController.text =
                        _thirdWritingController.text;
                    _thirdWritingController.text = '';
                  } else {
                    _secondWritingController.text = '';
                    _isSecondFilled = false;
                  }
                });
              },
            )),
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {
            if (_secondWritingController.text.isEmpty) {
              // 3번째만 채워져있을 때: 3-->2 3-->''
              if (_thirdWritingController.text.isNotEmpty) {
                _secondWritingController.text = _thirdWritingController.text;
                _thirdWritingController.text = '';
              }
              // 아무것도 채워져있지 않을 때
              else {
                _isSecondFilled = false;
              }
            } else {
              setState(() {
                _isSecondFilled = true;
              });
            }
          });
        },
      ),
    );
  }

  Widget thirdWrite() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
      child: TextField(
        controller: _thirdWritingController,
        cursorColor: primary400_line,
        decoration: textInputDecoration.copyWith(
            hintText: '키워드 추가 입력하기',
            suffixIcon: IconButton(
              icon: _isThirdFilled
                  ? Icon(
                      Icons.cancel,
                      color: gray300_inactivated,
                    )
                  : Container(),
              onPressed: () {
                setState(() {
                  _thirdWritingController.text = '';
                });
              },
            )),
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget submit() {
    TheUser user = Provider.of<TheUser>(context);

    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        child: AMSSubmitButton(
          context: context,
          isDone: true,
          textString: '안먹소 시작하기',
          onPressed: () async {
            // 이용약관 동의 날짜 저장
            String nowDT = DateFormat('yyyy.MM.dd').format(DateTime.now());
            await DatabaseService(uid: user.uid).addUser(nowDT);

            await DatabaseService(uid: user.uid).updateUserPrivacy(
                widget.nickname, widget.birthYear, widget.sex);

            if (_isKeywordList[1] == true) _keywordList.add('임산부');
            if (_isKeywordList[2] == true) _keywordList.add('고령자');
            if (_isKeywordList[3] == true) _keywordList.add('소아');
            if (_isKeywordList[4] == true) _keywordList.add('간');
            if (_isKeywordList[5] == true) _keywordList.add('신장');
            if (_isKeywordList[6] == true) _keywordList.add('심장');
            if (_isKeywordList[7] == true) _keywordList.add('고혈압');
            if (_isKeywordList[8] == true) _keywordList.add('당뇨');
            if (_isKeywordList[9] == true) _keywordList.add('유당불내증');

            if (_selfWritingController.text.isNotEmpty)
              _selfKeywordList.add(_selfWritingController.text);

            if (_secondWritingController.text.isNotEmpty)
              _selfKeywordList.add(_selfWritingController.text);

            if (_thirdWritingController.text.isNotEmpty)
              _selfKeywordList.add(_selfWritingController.text);

            await DatabaseService(uid: user.uid)
                .updateUserKeywordList(_keywordList);
            await DatabaseService(uid: user.uid)
                .updateUserSelfKeywordList(_selfKeywordList);

            Navigator.of(context).pushNamedAndRemoveUntil(
                '/start', (Route<dynamic> route) => false);
          },
        ));
  }

  Widget _exclusiveMultiButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 40.0,
      child: FlatButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
                color: isPressed[index] ? primary300_main : gray200)),
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: MediaQuery.of(context).size.width > 350 ? 16.0 : 12.0),
        onPressed: () {
          setState(() {
            // 0번 버튼을 누르면 나머지 버튼 값은 모두 false
            if (index == 0) {
              isPressed[0] = true;
              for (int i = 1; i < isPressed.length; i++) {
                isPressed[i] = false;
              }
            }
            // 0번 버튼이 아닌 버튼을 누르면 0번 버튼은 false
            else {
              isPressed[index] = !isPressed[index];
              isPressed[0] = false;
            }
          });
        },
        child: Text(buttonName,
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: isPressed[index] ? primary500_light_text : gray400,
                )),
      ),
    );
  }
}
