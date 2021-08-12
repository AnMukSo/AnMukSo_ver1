import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

class ShortCutDialog extends StatelessWidget {
  final BuildContext context;
  final Widget dialogIcon;
  final String boldBodyString;
  final String normalBodyString;
  final String topButtonName;
  final String bottomButtonName;
  final Function onPressedTop;
  final Function onPressedBottom;

  const ShortCutDialog({
    Key key,
    this.context,
    @required this.dialogIcon,
    @required this.boldBodyString,
    @required this.normalBodyString,
    @required this.topButtonName,
    @required this.bottomButtonName,
    @required this.onPressedTop,
    @required this.onPressedBottom,
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
              SizedBox(height: 13),
              /* BODY */
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700),
                  children: <TextSpan>[
                    TextSpan(
                        text: boldBodyString,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: gray700, fontWeight: FontWeight.w700)),
                    TextSpan(text: normalBodyString),
                  ],
                ),
              ),
              SizedBox(height: 3),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          topButtonName,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(color: gray300_inactivated),
                        ),
                        Icon(
                          Icons.navigate_next,
                          color: gray300_inactivated,
                          size: 22,
                        )
                      ],
                    ),
                  ),
                  onTap: onPressedTop),
              SizedBox(width: 16),
              /* RIGHT ACTION BUTTON */
              ElevatedButton(
                child: Text(
                  bottomButtonName,
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
                onPressed: onPressedBottom,
              )
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
