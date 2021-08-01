import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

class OkDialog extends StatelessWidget {
  final BuildContext context;
  final Widget dialogIcon;
  final String bodyString;
  final String buttonName;
  final Function onPressed;

  const OkDialog({
    Key key,
    this.context,
    @required this.dialogIcon,
    @required this.bodyString,
    @required this.buttonName,
    @required this.onPressed,
  }) : super(key: key);

  void showWarning() {
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
                  onPressed: onPressed)
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
