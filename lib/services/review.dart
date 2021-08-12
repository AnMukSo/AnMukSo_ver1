import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:an_muk_so/models/report_review.dart';
import 'package:an_muk_so/models/review.dart';


class ReviewService {

  final String documentId;
  ReviewService({ this.documentId });

  final CollectionReference reviewCollection = FirebaseFirestore.instance.collection('Reviews');
  final CollectionReference reportReviewCollection = FirebaseFirestore.instance.collection('ReportReview');

  Future<void> updateReviewData(String effect, String sideEffect, String effectText, String sideEffectText, num starRating) async {
    return await reviewCollection.doc(documentId).update({
      'effect': effect,
      'sideEffect': sideEffect,
      'effectText': effectText,
      'sideEffectText': sideEffectText,
      'starRating': starRating,
    });
  }


  Future<void> tapToRate(num rating, String uid) async {
    return await reviewCollection.doc(documentId).update({
      'starRating': rating,
      'seqNum': documentId,
      'uid': uid
    });
  }

  Future<void> getRate(num rating, String uid) async {
    return await reviewCollection.doc(documentId).update({
      'starRating': rating,
      'seqNum': documentId,
      'uid': uid
    });
  }


  Future<void> decreaseFavorite(String docId, String currentUserUid) async {
    return await reviewCollection.doc(docId).update({
      'favoriteSelected': FieldValue.arrayRemove([currentUserUid]),
      'noFavorite': FieldValue.increment(-1),
    });
  }

  Future<void> increaseFavorite(String docId, String currentUserUid) async {
    return await reviewCollection.doc(docId).update({
      'favoriteSelected': FieldValue.arrayUnion([currentUserUid]),
      'noFavorite': FieldValue.increment(1),
    });
  }


  List<Review> _reviewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      // print(doc.data()['registrationDate'].toString());
      return Review(
        effect: doc.data()['effect'] ?? '',
        sideEffect: doc.data()['sideEffect'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        //List<String> favoriteSelected = List<String>();
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        starRating: doc.data()['starRating'] ?? 0,
        noFavorite: doc.data()['noFavorite'] ?? 0,
        uid: doc.data()['uid'] ?? '',
        documentId: doc.id ?? '',
        registrationDate: doc.data()['registrationDate'],
        entpName: doc.data()['entpName'],
        itemName: doc.data()['itemName'],
        seqNum: doc.data()['seqNum'],
        nickName: doc.data()['nickName'],

      );
    }).toList();
  }

  Query reviewQuery = FirebaseFirestore.instance.collection('Reviews');
  Stream<List<Review>> reviewsSnapshots;



  Stream<List<Review>> get reviews {
//    reviewQuery = reviewQuery.orderBy('registrationDate', descending: false);
//
//    reviewsSnapshots = reviewQuery.snapshots().map(_reviewListFromSnapshot);
//    return reviewsSnapshots;

    return reviewCollection.snapshots()
        .map(_reviewListFromSnapshot);
  }


  Stream<List<Review>> getReviews(String seqNum) {
    return reviewCollection
    // .orderBy('registrationDate', descending: true)
        .where("seqNum", isEqualTo: seqNum)
    // .orderBy('registrationDate', descending: true)
        .snapshots()
        .map(_reviewListFromSnapshot);
  }

  Stream<List<Review>> getUserReviews(String uid) {
    return reviewCollection.where("uid", isEqualTo: uid).snapshots()
        .map(_reviewListFromSnapshot);
  }


  Future<bool> findUserWroteReview(String seqNum, String user) async {
    final QuerySnapshot result =
    await reviewCollection.where("seqNum", isEqualTo: seqNum).where("uid", isEqualTo: user).get();
    return result.docs.isEmpty;
  }

  Stream<List<Review>> findUserReview(String seqNum, String user) {
    reviewQuery = reviewQuery.where("seqNum", isEqualTo: seqNum).where("uid", isEqualTo: user);
    reviewsSnapshots = reviewQuery.snapshots().map(_reviewListFromSnapshot);
    return reviewsSnapshots;
  }



  Stream<Review> getSingleReview(String documentId) {
    return reviewCollection.doc(documentId).snapshots().map((doc) {
      return Review(
        effect: doc.data()['effect'] ?? '',
        sideEffect: doc.data()['sideEffect'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        //List<String> favoriteSelected = List<String>();
        favoriteSelected: doc.data()['favoriteSelected'] ?? '',
        starRating: doc.data()['starRating'] ?? 0,
        noFavorite: doc.data()['noFavorite'] ?? 0,
        uid: doc.data()['uid'] ?? '',
        documentId: doc.id ?? '',
        registrationDate: doc.data()['registrationDate'],
        entpName: doc.data()['entpName'],
        itemName: doc.data()['itemName'],
        seqNum: doc.data()['seqNum'],
        nickName: doc.data()['nickName'],

      );
    });
  }

  Future<void> deleteReviewData() async {
    return await reviewCollection.doc(documentId).delete();
  }

  static Future<QuerySnapshot> newgetReviews(int limit) async {
    final refReviews = FirebaseFirestore.instance.collection('Reviews').orderBy('registrationDate').limit(limit);
//        .orderBy("registrationDate", "asc")

    return refReviews.get();
  }

  static Future<QuerySnapshot> getReviewData(int limit, {DocumentSnapshot startAfter,}) async {
    final refReviews = FirebaseFirestore.instance.collection('Reviews').orderBy('registrationDate').limit(limit);

    if (startAfter == null) {
      return refReviews.get();
    } else {
      return refReviews.startAfterDocument(startAfter).get();
    }
  }

  Future<bool> checkReviewIsReported() async {
    final snapshot = await reportReviewCollection.doc(documentId).get();
    return (snapshot.exists);
  }


  Future<void> reportReview(review, report, reporterUid) async {
    String reportContent;
    if(report == 1) reportContent = "광고, 홍보 / 거래시도";
    if(report == 2) reportContent = "욕설, 음란어 사용";
    if(report == 3) reportContent = "약과 무관한 리뷰 작성";
    if(report == 4) reportContent = "개인 정보 노출";
    if(report == 5) reportContent = "기타 (명예훼손)";




    return await reportReviewCollection.add({
      'reviewDocumentId': review.documentId,
      'reportContent': FieldValue.arrayUnion([reportContent]),
      'effectText': review.effectText,
      'sideEffectText': review.sideEffectText,
      'itemName': review.itemName,
      'reporterUid': FieldValue.arrayUnion([reporterUid]),
    });

  }


  Future<void> reportAlreadyReportedReview(review, reporterUid, report) async {
    String reportContent;
    if(report == 1) reportContent = "광고, 홍보 / 거래시도";
    if(report == 2) reportContent = "욕설, 음란어 사용";
    if(report == 3) reportContent = "약과 무관한 리뷰 작성";
    if(report == 4) reportContent = "개인 정보 노출";
    if(report == 5) reportContent = "기타 (명예훼손)";

    return await reportReviewCollection.doc(review.documentId).update({
      'reportContent': FieldValue.arrayUnion([reportContent]),
      'reporterUid': FieldValue.arrayUnion([reporterUid]),
    });
  }


  Stream<List<ReportReview>> getReport(String documentId) {
    return reviewCollection
    // .orderBy('registrationDate', descending: true)
        .where("reviewDocumentId", isEqualTo: documentId)
        .snapshots()
        .map(_reportListFromSnapshot);
  }

  List<ReportReview> _reportListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ReportReview(
        reviewDocumentId: doc.data()['reviewDocumentId'] ?? '',
        reportContent: doc.data()['reportContent'] ?? '',
        effectText: doc.data()['effectText'] ?? '',
        sideEffectText: doc.data()['sideEffectText'] ?? '',
        itemName: doc.data()['itemName'],
        reporterUid: doc.data()['reporterUid'] ?? '',

      );
    }).toList();
  }

}

