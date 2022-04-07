//ㅇㅋ
import 'package:cloud_firestore/cloud_firestore.dart';

import '../ranking.dart';

class FirebaseApi {

  static Future<QuerySnapshot> getFoods(
      int limit, String _filterOrSort, {DocumentSnapshot startAfter //어느부분이 리미트 지점인지 그 이후에 있는 user를 불러온다
      }) async {


    Query refFoods = FirebaseFirestore.instance.collection('Foods');

    switch (_filterOrSort) {

      case "별점순":
        if(getCategory == '전체'){
          refFoods = refFoods
             // .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else {

          refFoods = refFoods
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
            //  .orderBy('totalRating', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }

        break;

      case "리뷰 많은 순":
        if(getCategory == '전체'){
          refFoods = refFoods
              .orderBy('numOfReviews', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        else{
          refFoods = refFoods
              .where('RANK_CATEGORY', isEqualTo: getCategory) //;
              .orderBy('numOfReviews', descending: true)
              .orderBy('ITEM_NAME', descending: false)
              .limit(limit);
        }
        break;
    }

    if (startAfter == null) { //그 다음 상품이 없다면 null
      return refFoods.get();
    } else {//그 다음 상품이 존재한다면 그 다음 상품부터 시작해라
      return refFoods.startAfterDocument(startAfter).get();
    }
  }
}
