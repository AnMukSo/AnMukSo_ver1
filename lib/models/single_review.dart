import 'package:cloud_firestore/cloud_firestore.dart';

class SingleReview {
  final String effect;
  final String sideEffect;
  final String effectText;
  final String sideEffectText;
  final String overallText;
  List<String> favoriteSelected = List<String>();
  final num starRating;
  var noFavorite;
  final String uid;
  final String id;
  final String documentId;

  final DocumentReference reference;

  SingleReview.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['date'] != null),
        :

        effect = map['effect'],
        sideEffect = map['sideEffect'],
        effectText = map['effectText'],
        sideEffectText = map['sideEffectText'],
        overallText = map['overallText'],
        id = map['id'],
      //favoriteSelected = map['favoriteSelected'],
        noFavorite = map['noFavorite'],
        uid = map['uid'],
        starRating = map['starRating'],
        documentId = map['documentId'];

  SingleReview.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}