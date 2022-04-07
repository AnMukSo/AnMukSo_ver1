import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:an_muk_so/models/review.dart';
import 'package:an_muk_so/models/user.dart';
import 'package:an_muk_so/review/review_list.dart';
import 'package:an_muk_so/services/review.dart';
import 'package:an_muk_so/shared/customAppBar.dart';
import 'package:an_muk_so/review/review_pill_info.dart';
import 'package:an_muk_so/theme/colors.dart';

class SeeMyReview extends StatefulWidget {
  final String foodItemSeq;

  SeeMyReview(this.foodItemSeq,);

  @override
  _SeeMyReviewState createState() => _SeeMyReviewState();
}

class _SeeMyReviewState extends State<SeeMyReview> {
  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return Scaffold(
      appBar: CustomAppBarWithGoToBack("리뷰",  Image(
          image: AssetImage('assets/an_icon_resize/An_Back.png')), 0.5),
        backgroundColor: gray0_white,
      body: StreamBuilder<List<Review>>(
        stream: ReviewService().findUserReview(widget.foodItemSeq, user.uid),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List<Review> reviews = snapshot.data;
            // return Text(review[0].effectText);
            return ListView(
              children: [
                ReviewPillInfo(widget.foodItemSeq),
                reviews.length == 0 ?
                    Container()
                : ReviewList("", "none", widget.foodItemSeq, type: "mine", review: reviews[0]),
              ],
            );
          }
          else {
              print("FAIL");
            return Container();
          }
        }
      )
    );
  }



}
