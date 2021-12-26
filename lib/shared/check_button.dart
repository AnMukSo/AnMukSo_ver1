import 'package:flutter/material.dart';
import 'package:an_muk_so/theme/colors.dart';

class CheckButton extends StatefulWidget {
  final String index;

  const CheckButton({Key key, this.index}) : super(key: key);

  @override
  _CheckButtonState createState() => _CheckButtonState();
}

class _CheckButtonState extends State<CheckButton> {
  bool _hasBeenPressed = false;

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.only(right: 10.0),
     child: SizedBox(
       width: 25,
       height: 25,
       child: RaisedButton(
         shape: new RoundedRectangleBorder(
           borderRadius: new BorderRadius.circular(30.0),
         ),
            padding: EdgeInsets.zero,
            child: new Text(widget.index),
            textColor: gray900,
            // 2
            color: _hasBeenPressed ? primary300_main : gray400,
            // 3
            onPressed: () => {
              setState(() {
                _hasBeenPressed = !_hasBeenPressed;
              })
            },
          ),
     ),
   );

  }
}
