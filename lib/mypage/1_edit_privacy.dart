import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/services/db.dart';
import 'package:an_muk_so/shared/constants.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/shared/ok_dialog.dart';
import 'package:an_muk_so/shared/submit_button.dart';
import 'package:an_muk_so/theme/colors.dart';

var birthYearMaskFormatter =
    new MaskTextInputFormatter(mask: '####', filter: {"#": RegExp(r'[0-9]')});

bool _isGenderFilled = true;
bool _isBirthYearFilled = true;
bool _isNicknameFilled = true;

class EditPrivacyPage extends StatefulWidget {
  final String title = '개인 정보 수정';
  final UserData userData;

  const EditPrivacyPage({Key key, this.userData}) : super(key: key);

  @override
  _EditPrivacyPageState createState() => _EditPrivacyPageState();
}

class _EditPrivacyPageState extends State<EditPrivacyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<bool> _isSelected;
  TextEditingController _birthYearController = TextEditingController();
  TextEditingController _nicknameController = TextEditingController();

  @override
  void dispose() {
    _nicknameController.dispose();
    _birthYearController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _nicknameController.text = widget.userData.nickname;
    _birthYearController.text = widget.userData.birthYear;
    _isSelected =
        (widget.userData.sex == 'female') ? [false, true] : [true, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithGoToBack('회원정보 수정', Icon(Icons.arrow_back), 0.5),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 24,
                  ),
                  nickname(),
                  SizedBox(
                    height: 25.0,
                  ),
                  birthYear(),
                  SizedBox(
                    height: 25.0,
                  ),
                  sex(),
                  SizedBox(height: 50.0),
                  submit(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nickname() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '닉네임',
          style: Theme.of(context).textTheme.subtitle2.copyWith(color: gray500),
        ),
        TextFormField(
          controller: _nicknameController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(hintText: '10자 이하의 닉네임'),
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray900),
          keyboardType: TextInputType.text,
          onChanged: (value) {
            if (value.length >= 1) {
              setState(() {
                _isNicknameFilled = true;
              });
            } else {
              setState(() {
                _isNicknameFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty) return "닉네임을 입력하세요.";
            return null;
          },
        ),
      ],
    );
  }

  Widget birthYear() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '출생년도',
          style: Theme.of(context).textTheme.subtitle2.copyWith(color: gray500),
        ),
        TextFormField(
          controller: _birthYearController,
          cursorColor: primary400_line,
          decoration: textInputDecoration.copyWith(hintText: '출생년도 4자리'),
          style: Theme.of(context).textTheme.headline5.copyWith(color: gray900),
          keyboardType: TextInputType.number,
          inputFormatters: [birthYearMaskFormatter],
          onChanged: (value) {
            if (value.length == 4) {
              setState(() {
                _isBirthYearFilled = true;
              });
            } else {
              setState(() {
                _isBirthYearFilled = false;
              });
            }
          },
          validator: (String value) {
            if (value.isEmpty) return "출생년도를 입력하세요.";
            return null;
          },
        ),
      ],
    );
  }

  Widget sex() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '성별',
          style: Theme.of(context).textTheme.subtitle2.copyWith(color: gray500),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            exclusiveButton(0, _isSelected, '남'),
            SizedBox(width: 10),
            exclusiveButton(1, _isSelected, '여'),
          ],
        ),
      ],
    );
  }

  Widget submit(context) {
    TheUser user = Provider.of<TheUser>(context);

    return AMSSubmitButton(
        context: context,
        isDone: _isGenderFilled && _isBirthYearFilled && _isNicknameFilled,
        textString: '저장하기',
        onPressed: () async {
          if (_isGenderFilled && _isBirthYearFilled && _isNicknameFilled) {
            if (_nicknameController.text.length >= 10) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '닉네임을 10자 이하로 입력해주세요',
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            } else if (2020 < int.parse(_birthYearController.text) ||
                int.parse(_birthYearController.text) <= 1900) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    '생년월일을 올바르게 입력해주세요',
                    textAlign: TextAlign.center,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.black.withOpacity(0.87)));
            } else {
              var result =
                  await DatabaseService().isUnique(_nicknameController.text);
              if (_nicknameController.text == widget.userData.nickname)
                result = true;
              if (result == false) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      '이미 존재하는 닉네임입니다',
                      textAlign: TextAlign.center,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.black.withOpacity(0.87)));
              } else {
                await DatabaseService(uid: user.uid).updateUserPrivacy(
                  _nicknameController.text,
                  _birthYearController.text,
                  _isSelected[0] ? 'male' : 'female',
                );

                // await ReviewService().updateNickname(
                //   user.uid,
                //   _nicknameController.text,
                // );

                OkDialog(
                  context: context,
                  dialogIcon: Icon(Icons.check, color: primary300_main),
                  bodyString: '개인정보가 수정되었습니다',
                  buttonName: '확인',
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ).showWarning();
              }
            }
          }
        });
  }

  Widget exclusiveButton(index, isPressed, buttonName) {
    return ButtonTheme(
      minWidth: 70.0,
      child: FlatButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(
                color: isPressed[index] ? primary300_main : gray200)),
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        onPressed: () {
          setState(() {
            _isGenderFilled = true;

            for (int buttonIndex = 0;
                buttonIndex < isPressed.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isPressed[buttonIndex] = true;
              } else {
                isPressed[buttonIndex] = false;
              }
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
