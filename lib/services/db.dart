import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:an_muk_so/models/food.dart';
import 'package:an_muk_so/models/notice.dart';
import 'package:an_muk_so/models/user.dart';

class DatabaseService {
  final String uid;
  final String itemSeq;
  final String categoryName;

  //다은 카테고리 추가
  DatabaseService({this.uid, this.itemSeq, this.categoryName, Itemseq});

  /* Food List */
  // collection reference
  final CollectionReference foodCollection =
  FirebaseFirestore.instance.collection('Foods');
  Query foodQuery = FirebaseFirestore.instance.collection('Foods');

  //foodSnapshot 값 get이랑 set에서 해주기
  Stream<List<Food>> foodsSnapshots;
  Stream<List<SavedFood>> foodsFromUserSnapshots;


  Stream<List<Food>> setForSearch(String searchVal, int limit) {
    foodQuery = foodQuery
        .where('ITEM_NAME', isGreaterThanOrEqualTo: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .limit(limit);

    foodsSnapshots = foodQuery.snapshots().map(_foodListFromSnapshot);

    return foodsSnapshots;
  }

  ///NEW FOOD list 추가하기 위해서 만드는 코드
  // collection reference
  final CollectionReference newFoodCollection =
  FirebaseFirestore.instance.collection('NewProductLists'); //NewFood collection으로 바꾸기
  Query newFoodQuery = FirebaseFirestore.instance.collection('NewProductLists');//NewFood collection으로 바꾸기
  Stream<List<NewFood>> newFoodsSnapshots;



  //for search from User Foods
  Stream<List<Food>> setForSearchFromAllAfterRemainStartAt(
      String searchVal, int limit) {
    foodQuery = foodQuery
        .where('searchNameList', arrayContains: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .limit(limit);

    foodsSnapshots = foodQuery.snapshots().map(_foodListFromSnapshot);

    return foodsSnapshots;
  }

  Stream<List<Food>> setForSearchFromAllStartAtSearch(
      String searchVal, int limit) {
    foodQuery = foodQuery
        .where('searchNameList', arrayContains: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .startAt([searchVal]).limit(limit);

    foodsSnapshots = foodQuery.snapshots().map(_foodListFromSnapshot);

    return foodsSnapshots;
  }

  //food list from snapshot
  List<Food> _foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Food(
          barCode: doc.data()['BAR_CODE'] ?? '',
          entpName: doc.data()['ENTP_NAME'] ?? '',
         // ingrName: doc.data()['INGR_NAME'] ?? '',
          itemName: doc.data()['ITEM_NAME'] ?? '',
          itemSeq: doc.data()['ITEM_SEQ'] ?? '',
         // materialName: doc.data()['MATERIAL_NAME'] ?? '',
          warningData: doc.data()['WARNING_DATA'] ?? '',
          totalRating: doc.data()['totalRating'] ?? 0,
          numOfReviews: doc.data()['numOfReviews'] ?? 0,
          searchNameList: doc.data()['searchNameList'] ?? [],
          rankCategory: doc.data()['RANK_CATEGORY'] ?? '',
          itemCountry: doc.data()['ITEM_COUNTRY'] ?? '',

      );
    }).toList();
  }

  /* Food */
  // food data from snapshots
  Food _foodFromSnapshot(DocumentSnapshot snapshot) {
    return Food(
      barCode: snapshot.data()['BAR_CODE'] ?? '',

      entpName: snapshot.data()['ENTP_NAME'] ?? '',

   //   ingrName: snapshot.data()['INGR_NAME'] ?? '',
      itemName: snapshot.data()['ITEM_NAME'] ?? '',

      itemSeq: snapshot.data()['ITEM_SEQ'] ?? '',
   //   materialName: snapshot.data()['MATERIAL_NAME'] ?? '',

      warningData: snapshot.data()['WARNING_DATA'] ?? '',

      totalRating: snapshot.data()['totalRating'] ?? 0,

      numOfReviews: snapshot.data()['numOfReviews'] ?? 0,
        rankCategory: snapshot.data()['RANK_CATEGORY'] ?? '',
      itemCountry: snapshot.data()['ITEM_COUNTRY'] ?? '',

    );
  }

  // get food doc stream
  Stream<Food> get foodData {
    return foodCollection.doc(itemSeq).snapshots().map(_foodFromSnapshot);
  }

  /* NEW Food list flow */
  List<NewFood> _newFoodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return NewFood(
        itemName: doc.data()['ITEM_NAME'] ?? '',
        itemSeq: doc.data()['ITEM_SEQ'] ?? '',
        rankCategory: doc.data()['RANK_CATEGORY'] ?? '카테고리 없음',
      );
    }).toList();
  }

  // get new food doc stream

  //get food list stream
  Stream<List<NewFood>> listOfNewFoodData() {
    newFoodsSnapshots = newFoodQuery.snapshots().map(_newFoodListFromSnapshot);
    return newFoodsSnapshots;
  }


  /* User */
  // collection reference
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection('users');

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      agreeDate: snapshot.data()['agreeDate'] ?? '',
      sex: snapshot.data()['sex'] ?? '',
      nickname: snapshot.data()['nickname'] ?? '',
      birthYear: snapshot.data()['birthYear'] ?? '',
      //isPregnant: snapshot.data()['isPregnant'] ?? false,
      //keywordList: snapshot.data()['keywordList'] ?? [],
      //selfKeywordList: snapshot.data()['selfKeywordList'] ?? [],
      favoriteList: snapshot.data()['favoriteList'] ?? [],
      searchList: snapshot.data()['searchList'] ?? [],
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  Future<void> addUser(agreeDate) async {
    return await userCollection.doc(uid).set({
      'agreeDate': agreeDate ?? '',
    });
  }

  Future<void> deleteUser(userId) async {
    return await userCollection.doc(userId).delete();
  }

  // update user doc
  Future<void> updateUserPrivacy(nickname, birthYear, sex) async {
    return await userCollection.doc(uid).update({
      'nickname': nickname ?? '',
      'birthYear': birthYear ?? '',
      'sex': sex ?? '',
    });
  }

  Future<void> updateUserKeywordList(keywordList) async {
    return await userCollection.doc(uid).update({
      'keywordList': keywordList ?? [],
    });
  }

  Future<void> updateUserSelfKeywordList(selfKeywordList) async {
    return await userCollection.doc(uid).update({
      'selfKeywordList': selfKeywordList ?? [],
    });
  }

  Future<List> getKeywordList() async {
    DocumentSnapshot ds = await userCollection.doc(uid).get();
    return ds.data()['keywordList'];
  }

  /* Saved List */
  //food list from snapshot
      List<SavedFood> _savedFoodListFromSnapshot(QuerySnapshot snapshot) {
        return snapshot.docs.map((doc) {
          return SavedFood(
            itemName: doc.data()['ITEM_NAME'] ?? '',
            itemSeq: doc.data()['ITEM_SEQ'] ?? '',
            rankCategory: doc.data()['RANK_CATEGORY'] ?? '카테고리 없음',
            expiration: doc.data()['expiration'] ?? '',
            //etcOtcCode: doc.data()['etcOtcCode'] ?? '',
          );
        }).toList();
      }

  //for search from User foods
      Stream<List<SavedFood>> setForSearchFromUser(String searchVal, int limit) {
        //print('### uid is $uid');
        Query foodFromUserQuery = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('savedList');

        foodFromUserQuery = foodFromUserQuery
            .where('searchNameList', arrayContains: searchVal)
            .orderBy('ITEM_NAME', descending: false)
            .limit(limit);

        foodsFromUserSnapshots =
            foodFromUserQuery.snapshots().map(_savedFoodListFromSnapshot);

        return foodsFromUserSnapshots;
      }

  Future<void> deleteSavedFoodData(String foodItemSeq) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(foodItemSeq)
        .delete();
  }

  //get food list stream
  Stream<List<SavedFood>> get savedFoods {
    return userCollection
        .doc(uid)
        .collection('savedList')
        .orderBy('savedTime', descending: true)
        .snapshots()
        .map(_savedFoodListFromSnapshot);
  }

  Future<void> addSavedList(itemName, itemSeq, rankCategory, expiration,
      searchNameList) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(itemSeq)
        .set({
      'ITEM_NAME': itemName ?? '',
      'ITEM_SEQ': itemSeq ?? '',
      'RANK_CATEGORY': rankCategory ?? '',
      'expiration': expiration ?? '',
      'searchNameList': searchNameList ?? [],
      'savedTime': DateTime.now()
    });
  }

  Future<void> updateSavedList(expiration) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(itemSeq)
        .set({
      'expiration': expiration ?? '',
    });
  }

  /* Policy */
  // collection reference
  final CollectionReference policyCollection =
  FirebaseFirestore.instance.collection('Policy');

  // privacy from snapshots
  String _termsFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data()['terms'] ?? '';
  }

  // get privacy stream
  Stream<String> get terms {
    return policyCollection.doc('terms').snapshots().map(_termsFromSnapshot);
  }

  // privacy from snapshots
  String _privacyFromSnapshot(DocumentSnapshot snapshot) {
    return snapshot.data()['privacy'] ?? '';
  }

  // get privacy stream
  Stream<String> get privacy {
    return policyCollection
        .doc('privacy')
        .snapshots()
        .map(_privacyFromSnapshot);
  }

  // get TotalRating stream
  Future<num> getTotalRating() async {
    DocumentSnapshot ds = await foodCollection.doc(itemSeq).get();
    return ds.data()["totalRating"];
  }

  Future<String> getCategoryOfFood() async {
    DocumentSnapshot snap = await foodCollection.doc(itemSeq).get();
    String categoryName = snap.data()["RANK_CATEGORY"] ?? '카테고리 없음';
    return categoryName;
  }

  Future<void> updateTotalRating(num rating, num length) async {
    return await foodCollection.doc(itemSeq).update({
      'totalRating': rating,
      'numOfReviews': length,
    });
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      var doc = await userCollection.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> isUnique(newNickname) async {
    final QuerySnapshot result =
    await userCollection.where('nickname', isEqualTo: newNickname).get();
    return result.docs.isEmpty;
  }

  Future<void> removeFromFavoriteList(String foodItemSeq) async {
    return await userCollection.doc(uid).update({
      'favoriteList': FieldValue.arrayRemove([foodItemSeq]),
    });
  }

  Future<void> addToFavoriteList(String foodItemSeq) async {
    return await userCollection.doc(uid).update({
      'favoriteList': FieldValue.arrayUnion([foodItemSeq]),
    });
  }

  Future<String> itemSeqFromBarcode(barcode) async {
    var result =
    await foodCollection.where('BAR_CODE', isEqualTo: barcode).get();
    var data;

    if (result.docs.isEmpty) {
      data = null;
    } else {
      data = result.docs.first.data()['ITEM_SEQ'] ?? null;
    }

    return data;
  }

  Query noticeQuery = FirebaseFirestore.instance.collection('Notices');

  Stream<List<Notice>> get noticeData {
    noticeQuery = noticeQuery.orderBy('date', descending: true);

    return noticeQuery.snapshots().map(_noticeListFromSnapshot);
  }

  List<Notice> _noticeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Notice(
        title: doc.data()['title'] ?? '',
        dateString: doc.data()['date'] ?? '',
        contents: doc.data()['contents'] ?? [],
      );
    }).toList();
  }

  Future<String> getNickName() async {
    DocumentSnapshot snap = await userCollection.doc(uid).get();
    return snap.data()["nickname"];
  }

  Future<void> deleteFromFavoriteList(String itemSeq) async {
    return await userCollection.doc(uid).update({
      'favoriteList': FieldValue.arrayRemove([itemSeq]),
    });
  }

  final CollectionReference inquiryCollection =
  FirebaseFirestore.instance.collection('Inquiry');

  Future<void> createInquiry(index, title, body, from) async {
    String type;
    if (index == 1)
      type = '1. 상품 정보 문의 및 요청';
    else if (index == 2)
      type = '2. 서비스 불편, 오류 제보';
    else if (index == 3)
      type = '3. 사용 방법, 기타 문의';
    else if (index == 4)
      type = '4. 의견 제안, 칭찬';
    else if (index == 5)
      type = '5. 제휴 문의';
    else
      type = '';

    print('$type, $title, $body, $from');

    return await inquiryCollection.add({
      'type': type,
      'title': title,
      'body': body,
      'from': from,
    });
  }
}
