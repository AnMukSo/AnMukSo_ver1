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

  /* Drug List */
  // collection reference
  final CollectionReference drugCollection =
  FirebaseFirestore.instance.collection('Foods');
  Query drugQuery = FirebaseFirestore.instance.collection('Foods');

  //drugSnapshot 값 get이랑 set에서 해주기
  Stream<List<Food>> drugsSnapshots;
  Stream<List<SavedFood>> drugsFromUserSnapshots;


  Stream<List<Food>> setForSearch(String searchVal, int limit) {
    drugQuery = drugQuery
        .where('ITEM_NAME', isGreaterThanOrEqualTo: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .limit(limit);

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);

    return drugsSnapshots;
  }



  //for search from User drugs
  Stream<List<Food>> setForSearchFromAllAfterRemainStartAt(
      String searchVal, int limit) {
    drugQuery = drugQuery
        .where('searchNameList', arrayContains: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .limit(limit);

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);

    return drugsSnapshots;
  }

  Stream<List<Food>> setForSearchFromAllStartAtSearch(
      String searchVal, int limit) {
    drugQuery = drugQuery
        .where('searchNameList', arrayContains: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .startAt([searchVal]).limit(limit);

    drugsSnapshots = drugQuery.snapshots().map(_drugListFromSnapshot);

    return drugsSnapshots;
  }

  //drug list from snapshot
  List<Food> _drugListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Food(
          barCode: doc.data()['BAR_CODE'] ?? '',
          //chart: doc.data()['CHART'] ?? '',

          //eeDocData: doc.data()['EE_DOC_DATA'] ?? '',
          entpName: doc.data()['ENTP_NAME'] ?? '',
          //entpNo: doc.data()['ENTP_NO'] ?? '',

          //etcOtcCode: doc.data()['ETC_OTC_CODE'] ?? '',
          ingrName: doc.data()['INGR_NAME'] ?? '',
          itemName: doc.data()['ITEM_NAME'] ?? '',

          itemSeq: doc.data()['ITEM_SEQ'] ?? '',
          //mainItemIngr: doc.data()['MAIN_ITEM_INGR'] ?? '',
          materialName: doc.data()['MATERIAL_NAME'] ?? '',

          nbDocData: doc.data()['NB_DOC_DATA'] ?? '',
          //permitKindName: doc.data()['PERMIT_KIND_NAME'] ?? '',
          //storageMethod: doc.data()['STORAGE_METHOD'] ?? '',
          //totalContect: doc.data()['TOTAL_CONTENT'] ?? '',

          //udDocData: doc.data()['UD_DOC_DATA'] ?? '',
          //udDocId: doc.data()['UD_DOC_ID'] ?? '',
          //validTerm: doc.data()['VALID_TERM'] ?? '',

          //category: doc.data()['PRDUCT_TYPE'] ?? '카테고리 없음',

          totalRating: doc.data()['totalRating'] ?? 0,
          numOfReviews: doc.data()['numOfReviews'] ?? 0,
          searchNameList: doc.data()['searchNameList'] ?? [],

          rankCategory: doc.data()['RANK_CATEGORY'] ?? ''
      );
    }).toList();
  }

  /* Drug */
  // drug data from snapshots
  Food _drugFromSnapshot(DocumentSnapshot snapshot) {
    return Food(
      barCode: snapshot.data()['BAR_CODE'] ?? '',
      //chart: snapshot.data()['CHART'] ?? '',

      //eeDocData: snapshot.data()['EE_DOC_DATA'] ?? '',
      entpName: snapshot.data()['ENTP_NAME'] ?? '',
      //entpNo: snapshot.data()['ENTP_NO'] ?? '',

      //etcOtcCode: snapshot.data()['ETC_OTC_CODE'] ?? '',
      ingrName: snapshot.data()['INGR_NAME'] ?? '',
      itemName: snapshot.data()['ITEM_NAME'] ?? '',

      itemSeq: snapshot.data()['ITEM_SEQ'] ?? '',
      //mainItemIngr: snapshot.data()['MAIN_ITEM_INGR'] ?? '',
      materialName: snapshot.data()['MATERIAL_NAME'] ?? '',

      nbDocData: snapshot.data()['NB_DOC_DATA'] ?? '',
      // permitKindName: snapshot.data()['PERMIT_KIND_NAME'] ?? '',
      // storageMethod: snapshot.data()['STORAGE_METHOD'] ?? '',
      // totalContect: snapshot.data()['TOTAL_CONTENT'] ?? '',

      //udDocData: snapshot.data()['UD_DOC_DATA'] ?? '',
      //udDocId: snapshot.data()['UD_DOC_ID'] ?? '',
      //validTerm: snapshot.data()['VALID_TERM'] ?? '',

      //category: snapshot.data()['PRDUCT_TYPE'] ?? '카테고리 없음',

      totalRating: snapshot.data()['totalRating'] ?? 0,

      numOfReviews: snapshot.data()['numOfReviews'] ?? 0,
    );
  }

  // get drug doc stream
  Stream<Food> get drugData {
    return drugCollection.doc(itemSeq).snapshots().map(_drugFromSnapshot);
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
      isPregnant: snapshot.data()['isPregnant'] ?? false,
      keywordList: snapshot.data()['keywordList'] ?? [],
      selfKeywordList: snapshot.data()['selfKeywordList'] ?? [],
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
  //drug list from snapshot
  List<SavedFood> _savedDrugListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return SavedFood(
        itemName: doc.data()['ITEM_NAME'] ?? '',
        itemSeq: doc.data()['ITEM_SEQ'] ?? '',
        category: doc.data()['PRDUCT_TYPE'] ?? '카테고리 없음',
        expiration: doc.data()['expiration'] ?? '',
        etcOtcCode: doc.data()['etcOtcCode'] ?? '',
      );
    }).toList();
  }

  //for search from User drugs
  Stream<List<SavedFood>> setForSearchFromUser(String searchVal, int limit) {
    //print('### uid is $uid');
    Query drugFromUserQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('savedList');

    drugFromUserQuery = drugFromUserQuery
        .where('searchNameList', arrayContains: searchVal)
        .orderBy('ITEM_NAME', descending: false)
        .limit(limit);

    drugsFromUserSnapshots =
        drugFromUserQuery.snapshots().map(_savedDrugListFromSnapshot);

    return drugsFromUserSnapshots;
  }

  Future<void> deleteSavedDrugData(String drugItemSeq) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(drugItemSeq)
        .delete();
  }

  //get drug list stream
  Stream<List<SavedFood>> get savedDrugs {
    return userCollection
        .doc(uid)
        .collection('savedList')
        .orderBy('savedTime', descending: true)
        .snapshots()
        .map(_savedDrugListFromSnapshot);
  }

  Future<void> addSavedList(itemName, itemSeq, category, etcOtcCode, expiration,
      searchNameList) async {
    return await userCollection
        .doc(uid)
        .collection('savedList')
        .doc(itemSeq)
        .set({
      'ITEM_NAME': itemName ?? '',
      'ITEM_SEQ': itemSeq ?? '',
      //'PRDUCT_TYPE': category ?? '카테고리 없음',
      'etcOtcCode': etcOtcCode ?? '',
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

  // get privacy stream
  Future<num> getTotalRating() async {
    DocumentSnapshot ds = await drugCollection.doc(itemSeq).get();
    return ds.data()["totalRating"];
  }

  Future<String> getCategoryOfDrug() async {
    DocumentSnapshot snap = await drugCollection.doc(itemSeq).get();
    String categoryName = snap.data()["PRDUCT_TYPE"] ?? '카테고리 없음';
    return categoryName;
  }

  Future<void> updateTotalRating(num rating, num length) async {
    return await drugCollection.doc(itemSeq).update({
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

  Future<void> removeFromFavoriteList(String drugItemSeq) async {
    return await userCollection.doc(uid).update({
      'favoriteList': FieldValue.arrayRemove([drugItemSeq]),
    });
  }

  Future<void> addToFavoriteList(String drugItemSeq) async {
    return await userCollection.doc(uid).update({
      'favoriteList': FieldValue.arrayUnion([drugItemSeq]),
    });
  }

  Future<String> itemSeqFromBarcode(barcode) async {
    var result =
    await drugCollection.where('BAR_CODE', isEqualTo: barcode).get();
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
      type = '1. 의약품 정보 문의 및 요청';
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
