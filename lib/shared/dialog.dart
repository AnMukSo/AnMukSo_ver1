import 'package:flutter/material.dart';
//import 'package:an_muk_so/services/review.dart';
//import 'package:an_muk_so/shared/ok_dialog.dart';
import 'package:an_muk_so/theme/colors.dart';

class AMSDialog extends StatelessWidget {
  final BuildContext context;
  final String bodyString;
  final String leftButtonName;
  final String rightButtonName;
  final Function leftOnPressed;
  final Function rightOnPressed;

  const AMSDialog({
    Key key,
    this.context,
    @required this.bodyString,
    @required this.leftButtonName,
    @required this.rightButtonName,
    @required this.leftOnPressed,
    @required this.rightOnPressed,
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
              SizedBox(height: 16),
              /* BODY */
              Text(bodyString,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: gray700),
                  textAlign: TextAlign.center),
              SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /* LEFT ACTION BUTTON */
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
                      onPressed: leftOnPressed),
                  SizedBox(width: 16),
                  /* RIGHT ACTION BUTTON */
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
                      onPressed: rightOnPressed)
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> showDeleteDialog(record) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              /* BODY */
              Text(bodyString,
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
                  /* RIGHT ACTION BUTTON */

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
                      //TODO:리뷰 삭제할 때 필요한 거 처리해야함!
                      // onPressed: () async {
                      //   Navigator.of(context).pop();
                      //   await ReviewService(documentId: record.documentId)
                      //       .deleteReviewData();
                      //   OkDialog(
                      //     context: context,
                      //     dialogIcon: Icon(Icons.check, color: primary300_main),
                      //     bodyString: '리뷰가 삭제되었습니다',
                      //     buttonName: '확인',
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //       Navigator.pop(context);
                      //     },
                      //   ).showWarning();
                      // }
                      )
                ],
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
