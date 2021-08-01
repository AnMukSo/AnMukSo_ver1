import 'package:flutter/material.dart';
import 'package:an_muk_so/services/db.dart';

import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

bool _isTypePicked = false;
bool _isSubjectFilled = false;
bool _isBodyFilled = false;
bool _isEmailFilled = false;

class InquiryPage extends StatefulWidget {
  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  final _emailController = TextEditingController();

  int index = 0;

  @override
  Widget build(BuildContext context) {
    bool validateEmail(String value) {
      Pattern pattern =
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
          r"{0,253}[a-zA-Z0-9])?)*$";
      RegExp regex = new RegExp(pattern);

      if (!regex.hasMatch(value) || value == null)
        return false;
      else
        return true;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWithGoToBack('1:1 문의', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 24, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '문의 유형',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 45,
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                    border: Border.all(color: gray75),
                    borderRadius: BorderRadius.circular(4)),
                child: DropdownButton(
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down),
                  underline: SizedBox.shrink(),
                  value: index,
                  items: <DropdownMenuItem>[
                    DropdownMenuItem(
                      value: 0,
                      child: Text(
                        '선택해주세요',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = false;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 1,
                      child: Text(
                        '1. 의약품 정보 문의 및 요청',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = true;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 2,
                      child: Text(
                        '2. 서비스 불편, 오류 제보',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = true;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 3,
                      child: Text(
                        '3. 사용 방법, 기타 문의',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = true;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 4,
                      child: Text(
                        '4. 의견 제안, 칭찬',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = true;
                        });
                      },
                    ),
                    DropdownMenuItem(
                      value: 5,
                      child: Text(
                        '5. 제휴 문의',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: gray750_activated),
                      ),
                      onTap: () {
                        setState(() {
                          _isTypePicked = true;
                        });
                      },
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      index = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 24),
              Text(
                '문의 제목',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                  height: 48,
                  child: TextField(
                    controller: _subjectController,
                    decoration: InputDecoration(
                      hintText: '문의 제목을 입력해주세요.',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                      // labelText: '',
                      contentPadding: EdgeInsets.all(12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gray75),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary300_main),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _isSubjectFilled = true;
                        });
                      } else {
                        setState(() {
                          _isSubjectFilled = false;
                        });
                      }
                    },
                  )),
              SizedBox(height: 24),
              Text(
                '문의 내용',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                  height: 144,
                  child: TextField(
                    controller: _bodyController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: '문의 내용을 입력해주세요.',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                      contentPadding: EdgeInsets.all(12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gray75),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary300_main),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        setState(() {
                          _isBodyFilled = true;
                        });
                      } else {
                        setState(() {
                          _isBodyFilled = false;
                        });
                      }
                    },
                  )),
              Text(
                '답변 받을 이메일',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                  height: 48,
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'abc@iymy.com',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: gray300_inactivated,
                          ),
                      contentPadding: EdgeInsets.all(12.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: gray75),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primary300_main),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(4.0)),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && validateEmail(value)) {
                        setState(() {
                          _isEmailFilled = true;
                        });
                      } else {
                        setState(() {
                          _isEmailFilled = false;
                        });
                      }
                    },
                  )),
              SizedBox(height: 32),
              submitField(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitField(context) {
    return AMSSubmitButton(
        context: context,
        isDone: _isTypePicked &&
            _isSubjectFilled &&
            _isBodyFilled &&
            _isEmailFilled,
        textString: '문의 보내기',
        onPressed: () async {
          if (_isTypePicked &&
              _isSubjectFilled &&
              _isBodyFilled &&
              _isEmailFilled) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  insetPadding: EdgeInsets.zero,
                  contentPadding: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 16),
                      /* BODY */
                      Text("문의내용을 전송하시겠어요?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: gray700)),
                      SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /* LEFT ACTION BUTTON */
                          ElevatedButton(
                            child: Text(
                              "취소",
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
                          /* RIGHT ACTION BUTTON */
                          ElevatedButton(
                              child: Text(
                                "확인",
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
                                      side:
                                          BorderSide(color: primary400_line))),
                              onPressed: () async {
                                await DatabaseService().createInquiry(
                                    index,
                                    _subjectController.text,
                                    _bodyController.text,
                                    _emailController.text);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                IYMYGotoSeeOrCheckDialog(
                                    "문의가 완료되었습니다.\n소중한 의견 감사합니다.");
                              })
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          }
        });
  }

  Widget IYMYGotoSeeOrCheckDialog(alertContent) {
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
              Icon(Icons.check, color: primary300_main),
              SizedBox(height: 13),
              /* BODY */
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    // TextSpan(
                    //     text: boldBodyString,
                    //     style: Theme.of(context).textTheme.headline4.copyWith(
                    //         color: gray700, fontWeight: FontWeight.w700)),
                    TextSpan(text: alertContent),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '주말, 공휴일에는 확인이 지연될 수 있습니다',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: gray300_inactivated),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              /* RIGHT ACTION BUTTON */
              ElevatedButton(
                child: Text(
                  "확인",
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
}
