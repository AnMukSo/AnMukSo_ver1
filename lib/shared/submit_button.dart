import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

class LoginAMSSubmitButton extends StatelessWidget {
  final BuildContext context;
  final bool isDone;
  final String textString;
  final Function onPressed;
  final Color textColor;

  const LoginAMSSubmitButton({
    Key key,
    @required this.context,
    @required this.isDone,
    @required this.textString,
    @required this.onPressed,
    @required this.textColor
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(context).size.width /2 - 22,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isDone ? primary400_line : textColor,
          width: 2,
        ),
        gradient: isDone
            ?
        LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
            <Color>[
              Colors.white,
              Colors.white,
            ])
            : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Colors.white,
              Colors.white,
            ]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                textString,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: textColor),
              ),
            )),
      ),
    );
  }
}

class RegisterAndFindPasswordButton extends StatelessWidget {
  final BuildContext context;
  final String textString;
  final Function onPressed;
  final Color textColor;
  final Color boxColor;

  const RegisterAndFindPasswordButton({
    Key key,
    @required this.context,
    @required this.textString,
    @required this.onPressed,
    @required this.textColor,
    @required this.boxColor

  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 22,
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: boxColor,
          width: 2,
        ),
      ),
      child: Material(
        color: boxColor,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                textString,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: textColor),
              ),
            )),
      ),
    );
  }
}


class AMSSubmitButton extends StatelessWidget {
  final BuildContext context;
  final bool isDone;
  final String textString;
  final Function onPressed;

  const AMSSubmitButton({
    Key key,
    @required this.context,
    @required this.isDone,
    @required this.textString,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 44.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isDone ? primary300_main : gray300_inactivated,
          width: 1,
        ),
        gradient: isDone
            ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              gradient_button_long_start,
              gradient_button_long_end,
            ])
            : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              gradient_button_inactivated_start,
              gradient_button_inactivated_end,
            ]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: Text(
                textString,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: gray0_white),
              ),
            )),
      ),
    );
  }
}
