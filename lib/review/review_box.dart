import 'package:flutter/material.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/theme/colors.dart';

class ReviewBox extends StatelessWidget {
  final BuildContext context;
  final Review review;
  final String type;

  const ReviewBox({
    Key key,
    // this.context,
    @required this.context,
    @required this.review,
    @required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(9.5),
        decoration: BoxDecoration(
            color: gray50,
            border: Border.all(color: gray50),
            borderRadius: BorderRadius.all(Radius.circular(4.0))),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  type == "effect" ? "상품평가" : type == "sideEffect" ? "알러지 반응" : "총평",
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: gray900, fontSize: 12),
                ),
                Container(width:3),
                _face(type == "effect" ? review.effect : type == "sideEffect" ? review.sideEffect : "",),
              ],
            ),
            Container(height:4),

            if(type == "effect")
              Text(review.effectText),
            if(type == "sideEffect" && review.sideEffect == "yes")
              Text(review.sideEffectText),
            if(type == "sideEffect" && review.sideEffect == "no")
              Container(),
          ],
        )
    );


  }

  Widget _face(face) {
    if(face == "good")
      return Row(
        children: [
          Icon(
            Icons.sentiment_satisfied_rounded,
            color: primary300_main,
            size: 16,
          ),
          SizedBox(width:1),
          Text("좋아요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: primary400_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "no")
      return Row(
        children: [
          Icon(
            Icons.sentiment_satisfied_rounded,
            color: primary300_main,
            size: 16,
          ),
          SizedBox(width:1),
          Text("없어요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: primary400_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "soso")
      return Row(
        children: [
          Icon(
            Icons.sentiment_neutral_rounded,
            color: yellow_line,
            size: 16,
          ),
          SizedBox(width:1),
          Text("보통이에요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: yellow_line, fontSize: 12
            ),
          )
        ],
      );
    if(face == "bad")
      return Row(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color:  warning,
            size: 16,
          ),
          SizedBox(width:1),
          Text("별로에요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: warning, fontSize: 12
            ),
          )
        ],
      );
    if(face == "yes")
      return Row(
        children: [
          Icon(
            Icons.sentiment_very_dissatisfied_rounded,
            color:  warning,
            size: 16,
          ),
          SizedBox(width:1),
          Text("있어요",
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                color: warning, fontSize: 12
            ),
          )
        ],
      );
  }
}
